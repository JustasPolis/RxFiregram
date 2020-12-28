//
//  TestViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
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
        let emailFormButtonTap: Driver<Void>
        let usernameFormButtonTap: Driver<Void>
        let passwordFormButtonTap: Driver<Void>
        let signUpButtonTap: Driver<Void>
        let backButtonTap: Driver<Void>
    }

    struct Output {
        let navigateBack: Driver<Void>
        let validatedEmail: Driver<ValidationState>
        let validatedUsername: Driver<ValidationState>
        let validatedPassword: Driver<ValidationState>
        let signUp: Driver<Void>
        let loading: Driver<Bool>
        let error: Driver<AuthErrorCode?>
    }

    func transform(input: Input) -> Output {

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let validatedEmail = input.emailFormButtonTap
            .withLatestFrom(input.email)
            .flatMapLatest { [unowned self] email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .networkError)
            }

        let validatedUsername = input.usernameFormButtonTap
            .withLatestFrom(input.username)
            .flatMapLatest { [unowned self] username in
                self.validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .networkError)
            }

        let validatedPassword = input.passwordFormButtonTap
            .withLatestFrom(input.password)
            .map { [unowned self] password in
                self.validationService.validatePassword(password)
            }

        let navigateBack = input.backButtonTap.flatMap { [unowned self] in
            self.sceneCoordinator.pop(animated: true)
        }

        let textFieldInputs = Driver.combineLatest(input.email, input.password, input.username)

        enum State {
            case success
            case error
        }

        // produce error isjungt interneta, du errotrackeriai, ka ismes ??

        let repeatUsernameValidation = input.signUpButtonTap
            .withLatestFrom(input.username)
            .flatMap { [unowned self] username in
                self.validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .error(message: "Error Contanting server"))
            }

        let signUp = input.signUpButtonTap
            .withLatestFrom(textFieldInputs)
            .flatMap { [unowned self] email, _, username in
                self.signUp(email: email, password: "weqe", username: username)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.flatMap { [unowned self] in
                self.sceneCoordinator.transition(to: Scene.home)
            }

        let loading = activityIndicator.asDriver()

        let error = errorTracker
            .asDriver()
            .map { error in
                AuthErrorCode(rawValue: error._code)
            }

        return Output(navigateBack: navigateBack,
                      validatedEmail: validatedEmail,
                      validatedUsername: validatedUsername,
                      validatedPassword: validatedPassword,
                      signUp: signUp,
                      loading: loading,
                      error: error)
    }

    func signUp(email: String, password: String, username: String) -> Observable<Void> {
        self.firebaseService.signUp(email: email, password: password).map { authData in
            User(id: authData.id, username: username, profileImageUrl: "", email: authData.email ?? "")
        }.flatMap { user in
            self.firebaseService.storeUserInformation(user)
        }
    }
}
