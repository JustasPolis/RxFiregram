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
        let didEndEditingPassword = signUpView.passwordTextField.rx.controlEvent(.editingDidEnd).asDriver()
        let didEndEditingEmail = signUpView.emailTextField.rx.controlEvent(.editingDidEnd).asDriver()
        let didEndEditingUsername = signUpView.usernameTextField.rx.controlEvent(.editingDidEnd).asDriver()
        let signUpTrigger = Driver.merge(signUpView.signUpButton.rx.tap.asDriver(), signUpView.passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver())
        let signInButtonTap = signUpView.signInButton.rx.tap.asDriver()

        return Input(username: usernameInput,
                     password: passwordInput,
                     email: emailInput,
                     signInButtonTap: signInButtonTap,
                     signUpTrigger: signUpTrigger,
                     didEndEditingPassword: didEndEditingPassword,
                     didEndEditingEmail: didEndEditingEmail,
                     didEndEditingUsername: didEndEditingUsername)
    }

    func bind(output: Output) {

        output.isLoading.drive(onNext: { loading in
            print(loading)
        })

        let loadingState = output.isLoading
            .filter { $0 != false }
            .mapTo(ButtonState.loading)

        let defaultState = Driver.merge(output.isLoading, output.signUpEnabled)
            .filter { $0 != true }
            .mapTo(ButtonState.disabled)

        let enabledState = output.signUpEnabled
            .filter { $0 != false }
            .mapTo(ButtonState.enabled)

        Driver.merge(defaultState, loadingState, enabledState)
            .drive(signUpView.signUpButton.rx.buttonState)
            .disposed(by: disposeBag)

        disposeBag.insert(
            output.navigateToSignInScene.drive(),
            output.signUp.drive(),
            output.authError.unwrap().drive(onNext: { error in
                print(error)
            }),

            output.validatedUsername.drive(signUpView.usernameLabel.rx.validationResult),
            output.validatedUsername.drive(signUpView.usernameTextField.rx.validationResult),
            output.validatedEmail.drive(signUpView.emailTextField.rx.validationResult),
            output.validatedEmail.drive(signUpView.emailLabel.rx.validationResult),
            output.validatedPassword.drive(signUpView.passwordTextField.rx.validationResult),
            output.validatedPassword.drive(signUpView.passwordLabel.rx.validationResult),

            output.isLoading.drive(signUpView.usernameTextField.rx.isDisabled),
            output.isLoading.drive(signUpView.emailTextField.rx.isDisabled),
            output.isLoading.drive(signUpView.passwordTextField.rx.isDisabled),
            output.isLoading.drive(signUpView.signInButton.rx.isDisabled)
        )
    }

    func setupTextFieldEvents() {

        let onUsernameEditingChanged = signUpView.usernameTextField.rx.controlEvent(.editingChanged).asDriver()
        let onPasswordEditingChanged = signUpView.passwordTextField.rx.controlEvent(.editingChanged).asDriver()
        let onEmailEditingChanged = signUpView.emailTextField.rx.controlEvent(.editingChanged).asDriver()

        disposeBag.insert(
            onUsernameEditingChanged.drive(signUpView.usernameTextField.rx.onEditingChanged),
            onUsernameEditingChanged.drive(signUpView.usernameLabel.rx.onEditingChanged),
            onEmailEditingChanged.drive(signUpView.emailTextField.rx.onEditingChanged),
            onEmailEditingChanged.drive(signUpView.emailLabel.rx.onEditingChanged),
            onPasswordEditingChanged.drive(signUpView.passwordTextField.rx.onEditingChanged),
            onPasswordEditingChanged.drive(signUpView.passwordLabel.rx.onEditingChanged)
        )
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
}
