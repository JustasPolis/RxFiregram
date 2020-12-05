//
//  FormLabel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import UIKit

class FormLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupLabel() {
        self.font = .systemFont(ofSize: 12)
        self.textColor = .red
    }
}
