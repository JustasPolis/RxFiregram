//
//  FormButton.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import Then
import UIKit

class FormButton: UIButton {

    lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.color = .white
        $0.hidesWhenStopped = true
        $0.add(to: self)
        $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
