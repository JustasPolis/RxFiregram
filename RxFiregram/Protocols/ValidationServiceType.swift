//
//  ValidationServiceType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-13.
//

import RxSwift

enum ValidationResult: Equatable {
    case ok
    case failed(message: String)
    case validating
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
            case .ok:
                return true
            default:
                return false
        }
    }
}

protocol ValidationServiceType {
    func validateEmail(_ email: String) -> Observable<ValidationResult>
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}
