//
//  SignUpView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import Then
import UIKit

class SignUpView: UIView {

    var bottomConstraint: NSLayoutConstraint!

    let instagramLogo = InstagramLogo()

    let accountLabel = UILabel().then {
        $0.text = "Already have an account?"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(white: 0, alpha: 0.7)
    }

    let emailLabel = FormLabel()

    let passwordLabel = FormLabel()

    let usernameLabel = FormLabel()

    let signInButton = UIButton(type: .system).then {
        let attributeString = NSAttributedString(string: "Sign In", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        $0.setAttributedTitle(attributeString, for: .normal)
        $0.setTitleColor(Resources.Appearance.Color.lightBlue, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }

    let emailTextField = FormTextField().then {
        $0.placeholder = "Email"
        $0.textContentType = .username
        $0.returnKeyType = .next
        $0.autocorrectionType = .yes
    }

    let usernameTextField = FormTextField().then {
        $0.placeholder = "Username"
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

    let signUpButton = FormButton(type: .system).then {
        $0.setTitle("Sign Up", for: .normal)
    }

    lazy var bottomSignInStackView = UIStackView(arrangedSubviews: [accountLabel, signInButton]).then {
        $0.spacing = 5
    }

    lazy var signUpFormStackView = UIStackView(arrangedSubviews: [
        emailTextField,
        emailLabel,
        usernameTextField,
        usernameLabel,
        passwordTextField,
        passwordLabel,
        signUpButton
    ]).then {
        $0.axis = .vertical
        $0.spacing = 3
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

        bottomSignInStackView.do {
            $0.add(to: self)
            $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        signUpFormStackView.do {
            $0.add(to: self)
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        bottomConstraint = signUpFormStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        bottomConstraint.isActive = true

        instagramLogo.do {
            $0.add(to: self)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
            $0.bottomAnchor.constraint(equalTo: signUpFormStackView.topAnchor, constant: -0.027 * UIScreen.main.bounds.height).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        emailTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
        usernameTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
        passwordTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }
        usernameLabel.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.032).isActive = true
        }
        emailLabel.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.032).isActive = true
        }
        passwordLabel.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.032).isActive = true
        }
    }
}
