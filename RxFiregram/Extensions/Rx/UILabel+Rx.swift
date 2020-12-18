//
//  UILabel+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-06.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {

    var onEditingChanged: Binder<Void> {
        Binder(base) { label, _ in
            label.text = ""
        }
    }
}
