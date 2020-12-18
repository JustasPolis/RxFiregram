//
//  Scene.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case signUp
    case signIn
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
            case .signUp:
                let signUpVM = TestViewModel()
                let signUpVC = UINavigationController(rootViewController: TestViewController(viewModel: signUpVM))
                return .root(signUpVC)
            case .signIn:
                let signInVC = SignInViewController()
                return .push(signInVC)
        }
    }
}
