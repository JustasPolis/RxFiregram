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

    var isLoading: Binder<Bool> {
        Binder(base) { button, isLoading in
            let indicator = UIActivityIndicatorView()
            indicator.color = .white
            indicator.add(to: button)
            indicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            isLoading ? indicator.startAnimating() : indicator.stopAnimating()
            let color = isLoading ? UIColor.clear : UIColor.white
            button.setTitleColor(color, for: .normal)
        }
    }
}
