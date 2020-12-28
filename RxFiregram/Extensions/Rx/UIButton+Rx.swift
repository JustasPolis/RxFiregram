//
//  UIButton+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import RxCocoa
import RxSwift

extension Reactive where Base: FormButton {

    var showActivityIndicator: Binder<Bool> {
        Binder(base) { button, isLoading in
            let indicator = button.activityIndicator
            let color = isLoading ? UIColor.clear : UIColor.white
            isLoading ? indicator.startAnimating() : indicator.stopAnimating()
            button.setTitleColor(color, for: .normal)
        }
    }
}

extension Reactive where Base: UIButton {

    var isDisabled: Binder<Bool> {

        Binder(base) { button, isDisabled in
            button.isEnabled = !isDisabled
        }
    }
}
