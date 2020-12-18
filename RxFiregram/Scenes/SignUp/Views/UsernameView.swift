//
//  UsernameView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-17.
//

import UIKit
import Then

class UsernameView: UIView {

    let formView = FormView()

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
            $0.text = "Please enter your username"
        }

        formView.textField.do {
            $0.placeholder = "Username"
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
    }
}
