//
//  UIScrollView+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-20.
//

import UIKit

enum ScrollDirection {
    case forward
    case back
}

extension UIScrollView {

    func scroll(_ direction: ScrollDirection, completion: @escaping () -> ()) {
        let x = CGFloat(contentOffset.x)
        let width = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.3, animations: {
            switch direction {
                case .forward:
                    self.contentOffset.x = x + width
                case .back:
                    self.contentOffset.x = x - width
            }
        }, completion: { _ in
            completion()
        })
    }
}
