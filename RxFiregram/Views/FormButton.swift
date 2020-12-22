//
//  FormButton.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import Then
import UIKit

class FormButton: UIButton {

    let activityIndicator = UIActivityIndicatorView().then {
        $0.color = .white
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Resources.Appearance.Color.blue : Resources.Appearance.Color.lightBlue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupButton() {
        layer.cornerRadius = 4
        isEnabled = true
        setTitleColor(.white, for: .normal)
    }
}
