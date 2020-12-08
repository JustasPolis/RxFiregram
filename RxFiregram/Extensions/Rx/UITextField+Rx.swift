//
//  UITextField+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-08.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {
    var validationResult: Binder<ValidationResult> {
        Binder(base) { textField, result in
            switch result {
                case .failed:
                    textField.rightView = Resources.Appearance.Icon.failIcon
                    textField.rightViewMode = .always
                case .validating:
                    let activityIndicator = UIActivityIndicatorView(style: .gray)
                    activityIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    activityIndicator.startAnimating()
                    textField.rightView = activityIndicator
                    textField.rightViewMode = .always
                case .empty:
                    textField.rightViewMode = .never
                case .ok:
                    textField.rightView = Resources.Appearance.Icon.okIcon
                    textField.rightViewMode = .always
            }
        }
    }
}
