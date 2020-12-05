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

    struct Input {
        let signInButtonTap: Signal<Void>
    }

    struct Output {
        let navigateToSignInScene: Driver<Void>
        let signUpEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let navigateToSignInScene = input.signInButtonTap.flatMap {
            self.sceneCoordinator.transition(to: Scene.signIn)
        }

        let signUpEnabled = Observable.just(true).asDriverOnErrorJustComplete()

        return Output(navigateToSignInScene: navigateToSignInScene, signUpEnabled: signUpEnabled)
    }
}
