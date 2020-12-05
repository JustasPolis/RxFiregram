//
//  ValidationServiceType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import RxSwift

enum ValidationResult {
    case ok
    case failed(message: String)
    case validating
    case empty
}

protocol ValidationServiceType {
    func validateEmail(_ email: String) -> ValidationResult
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}
