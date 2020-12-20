//
//  UITextField+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-08.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {

    var becomesFirstResponsder: Binder<Void> {
        Binder(base) { textField, _ in
            textField.becomeFirstResponder()
        }
    }

    public var isEmpty: Driver<Bool> {
        self.base.rx
            .text
            .orEmpty
            .map(\.isEmpty)
            .asDriverOnErrorJustComplete()
    }
}
