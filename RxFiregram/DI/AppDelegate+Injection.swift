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
        register { SignUpViewModel() as SignUpViewModel }
        register { SignInViewModel() as SignInViewModel }
        register { LandingViewModel() as LandingViewModel }
        register { HomeViewModel() as HomeViewModel }
        #if TEST
        register { MockFirebaseService() as FirebaseServiceType }
        #else
        register { FirebaseService() as FirebaseServiceType }
        #endif
    }
}
