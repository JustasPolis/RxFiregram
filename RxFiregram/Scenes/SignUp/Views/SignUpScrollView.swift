//
//  ScrollView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-17.
//

import UIKit

class SignUpScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let views = [UIView(), UIView(), UIView(), UIView()]
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
        isScrollEnabled = false
        contentSize = CGSize(width: frame.width * CGFloat(views.count), height: frame.height)
        views.enumerated().forEach { index, view in
            addSubview(view)
            view.frame = CGRect(x: frame.width * CGFloat(index), y: 0, width: frame.width, height: frame.height)
        }
    }
}
