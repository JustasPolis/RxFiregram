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
    static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
            case (.ok, .ok):
                return true
            case (.validating, .validating):
                return true
            default:
                return false
        }
    }
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
