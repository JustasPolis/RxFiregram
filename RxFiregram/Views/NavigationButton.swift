//
//  NavigationButton.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-17.
//

import UIKit

class NavigationButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupButton() {
        setTitleColor(Resources.Appearance.Color.lightBlue, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
