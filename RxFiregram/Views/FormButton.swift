//
//  FormButton.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

class FormButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupButton() {
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.setTitleColor(.white, for: .normal)
    }

    func test() {
        print("hello")
    }
}
