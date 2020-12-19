//
//  SceneCoordinator.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift
import UIKit

class SceneCoordinator: NSObject, SceneCoordinatorType {

    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController {
        didSet {
            currentViewController.navigationController?.delegate = self
            currentViewController.tabBarController?.delegate = self
        }
    }

    override required init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        currentViewController = window.rootViewController ?? UIViewController()
    }

    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        var controller = viewController
        if let tabBarController = controller as? UITabBarController {
            guard let selectedViewController = tabBarController.selectedViewController else {
                return tabBarController
            }
            controller = selectedViewController

            return actualViewController(for: controller)
        }

        if let navigationController = viewController as? UINavigationController {
            controller = navigationController.viewControllers.first!

            return actualViewController(for: controller)
        }
        return controller
    }

    @discardableResult
    func transition(to scene: TargetScene) -> Driver<Void> {
        let subject = PublishSubject<Void>()

        switch scene.transition {
            case let .tabBar(tabBarController):
                guard let selectedViewController = tabBarController.selectedViewController else {
                    fatalError("Selected view controller doesn't exists")
                }
                currentViewController = SceneCoordinator.actualViewController(for: selectedViewController)
                window.rootViewController = tabBarController
            case let .root(viewController):
                currentViewController = SceneCoordinator.actualViewController(for: viewController)
                window.rootViewController = viewController
                subject.onCompleted()
            case let .push(viewController):
                guard let navigationController = currentViewController.navigationController else {
                    fatalError("Can't push a view controller without a current navigation controller")
                }

                _ = navigationController.rx.delegate
                    .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                    .ignoreAll()
                    .bind(to: subject)

                navigationController.pushViewController(SceneCoordinator.actualViewController(for: viewController), animated: true)
            case let .present(viewController):
                viewController.modalPresentationStyle = .fullScreen
                currentViewController.present(viewController, animated: true) {
                    subject.onCompleted()
                }
                currentViewController = SceneCoordinator.actualViewController(for: viewController)
            case let .alert(viewController):
                currentViewController.present(viewController, animated: true) {
                    subject.onCompleted()
                }
            case let .rootAnimated(viewController):
                currentViewController = SceneCoordinator.actualViewController(for: viewController)
                window.rootViewController = viewController
                subject.onCompleted()
                UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        return subject
            .take(1)
            .asDriverOnErrorJustComplete()
    }

    @discardableResult
    func pop(animated: Bool) -> Driver<Void> {
        let subject = PublishSubject<Void>()

        if let presentingViewController = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presentingViewController)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            _ = navigationController
                .rx
                .delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .ignoreAll()
                .bind(to: subject)

            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }

        return subject.asObserver()
            .take(1)
            .ignoreAll()
            .asDriverOnErrorJustComplete()
    }
}

// MARK: - UINavigationControllerDelegate

extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
}

// MARK: - UITabBarControllerDelegate

extension SceneCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
}
