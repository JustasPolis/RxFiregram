//
//  UIScrollView+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-20.
//

import UIKit

extension UIScrollView {

    func scrollForward() {
        let x = CGFloat(contentOffset.x)
        let viewWidth = UIScreen.main.bounds.width
        let offset = x + viewWidth
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }

    func scrollBack() {
        let x = CGFloat(contentOffset.x)
        let viewWidth = UIScreen.main.bounds.width
        let offset = x - viewWidth
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}
