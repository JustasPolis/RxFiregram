//
//  MockFirebaseService.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-06.
//

import FirebaseAuth
import FirebaseDatabase
import RxSwift

class MockFirebaseService: FirebaseServiceType {

    func storeProfileImage(_ image: Data) -> Observable<String> {
        .just("mock")
    }

    func signUp(email: String, password: String) -> Observable<AuthData> {
        .just(AuthData(id: "testId", email: "testEmail"))
    }

    func storeUserInformation(_ user: User) -> Observable<Void> {
        .just(())
    }

    func isUsernameAvailable(_ username: String) -> Observable<Bool> {
        .just(true)
    }

    func isEmailAvailable(_ email: String) -> Observable<Bool> {
        .just(true)
    }
}
