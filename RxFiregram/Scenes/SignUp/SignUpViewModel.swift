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
        let backButtonTap: Driver<Void>
    }

    struct Output {
        let navigateBack: Driver<Void>
        let validatedEmail: Driver<ValidationState>
        let validatedUsername: Driver<ValidationState>
        let validatedPassword: Driver<ValidationState>
        let loading: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let activityIndicator = ActivityIndicator()

        let validatedEmail = input.emailFormButtonTap
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .error(message: "Error contacting server"))
            }

        let validatedUsername = input.usernameFormButtonTap
            .withLatestFrom(input.username)
            .flatMapLatest { username in
                self.validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .error(message: "Error contacting server"))
            }

        let validatedPassword = input.passwordFormButtonTap
            .withLatestFrom(input.password)
            .map { password in
                self.validationService.validatePassword(password)
            }

        let navigateBack = input.backButtonTap.flatMap {
            self.sceneCoordinator.pop(animated: true)
        }

        let loading = activityIndicator.asDriver()

        return Output(navigateBack: navigateBack,
                      validatedEmail: validatedEmail,
                      validatedUsername: validatedUsername,
                      validatedPassword: validatedPassword,
                      loading: loading)
    }
}
