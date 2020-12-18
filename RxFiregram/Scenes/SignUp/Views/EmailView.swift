//
//  EmailView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-17.
//

import Then
import UIKit

class EmailView: UIView {

    let formView = FormView()

    let accountLabel = UILabel().then {
        $0.text = "Already have an account?"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(white: 0, alpha: 0.7)
    }

    let signInButton = UIButton(type: .system).then {
        let attributeString = NSAttributedString(string: "Sign In", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        $0.setAttributedTitle(attributeString, for: .normal)
        $0.setTitleColor(Resources.Appearance.Color.lightBlue, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }

    lazy var bottomStackView = UIStackView(arrangedSubviews: [accountLabel, signInButton]).then {
        $0.spacing = 5
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupFormView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupFormView() {
        formView.topLabel.do {
            $0.text = "Please enter your email address"
        }

        formView.textField.do {
            $0.placeholder = "Email"
            $0.textContentType = .username
            $0.returnKeyType = .next
            $0.autocorrectionType = .yes
        }
    }

    func setupLayout() {

        formView.add(to: self).do {
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        }

        bottomStackView.do {
            $0.add(to: self)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.22).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
