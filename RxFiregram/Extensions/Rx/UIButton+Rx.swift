//
//  UIButton+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {

    var isDisabled: Binder<Bool> {
        Binder(base) { button, isDisabled in
            button.isEnabled = !isDisabled
        }
    }
}
