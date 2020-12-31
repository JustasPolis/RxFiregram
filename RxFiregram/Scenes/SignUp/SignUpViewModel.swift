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
        let repeatUsernameValidation: Driver<ValidationState>
        let signUp: Driver<Void>
        let error: Driver<Error>
        let loading: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let loadingSubject = BehaviorSubject<Bool>(value: false)

        let errorTracker = ErrorTracker()

        let validatedEmail = input.emailFormButtonTap
            .withLatestFrom(input.email)
            .flatMap { [validationService] email in
                validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .networkError)
            }

        let validatedUsername = input.usernameFormButtonTap
            .withLatestFrom(input.username)
            .flatMap { [validationService] username in
                validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .networkError)
            }

        let validatedPassword = input.passwordFormButtonTap
            .withLatestFrom(input.password)
            .map { [validationService] password in
                validationService.validatePassword(password)
            }

        let navigateBack = input.backButtonTap.flatMap { [sceneCoordinator] in
            sceneCoordinator.pop(animated: true)
        }

        let textFieldInputs = Driver.combineLatest(input.email, input.password, input.username)

        // produce error isjungt interneta, du errotrackeriai, ka ismes ??

        let repeatUsernameValidation = input.signUpButtonTap
            .withLatestFrom(input.username)
            .flatMap { [validationService] username -> Driver<ValidationState> in
                loadingSubject.onNext(true)
                return validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .networkError)
            }.do(onNext: { state in
                switch state {
                    case .error, .networkError:
                        loadingSubject.onNext(false)
                    case .validating, .success:
                        loadingSubject.onNext(true)
                }
            })

        let signUp = repeatUsernameValidation
            .filter { $0 == .success }
            .withLatestFrom(textFieldInputs)
            .flatMap { email, _, username in
                self.signUp(email: email, password: "ddas", username: username)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: {
                loadingSubject.onNext(false)
            })

        let loading = loadingSubject
            .asDriverOnErrorJustComplete()
            .distinctUntilChanged()
            .debug()

        let error = errorTracker
            .asDriver()
            .debug()

        return Output(navigateBack: navigateBack,
                      validatedEmail: validatedEmail,
                      validatedUsername: validatedUsername,
                      validatedPassword: validatedPassword,
                      repeatUsernameValidation: repeatUsernameValidation,
                      signUp: signUp,
                      error: error,
                      loading: loading)
    }

    func validateUsername(username: String) -> Observable<ValidationState> {
        self.validationService.validateUsername(username)
    }

    func signUp(email: String, password: String, username: String) -> Observable<Void> {
        self.firebaseService.signUp(email: email, password: password).map { authData in
            User(id: authData.id, username: username, profileImageUrl: "", email: authData.email ?? "")
        }.flatMap { user in
            self.firebaseService.storeUserInformation(user)
        }
    }
}
