//
//  UITextField+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-08.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {

    var borderWidth: Binder<Int> {
        Binder(base) { textField, value in
            textField.layer.borderWidth = CGFloat(value)
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
