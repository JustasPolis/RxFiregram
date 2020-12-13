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
        let signUpTrigger: Driver<Void>
        let didEndEditingPassword: Driver<Void>
        let didEndEditingEmail: Driver<Void>
        let didEndEditingUsername: Driver<Void>
    }

    struct Output {
        let navigateToSignInScene: Driver<Void>
        let signUpEnabled: Driver<Bool>
        let validatedUsername: Driver<ValidationResult>
        let validatedEmail: Driver<ValidationResult>
        let validatedPassword: Driver<ValidationResult>
        let signUp: Driver<Void>
        let authError: Driver<AuthErrorCode?>
        let isLoading: Driver<Bool>
    }

    func signUp(email: String, password: String, username: String) -> Observable<Void> {
        self.firebaseService.signUp(email: email, password: password).map { authData in
            User(id: authData.id, username: username.lowercased(), profileImageUrl: "", email: authData.email ?? "")
        }.flatMap { user in
            self.firebaseService.storeUserInformation(user)
        }
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

        let passwordInputChanged = input.didEndEditingPassword
            .withLatestFrom(input.password)
            .withPrevious()
            .didChange()

        let validatedPassword = input.didEndEditingPassword
            .take(if: passwordInputChanged)
            .withLatestFrom(input.password)
            .map { password in
                self.validationService.validatePassword(password)
            }

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let authError = errorTracker.asDriver()
            .map { error in
                AuthErrorCode(rawValue: error._code)
            }

        let isLoading = activityIndicator.asDriver()

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        let textFieldInputs = Driver.combineLatest(input.email, input.password, input.username)

        let signUp = input.signUpTrigger
            .withLatestFrom(textFieldInputs)
            .flatMap { email, password, username in
                self.signUp(email: email, password: password, username: username)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }

        // username unique paziuret ar galim padaryt checka firebase DB
        
        let signUpEnabled = Driver.combineLatest(validatedUsername, validatedEmail, validatedPassword)
            { username, email, password in
                username.isValid &&
                    email.isValid &&
                    password.isValid
            }
            .distinctUntilChanged()

        return Output(navigateToSignInScene: navigateToSignInScene,
                      signUpEnabled: signUpEnabled,
                      validatedUsername: validatedUsername,
                      validatedEmail: validatedEmail,
                      validatedPassword: validatedPassword,
                      signUp: signUp,
                      authError: authError,
                      isLoading: isLoading)
    }
}
