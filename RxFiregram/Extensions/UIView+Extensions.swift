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

    @discardableResult
    public func pinToEdges(of view: UIView) -> Self {
        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        return self
    }
}
