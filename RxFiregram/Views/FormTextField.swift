//
//  FormTextField.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

class FormTextField: UITextField {

    var validationResult: ValidationResult! {
        didSet {
            switch validationResult {
                case .validating:
                    self.isUserInteractionEnabled = false
                case .failed:
                    self.isUserInteractionEnabled = true
                    self.layer.borderWidth = 1
                    self.layer.cornerRadius = 5
                    self.layer.borderColor = Resources.Appearance.Color.red.cgColor
                default:
                    self.isUserInteractionEnabled = true
            }
        }
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let viewDimensions: CGFloat = 20
        let y = bounds.size.height / 2 - viewDimensions / 2
        let x = bounds.size.width - viewDimensions * 1.8
        return .init(x: x, y: y, width: viewDimensions, height: viewDimensions)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textFieldSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func textFieldSetup() {
        borderStyle = .roundedRect
        tintColor = Resources.Appearance.Color.blue
        backgroundColor = UIColor(white: 0, alpha: 0.03)
        font = UIFont.systemFont(ofSize: 14)
        autocapitalizationType = .none
    }
}
