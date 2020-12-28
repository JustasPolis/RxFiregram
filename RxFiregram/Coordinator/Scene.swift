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

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
            case .offline:
                let vc = UIViewController()
                vc.view.backgroundColor = .blue
                return .root(vc)
            case .signUp:
                let signUpVM = SignUpViewModel()
                let signUpVC = SignUpViewController(viewModel: signUpVM)
                return .push(signUpVC)
            case .signIn:
                let signInVM = SignInViewModel()
                let signInVC = SignInViewController(viewModel: signInVM)
                return .push(signInVC)
            case .landing:
                let landingVM = LandingViewModel()
                let landingVC = UINavigationController(rootViewController: LandingViewController(viewModel: landingVM))
                return .root(landingVC)
            case .home:
                let homeVM = HomeViewModel()
                let homeVC = UINavigationController(rootViewController: HomeViewController(viewModel: homeVM))

                let vc = UIViewController()

                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [homeVC, vc]
                return .rootAnimated(tabBarController)
        }
    }
}
