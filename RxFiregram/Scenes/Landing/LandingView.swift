//
//  LandingView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import Then
import UIKit

class LandingView: UIView {

    let instagramLogo = InstagramLogo()

    let signInButton = UIButton(type: .system).then {
        $0.setTitle("Sign in", for: .normal)
        $0.setTitleColor(Resources.Appearance.Color.blue, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }

    let signUpButton = FormButton(type: .system).then {
        $0.setTitle("Create New Account", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }

    lazy var stackView = UIStackView(arrangedSubviews: [
        instagramLogo,
        signUpButton,
        signInButton
    ]).then {
        $0.axis = .vertical
        $0.setCustomSpacing(30, after: instagramLogo)
        $0.spacing = 4
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

        stackView.do {
            $0.add(to: self)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }

        signUpButton.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06).isActive = true
        }

        signInButton.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06).isActive = true
        }

        instagramLogo.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        }
    }
}
