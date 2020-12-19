//
//  SignInViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import FirebaseAuth
import Resolver
import RxCocoa
import RxSwift
import RxSwiftExt

final class SignInViewModel: ViewModelType {

    @Injected private var sceneCoordinator: SceneCoordinatorType
    @Injected private var validationService: ValidationServiceType
    @Injected private var firebaseService: FirebaseServiceType

    struct Input {
        let backButtonTap: Driver<Void>
    }

    struct Output {
        let popToLandingScene: Driver<Void>
    }

    func transform(input: Input) -> Output {

        let popToLandingScene = input.backButtonTap.flatMap {
            self.sceneCoordinator.pop(animated: true)
        }
        return Output(popToLandingScene: popToLandingScene)
    }
}
