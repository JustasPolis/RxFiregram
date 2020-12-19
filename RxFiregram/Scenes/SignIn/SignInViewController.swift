//
//  SignInViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import UIKit

class SignInViewController: ViewController<SignInViewModel>, BindableType {

    private var signInView: SignInView!

    override func viewDidLoad() {
        setupKeyboardEvents()
        bindViewModel()
        super.viewDidLoad()
    }

    override func loadView() {
        signInView = SignInView()
        view = signInView
    }

    func bindInput() -> Input {

        let backButtonTap = signInView.backButton.rx.tap.asDriver()

        return Input(backButtonTap: backButtonTap)
    }

    func bind(output: Output) {
        output.popToLandingScene.drive().disposed(by: disposeBag)
    }

    func setupKeyboardEvents() {

        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)

        rx.keyboardWillShow
            .drive(onNext: { [weak self] height, animationDuration in
                self?.signInView.bottomConstraint.constant = -height * 0.15
                UIView.animate(withDuration: animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)

        rx.keyboardWillHide
            .drive(onNext: { [weak self] animationDuration in
                self?.signInView.bottomConstraint.constant = 0
                UIView.animate(withDuration: animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
    }
}
