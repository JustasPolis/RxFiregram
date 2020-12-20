//
//  FormLabel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import UIKit

class ErrorLabel: UILabel {

    var validationResult: ValidationResult! {
        didSet {
            switch validationResult {
                case .failed(let message):
                    text = message
                default:
                    text = ""
            }
        }
    }

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
