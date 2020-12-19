//
//  ScrollView+Rx.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-20.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    var scrollBack: Binder<Void> {
        Binder(self.base) { scrollView, _ in
            let x = CGFloat(scrollView.contentOffset.x)
            let viewWidth = UIScreen.main.bounds.width
            let offset = x - viewWidth
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }

    var scrollForward: Binder<Void> {
        Binder(self.base) { scrollView, _ in
            let x = CGFloat(scrollView.contentOffset.x)
            let viewWidth = UIScreen.main.bounds.width
            let offset = x + viewWidth
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
}

