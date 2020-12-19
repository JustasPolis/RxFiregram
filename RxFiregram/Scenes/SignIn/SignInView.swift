//
//  SignInView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import Then
import UIKit

class SignInView: UIView {

    var bottomConstraint: NSLayoutConstraint!

    let instagramLogo = InstagramLogo()

    let backButton = BackButton(type: .system)

    let emailTextField = FormTextField().then {
        $0.placeholder = "Email"
        $0.textContentType = .username
        $0.returnKeyType = .next
        $0.autocorrectionType = .yes
    }

    let passwordTextField = FormTextField().then {
        $0.placeholder = "Password"
        $0.isSecureTextEntry = true
        $0.returnKeyType = .done
        $0.textContentType = .password
        $0.keyboardType = .default
    }

    let signInButton = FormButton(type: .system).then {
        $0.setTitle("Sign In", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }

    lazy var formStackView = UIStackView(arrangedSubviews: [
        emailTextField,
        passwordTextField,
        signInButton
    ]).then {
        $0.axis = .vertical
        $0.spacing = 12
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {

        backButton.do {
            $0.add(to: self)
            $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.010 * UIScreen.main.bounds.height).isActive = true
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.10).isActive = true
        }

        formStackView.do {
            $0.add(to: self)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        bottomConstraint = formStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        bottomConstraint.isActive = true

        instagramLogo.do {
            $0.add(to: self)
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
            $0.bottomAnchor.constraint(equalTo: formStackView.topAnchor, constant: -0.027 * UIScreen.main.bounds.height).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        emailTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
        passwordTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
        signInButton.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
    }
}
