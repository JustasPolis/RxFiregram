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
        self.layer.cornerRadius = 4
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = Resources.Appearance.Color.blue
    }
}
