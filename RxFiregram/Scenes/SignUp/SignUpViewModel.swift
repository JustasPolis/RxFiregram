//
//  SignUpViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

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
        let signInButtonTap: Signal<Void>
        let signUpButtonTap: Signal<Void>
        let didEndEditingPassword: Driver<Void>
        let didEndEditingEmail: Driver<Void>
        let didEndEditingUsername: Driver<Void>
    }

    struct Output {
        let navigateToSignInScene: Driver<Void>
        let signUpEnabled: Driver<Bool>
        let validatedUsername: Driver<ValidationResult>
        let validatedEmail: Driver<ValidationResult>
    }

    func transform(input: Input) -> Output {

        let validatedUsername = input.didEndEditingUsername
            .withLatestFrom(input.username)
            .flatMapLatest { username -> Driver<ValidationResult> in
                self.validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let validatedEmail = input.didEndEditingEmail
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                self.validationService.validateEmail(email)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        let signUpEnabled = Observable.just(true).asDriverOnErrorJustComplete()

        return Output(navigateToSignInScene: navigateToSignInScene,
                      signUpEnabled: signUpEnabled,
                      validatedUsername: validatedUsername,
                      validatedEmail: validatedEmail)
    }
}
