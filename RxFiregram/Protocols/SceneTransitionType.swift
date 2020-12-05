//
//  SceneTransitionType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

enum SceneTransitionType {
    case root(UIViewController)
    case push(UIViewController)
    case present(UIViewController)
    case alert(UIViewController)
    case tabBar(UITabBarController)
    case rootAnimated(UIViewController)
}
