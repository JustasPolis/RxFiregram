//
//  UITextField+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-08.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {

    var isDisabled: Binder<Bool> {
        Binder(base) { textField, value in
            textField.isEnabled = !value
        }
    }

    var onEditingChanged: Binder<Void> {
        Binder(base) { textField, _ in
            textField.rightViewMode = .never
        }
    }

    var becomesFirstResponsder: Binder<Void> {
        Binder(base) { textField, _ in
            textField.becomeFirstResponder()
        }
    }
}
