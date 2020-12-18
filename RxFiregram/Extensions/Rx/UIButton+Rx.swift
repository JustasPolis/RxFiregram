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
            }
        }
    }

    var isDisabled: Binder<Bool> {
        Binder(base) { button, value in
            button.isEnabled = !value
        }
    }
}
