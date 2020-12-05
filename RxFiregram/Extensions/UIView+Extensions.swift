//
//  UIView+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

extension UIView {

    @discardableResult
    public func add(to parent: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        return self
    }
}
