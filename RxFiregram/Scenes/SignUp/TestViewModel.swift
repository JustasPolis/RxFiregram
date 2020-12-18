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

final class TestViewModel: ViewModelType {

    @Injected private var sceneCoordinator: SceneCoordinatorType
    @Injected private var validationService: ValidationServiceType
    @Injected private var firebaseService: FirebaseServiceType

    struct Input {
        let emailNextButtonTap: Driver<Void>
        let usernameNextButtonTap: Driver<Void>
        let passwordNextButtonTap: Driver<Void>
    }

    struct Output {
        let emailNextButtonTap: Driver<Void>
        let usernameNextButtonTap: Driver<Void>
        let passwordNextButtonTap: Driver<Void>
    }

    func transform(input: Input) -> Output {

        let emailNextButtonTap = input.emailNextButtonTap
        let usernameNextButtonTap = input.usernameNextButtonTap
        let passwordNextButtonTap = input.passwordNextButtonTap

        return Output(emailNextButtonTap: emailNextButtonTap,
                      usernameNextButtonTap: usernameNextButtonTap,
                      passwordNextButtonTap: passwordNextButtonTap)
    }
}
