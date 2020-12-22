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
        let emailNextButtonTap: Driver<Void>
        let usernameNextButtonTap: Driver<Void>
        let passwordNextButtonTap: Driver<Void>
        let emailBackButtonTap: Driver<Void>
    }

    struct Output {
        let emailNextButtonTap: Driver<Void>
        let usernameNextButtonTap: Driver<Void>
        let passwordNextButtonTap: Driver<Void>
        let navigateBack: Driver<Void>
        let validatedEmail: Driver<ValidationState>
        let loading: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let activityIndicator = ActivityIndicator()

        let emailInputChanged = input.emailNextButtonTap
            .withLatestFrom(input.email)
            .withPrevious()
            .didChange()

        let validatedEmail = input.emailNextButtonTap
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                self.validationService.validateEmail(email, activityIndicator)
                    .asDriver(onErrorJustReturn: .error(message: "Error contacting server"))
            }

        let emailNextButtonTap = input.emailNextButtonTap
        let usernameNextButtonTap = input.usernameNextButtonTap
        let passwordNextButtonTap = input.passwordNextButtonTap

        let navigateBack = input.emailBackButtonTap.flatMap {
            self.sceneCoordinator.pop(animated: true)
        }

        let loading = activityIndicator.asDriver()

        return Output(emailNextButtonTap: emailNextButtonTap,
                      usernameNextButtonTap: usernameNextButtonTap,
                      passwordNextButtonTap: passwordNextButtonTap,
                      navigateBack: navigateBack,
                      validatedEmail: validatedEmail,
                      loading: loading)
    }
}
