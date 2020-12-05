//
//  FormTextField.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

class FormTextField: UITextField {

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let viewDimensions: CGFloat = 20
        let y = bounds.size.height / 2 - viewDimensions / 2
        let x = bounds.size.width - viewDimensions * 1.8
        return .init(x: x, y: y, width: viewDimensions, height: viewDimensions)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        textFieldSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func textFieldSetup() {
        borderStyle = .roundedRect
        backgroundColor = UIColor(white: 0, alpha: 0.03)
        font = UIFont.systemFont(ofSize: 14)
    }
}
