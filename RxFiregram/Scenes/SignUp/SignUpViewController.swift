//
//  SignUpViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: ViewController<SignUpViewModel>, BindableType {

    private var signUpView: SignUpView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupKeyboardEvents()
        setupTextFieldEvents()
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
        let signUpButonTap = signUpView.signUpButton.rx.tap.asDriver()
        let signInButtonTap = signUpView.signInButton.rx.tap.asDriver()

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
        output.validatedUsername.drive(signUpView.usernameLabel.rx.validationResult).disposed(by: disposeBag)
        output.validatedUsername.drive(signUpView.usernameTextField.rx.validationResult).disposed(by: disposeBag)
        output.signUp.drive().disposed(by: disposeBag)
        output.authError.unwrap().drive(signUpView.rx.authErrors).disposed(by: disposeBag)

        // SignUpButton state

        let loadingState = output.isLoading
            .filter { $0 != false }
            .mapTo(ButtonState.loading)

        let enabledState = output.signUpEnabled
            .filter { $0 != false }
            .mapTo(ButtonState.enabled)

        Driver.merge(loadingState, enabledState)
            .startWith(ButtonState.disabled)
            .drive(signUpView.signUpButton.rx.buttonState)
            .disposed(by: disposeBag)
    }

    func setupTextFieldEvents() {

        signUpView.usernameTextField
            .rx.controlEvent(.editingChanged)
            .asDriver()
            .map { _ in TextField.usernameTextField }
            .drive(signUpView.rx.onEditingChanged)
            .disposed(by: disposeBag)

        signUpView.passwordTextField
            .rx.controlEvent(.editingChanged)
            .asDriver()
            .map { _ in TextField.passwordTextField }
            .drive(signUpView.rx.onEditingChanged)
            .disposed(by: disposeBag)

        signUpView.emailTextField
            .rx.controlEvent(.editingChanged)
            .asDriver()
            .map { _ in TextField.emailTextField }
            .drive(signUpView.rx.onEditingChanged)
            .disposed(by: disposeBag)
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

enum TextField {
    case usernameTextField
    case emailTextField
    case passwordTextField
}

extension Reactive where Base: SignUpView {
    var authErrors: Binder<AuthErrorCode> {
        Binder<AuthErrorCode>(base) { view, value in
            switch value {
                case .wrongPassword:
                    view.emailLabel.text = "Tests"
                default:
                    view.emailLabel.text = "Test"
            }
        }
    }

    var onEditingChanged: Binder<TextField> {
        Binder<TextField>(base) { view, value in
            switch value {
                case .usernameTextField:
                    view.usernameLabel.text = ""
                    view.usernameTextField.rightViewMode = .never
                case .emailTextField:
                    view.emailLabel.text = ""
                    view.emailTextField.rightViewMode = .never
                case .passwordTextField:
                    view.passwordLabel.text = ""
                    view.passwordTextField.rightViewMode = .never
            }
        }
    }
}
