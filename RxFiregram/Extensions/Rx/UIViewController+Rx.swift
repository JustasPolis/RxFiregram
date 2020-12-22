//
//  UIViewController+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

    public var hideKeyboardOnTap: Driver<Void> {
        let tap = UITapGestureRecognizer()
        let vc = self.base as UIViewController
        vc.view.addGestureRecognizer(tap)
        return tap.rx
            .event
            .map { _ in vc.view.endEditing(true) }
            .asDriverOnErrorJustComplete()
    }

    var endEditing: Binder<Bool> {
        Binder(base) { vc, value in
            vc.view.endEditing(value)
        }
    }

    public var userInteractionDisabled: Binder<Bool> {
        Binder(base) { vc, isDisabled in
            vc.view.isUserInteractionEnabled = !isDisabled
        }
    }
}
