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
    }

    struct Output {
        let navigateToSignInScene: Driver<Void>
        let signUpEnabled: Driver<Bool>
        let signUp: Driver<Void>
        let authError: Driver<Error>
        let isLoading: Driver<Bool>
        let validatedEmail: Driver<ValidationResult>
        let test2: Driver<(ValidationResult, ValidationResult)>
    }

    func signUp(email: String, password: String, username: String) -> Observable<Void> {
        self.firebaseService.signUp(email: email.lowercased(), password: password).map { authData in
            User(id: authData.id, username: username.lowercased(), profileImageUrl: "", email: authData.email ?? "")
        }.flatMap { user in
            self.firebaseService.storeUserInformation(user)
        }
    }

    // username kaip pagrindinis ID
    // username negali but empty

    func transform(input: Input) -> Output {

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let authError = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        // error -> username Error/ email Error
        // combine, tada .ok, .ok switch case su email ir username

        let emailInputChanged = input.signUpTrigger
            .withLatestFrom(input.email)
            .withPrevious()
            .didChange()

        let validatedEmail = input.signUpTrigger
            .withLatestFrom(input.email)
            .take(if: emailInputChanged)
            .flatMapLatest { email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let test = input.signUpTrigger
            .withLatestFrom(input.email)
            .take(if: emailInputChanged)
            .flatMapLatest { email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let test2 = Driver.zip(validatedEmail, test)

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

        let signUpEnabled = Driver.combineLatest(input.email, input.password, input.username) { email, password, username in
            !email.isEmpty && !password.isEmpty && !username.isEmpty
        }.startWith(false)
            .distinctUntilChanged()

        return Output(navigateToSignInScene: navigateToSignInScene,
                      signUpEnabled: signUpEnabled,
                      signUp: signUp,
                      authError: authError,
                      isLoading: isLoading,
                      validatedEmail: validatedEmail,
                      test2: test2)
    }
}
