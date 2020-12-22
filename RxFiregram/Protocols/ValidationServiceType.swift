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
}

protocol ValidationServiceType {
    func validateEmail(_ email: String, _ activityIndicator: ActivityIndicator) -> Observable<ValidationState>
    func validateUsername(_ username: String) -> Observable<ValidationState>
    func validatePassword(_ password: String) -> ValidationState
}
