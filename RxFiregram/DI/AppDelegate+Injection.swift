//
//  AppDelegate+Injection.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import Resolver
import UIKit

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { SceneCoordinator() as SceneCoordinatorType }.scope(application)
    }
}
