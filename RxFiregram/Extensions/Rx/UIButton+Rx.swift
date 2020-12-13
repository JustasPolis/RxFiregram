//
//  UIButton+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import RxCocoa
import RxSwift

enum ButtonState {
    case disabled
    case loading
    case enabled
}

extension Reactive where Base: UIButton {

    var buttonState: Binder<ButtonState> {
        Binder(base) { button, state in
            switch state {
                case .disabled:
                    button.backgroundColor = Resources.Appearance.Color.lightBlue
                    button.isEnabled = false
                case .enabled:
                    button.backgroundColor = Resources.Appearance.Color.darkBlue
                    button.isEnabled = true
                case .loading:
                    button.backgroundColor = Resources.Appearance.Color.lightBlue
                    button.setTitle("", for: .normal)
                    button.isEnabled = false
                    let indicator = UIActivityIndicatorView()
                    indicator.color = .white
                    indicator.add(to: button)
                    indicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
                    indicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
                    indicator.startAnimating()
            }
        }
    }
}
