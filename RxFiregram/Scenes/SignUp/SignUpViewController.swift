//
//  SignUpViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: ViewController<SignUpViewModel>, BindableType {

    private var signUpView: SignUpView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupKeyboardEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func loadView() {
        signUpView = SignUpView()
        view = signUpView
    }

    func bindInput() -> Input {

        let signInButtonTap = signUpView.signInButton.rx.tap.asSignal()

        return Input(signInButtonTap: signInButtonTap)
    }

    func bind(output: Output) {
        output.navigateToSignInScene.drive().disposed(by: disposeBag)
        output.signUpEnabled.drive(signUpView.signUpButton.rx.buttonEnabled).disposed(by: disposeBag)
    }

    func setupKeyboardEvents() {

        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)

        rx.keyboardWillShow
            .drive(onNext: { [weak self] height, animationDuration in
                self?.signUpView.bottomConstraint.constant = -height * 0.15
                UIView.animate(withDuration: animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)

        rx.keyboardWillHide
            .drive(onNext: { [weak self] animationDuration in
                self?.signUpView.bottomConstraint.constant = 0
                UIView.animate(withDuration: animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
    }
}
