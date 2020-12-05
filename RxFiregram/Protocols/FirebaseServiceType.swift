//
//  FirebaseServiceType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import FirebaseAuth
import FirebaseDatabase
import RxSwift

protocol FirebaseServiceType {
    func storeProfileImage(_ image: Data) -> Observable<String>
    func signUp(email: String, password: String) -> Observable<AuthDataResult>
    func storeUserInformation(_ user: User) -> Observable<DatabaseReference>
    func isUsernameAvailable(_ username: String) -> Observable<Bool>
    func isEmailAvailable(_ email: String) -> Observable<Bool>
}
