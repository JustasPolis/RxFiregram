//
//  UILabel+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-06.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        Binder(base) { label, result in
            switch result {
                case let .failed(message):
                    label.text = message
                default:
                    label.text = ""
            }
        }
    }
}
