//
//  Reactive+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift

extension Reactive {
    public var keyboardWillShow: Driver<(CGFloat, Double)> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> (CGFloat, Double) in
                let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                return (keyboardSize, animationDuration)
            }.asDriverOnErrorJustComplete()
    }

    public var keyboardWillHide: Driver<Double> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { notification in
                let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                return animationDuration
            }.asDriverOnErrorJustComplete()
    }
}
