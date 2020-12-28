//
//  ValidationServiceType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-13.
//

import RxSwift

enum ValidationState: Equatable {
    case success
    case error(message: String)
    case validating
    case networkError
}

extension ValidationState {

    var errorMessage: String {
        switch self {
            case .success, .validating:
                return ""
            case .error(let message):
                return message
            case .networkError:
                return "Network error occured, please try again"
        }
    }

    var borderWidth: Int {
        switch self {
            case .success, .validating, .networkError:
                return 0
            case .error:
                return 1
        }
    }

    var validating: Bool {
        switch self {
            case .success, .error, .networkError:
                return false
            case .validating:
                return true
        }
    }
}

protocol ValidationServiceType {
    func validateEmail(_ email: String) -> Observable<ValidationState>
    func validateUsername(_ username: String) -> Observable<ValidationState>
    func validatePassword(_ password: String) -> ValidationState
}
