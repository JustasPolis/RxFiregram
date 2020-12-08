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

        let usernameInput = signUpView.usernameTextField.rx.text.orEmpty.asDriver().distinctUntilChanged()
        let passwordInput = signUpView.passwordTextField.rx.text.orEmpty.asDriver()
        let emailInput = signUpView.emailTextField.rx.text.orEmpty.asDriver()
        let didEndEditingPassword = signUpView.passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver()
        let didEndEditingEmail = signUpView.emailTextField.rx.controlEvent(.editingDidEnd).asDriver()
        let didEndEditingUsername = signUpView.usernameTextField.rx.controlEvent(.editingDidEnd).asDriver()
        let signUpButonTap = signUpView.signUpButton.rx.tap.asSignal()
        let signInButtonTap = signUpView.signInButton.rx.tap.asSignal()

        return Input(username: usernameInput,
                     password: passwordInput,
                     email: emailInput,
                     signInButtonTap: signInButtonTap,
                     signUpButtonTap: signUpButonTap,
                     didEndEditingPassword: didEndEditingPassword,
                     didEndEditingEmail: didEndEditingEmail,
                     didEndEditingUsername: didEndEditingUsername)
    }

    func bind(output: Output) {
        output.navigateToSignInScene.drive().disposed(by: disposeBag)
        output.signUpEnabled.drive(signUpView.signUpButton.rx.buttonEnabled).disposed(by: disposeBag)
        output.validatedUsername.drive(signUpView.usernameLabel.rx.validationResult).disposed(by: disposeBag)
        output.validatedUsername.drive(signUpView.usernameTextField.rx.validationResult).disposed(by: disposeBag)
        signUpView.usernameTextField.rx.controlEvent(.editingChanged).asDriver().drive(onNext: { result in
            print(result)
        }).disposed(by: disposeBag)

        signUpView.usernameTextField
            .rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.signUpView.usernameLabel.text = ""
                self?.signUpView.usernameTextField.rightViewMode = .never
            })
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
