//
//  ValidationService.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-13.
//

import Resolver
import RxSwift

class ValidationService: ValidationServiceType {

    @Injected var firebaseService: FirebaseServiceType

    func validateEmail(_ email: String) -> Observable<ValidationState> {
        if !email.isValidEmail {
            return .just(.error(message: "Please provide a valid email address."))
        }

        return firebaseService.isEmailAvailable(email)
            .map { available in
                if available {
                    return .success
                }
                else {
                    return .error(message: "Email is already taken.")
                }
            }.startWith(.validating)
    }

    func validateUsername(_ username: String) -> Observable<ValidationState> {
        firebaseService.isUsernameAvailable(username)
            .map { available in
                if available {
                    return .success
                }
                else {
                    return .error(message: "Username is already taken")
                }
            }.startWith(.validating)
    }

    func validatePassword(_ password: String) -> ValidationState {
        let minPasswordCount = 6
        let numberOfCharacters = password.count
        if numberOfCharacters < minPasswordCount {
            return .error(message: "Password must be at least \(minPasswordCount) characters long")
        }
        return .success
    }
}
