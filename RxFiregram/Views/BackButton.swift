//
//  BackButton.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
//

import UIKit

class BackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupButton() {
        setImage(#imageLiteral(resourceName: "arrow_back").withRenderingMode(.alwaysTemplate), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        tintColor = .black
    }
}
