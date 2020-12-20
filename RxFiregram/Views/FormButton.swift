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

    var validationResult: ValidationResult! {
        didSet {
            switch validationResult {
                case .validating:
                    setTitle("", for: .normal)
                    activityIndicator.add(to: self)
                    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                    activityIndicator.startAnimating()
                case .failed:
                    setTitle("Next", for: .normal)
                    activityIndicator.stopAnimating()
                case .ok:
                    setTitle("Next", for: .normal)
                    activityIndicator.stopAnimating()
                default:
                    setTitle("Next", for: .normal)
                    activityIndicator.stopAnimating()
            }
        }
    }

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
    }
}
