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

    func validateEmail(_ email: String) -> Observable<ValidationResult> {
        if !email.isValidEmail {
            return .just(.failed(message: "Please provide a valid email address"))
        }

        return firebaseService.isEmailAvailable(email).map { available in
            if available {
                return .ok
            }
            else {
                return .failed(message: "Email is already taken")
            }
        }.startWith(ValidationResult.validating)
    }

    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        firebaseService.isUsernameAvailable(username).map { available in
            if available {
                return .ok
            }
            else {
                return .failed(message: "Username is already taken")
            }
        }.startWith(ValidationResult.validating)
    }

    func validatePassword(_ password: String) -> ValidationResult {
        let minPasswordCount = 6
        let numberOfCharacters = password.count
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters long")
        }
        return .ok
    }
}
