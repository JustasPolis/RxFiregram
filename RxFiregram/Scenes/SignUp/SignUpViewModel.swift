//
//  SignUpViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import FirebaseAuth
import Resolver
import RxCocoa
import RxSwift
import RxSwiftExt

final class SignUpViewModel: ViewModelType {

    @Injected private var sceneCoordinator: SceneCoordinatorType
    @Injected private var validationService: ValidationServiceType
    @Injected private var firebaseService: FirebaseServiceType

    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let email: Driver<String>
        let signInButtonTap: Driver<Void>
        let signUpButtonTap: Driver<Void>
        let didEndEditingPassword: Driver<Void>
        let didEndEditingEmail: Driver<Void>
        let didEndEditingUsername: Driver<Void>
    }

    struct Output {
        let navigateToSignInScene: Driver<Void>
        let signUpEnabled: Driver<Bool>
        let validatedUsername: Driver<ValidationResult>
        let validatedEmail: Driver<ValidationResult>
        let signUp: Driver<Void>
        let authError: Driver<AuthErrorCode?>
        let isLoading: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let usernameInputChanged = input.didEndEditingUsername
            .withLatestFrom(input.username)
            .withPrevious()
            .didChange()

        let validatedUsername = input.didEndEditingUsername
            .take(if: usernameInputChanged)
            .withLatestFrom(input.username)
            .flatMapLatest { username -> Driver<ValidationResult> in
                self.validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let emailInputChanged = input.didEndEditingEmail
            .withLatestFrom(input.email)
            .withPrevious()
            .didChange()

        let validatedEmail = input.didEndEditingEmail
            .take(if: emailInputChanged)
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        let signUpTrigger = Driver.merge(input.signUpButtonTap, input.didEndEditingPassword)
        let emailAndPassword = Driver.combineLatest(input.email, input.password)

        let signUp = signUpTrigger
            .withLatestFrom(emailAndPassword)
            .flatMap { email, password in
                self.firebaseService.signUp(email: email, password: password)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.withLatestFrom(input.username) { authData, username in
                User(id: authData.id, username: username, profileImageUrl: "", email: authData.email ?? "")
            }.flatMap { user in
                self.firebaseService.storeUserInformation(user)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }

        let authError = errorTracker.asDriver()
            .map { error in
                AuthErrorCode(rawValue: error._code)
            }

        let isLoading = Driver.just(true)

        let signUpEnabled = Driver.just(false)

        return Output(navigateToSignInScene: navigateToSignInScene,
                      signUpEnabled: signUpEnabled,
                      validatedUsername: validatedUsername,
                      validatedEmail: validatedEmail,
                      signUp: signUp,
                      authError: authError,
                      isLoading: isLoading)
    }
}
