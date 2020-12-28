//
//  AppDelegate+Injection.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { SceneCoordinator() as SceneCoordinatorType }.scope(shared)
        register { ValidationService() as ValidationServiceType }
        #if TEST
        register { MockFirebaseService() as FirebaseServiceType }
        #else
        register { FirebaseService() as FirebaseServiceType }
        #endif
    }
}
