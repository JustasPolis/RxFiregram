//
//  LandingViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import RxSwift
import RxCocoa
import Resolver

final class LandingViewModel: ViewModelType {

    @Injected private var sceneCoordinator: SceneCoordinatorType

    struct Input {
        let signUpButtonTap: Driver<Void>
        let signInButtonTap: Driver<Void>
    }

    struct Output {
        let navigateToSignUpScene: Driver<Void>
        let navigateToSignInScene: Driver<Void>
    }

    func transform(input: Input) -> Output {

        let navigateToSignUpScene = input.signUpButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signUp)
        }

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        return Output(navigateToSignUpScene: navigateToSignUpScene, navigateToSignInScene: navigateToSignInScene)
    }
}
