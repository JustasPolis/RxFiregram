//
//  AppDelegate.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-02.
//

import Firebase
import FirebaseCore
import Resolver
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    @LazyInjected var sceneCoordinator: SceneCoordinatorType

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        FirebaseApp.configure()
        sceneCoordinator.transition(to: Scene.landing)
        return true
    }
}
