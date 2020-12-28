//
//  FormView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
//

import Then
import UIKit

class FormView: UIView {

    let errorLabel = ErrorLabel()

    let backButton = BackButton(type: .system)

    let formTextField = FormTextField()

    let formButton = FormButton(type: .system).then {
        $0.setTitle("Next", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }

    let labelView = UIView()

    let topLabel = FormLabel()

    lazy var formStackView = UIStackView(arrangedSubviews: [
        labelView,
        formTextField,
        errorLabel,
        formButton
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
            $0.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        formTextField.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.055).isActive = true
        }

        formButton.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.065).isActive = true
        }

        labelView.do {
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.03).isActive = true
        }

        topLabel.do {
            $0.add(to: labelView)
            $0.centerXAnchor.constraint(equalTo: labelView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: labelView.centerYAnchor).isActive = true
        }
    }
}
