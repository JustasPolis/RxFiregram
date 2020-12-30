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
    case landing
    case home
    case offline
}

// resolver viewmodels padaryt

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
            case .offline:
                let vc = UIViewController()
                vc.view.backgroundColor = .blue
                return .root(vc)
            case .signUp:
                let signUpVC = SignUpViewController()
                return .push(signUpVC)
            case .signIn:
                let signInVC = SignInViewController()
                return .push(signInVC)
            case .landing:
                let landingVC = UINavigationController(rootViewController: LandingViewController())
                return .root(landingVC)
            case .home:
                let homeVM = HomeViewModel()
                let homeVC = UINavigationController(rootViewController: HomeViewController())

                let vc = UIViewController()

                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [homeVC, vc]
                return .rootAnimated(tabBarController)
        }
    }
}
