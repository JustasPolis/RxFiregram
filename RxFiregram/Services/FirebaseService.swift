//
//  FirebaseService.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import CodableFirebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import RxFirebaseAuthentication
import RxFirebaseDatabase
import RxFirebaseStorage
import RxSwift

class FirebaseService: FirebaseServiceType {

    func storeProfileImage(_ image: Data) -> Observable<String> {
        let filename = NSUUID().uuidString
        let profileImagesStorageRef = Storage.storage()
            .reference()
            .child("profile_images")
            .child(filename)
            .rx
        return profileImagesStorageRef.putData(image)
            .flatMap { _ -> Observable<String> in
                profileImagesStorageRef.downloadURL().map(\.absoluteString)
            }
    }

    func signUp(email: String, password: String) -> Observable<AuthData> {
        Auth.auth()
            .rx
            .createUser(withEmail: email, password: password)
            .map { authResult in
                AuthData(id: authResult.user.uid, email: authResult.user.email)
            }
    }

    func storeUserInformation(_ user: User) -> Observable<Void> {
        let usersRef = Database.database()
            .reference()
            .child("users")
            .rx
        let userEncoded = try! FirebaseEncoder().encode(user)
        let values = [user.id: userEncoded]
        return usersRef.updateChildValues(values)
            .asObservable()
            .mapToVoid()
    }

    func isUsernameAvailable(_ username: String) -> Observable<Bool> {
        Database.database()
            .reference()
            .child("users")
            .queryOrdered(byChild: "username")
            .queryEqual(toValue: username.lowercased())
            .rx
            .observeSingleEvent(.value)
            .asObservable()
            .map { !$0.exists() }
    }

    func isEmailAvailable(_ email: String) -> Observable<Bool> {
        Database.database()
            .reference()
            .child("users")
            .queryOrdered(byChild: "email")
            .queryEqual(toValue: email)
            .rx
            .observeSingleEvent(.value)
            .asObservable()
            .map { !$0.exists() }
    }
}
