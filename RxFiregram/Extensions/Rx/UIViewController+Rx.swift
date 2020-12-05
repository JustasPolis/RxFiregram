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
}
