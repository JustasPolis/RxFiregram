//
//  UIButton+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {

    public var buttonEnabled: Binder<Bool> {
        Binder(base) { button, isEnabled in
            let isEnabledColor = Resources.Appearance.Color.darkBlue
            let defaultColor = Resources.Appearance.Color.lightBlue
            button.isEnabled = isEnabled
            button.backgroundColor = isEnabled ? isEnabledColor : defaultColor
        }
    }
}
