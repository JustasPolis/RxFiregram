//
//  SignUpViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import Then
import UIKit

class SignUpViewController: ViewController<SignUpViewModel>, BindableType {

    private var signUpView = SignUpView()
    private let emailView = EmailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupScrollView()
        setupKeyboardEvents()
        setupTextFieldEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func bindInput() -> Input {

        let usernameInput = signUpView.usernameTextField.rx.text.orEmpty.asDriver().distinctUntilChanged()
        let passwordInput = signUpView.passwordTextField.rx.text.orEmpty.asDriver()
        let emailInput = signUpView.emailTextField.rx.text.orEmpty.asDriver()
        let signUpTrigger = Driver.merge(
            signUpView.signUpButton.rx.tap.asDriver(),
            signUpView.passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver()
        )
        let signInButtonTap = signUpView.signInButton.rx.tap.asDriver()

        return Input(username: usernameInput,
                     password: passwordInput,
                     email: emailInput,
                     signInButtonTap: signInButtonTap,
                     signUpTrigger: signUpTrigger)
    }

    func bind(output: Output) {

        let defaultState = output.signUpEnabled
            .filter { $0 != true }
            .mapTo(ButtonState.disabled)

        let enabledState = output.signUpEnabled
            .filter { $0 == true }
            .mapTo(ButtonState.enabled)

        Driver.merge(defaultState, enabledState).drive(signUpView.signUpButton.rx.buttonState).disposed(by: disposeBag)

        output.test2.drive(onNext: { state in
            switch state {
                case (.ok, .ok):
                    print("ok")
                default:
                    print("whatup")
            }
        }).disposed(by: disposeBag)

        disposeBag.insert(
            output.navigateToSignInScene.drive(),
            output.authError.drive(onNext: { error in
                print(error)
            }),

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

        let keyboardKeyEnabled = signUpView.passwordTextField.rx.text.orEmpty.asDriver()
            .drive(onNext: { [weak self] text in
                if text.isEmpty {
                    self?.signUpView.passwordTextField.enablesReturnKeyAutomatically = true
                }
                else {
                    self?.signUpView.passwordTextField.enablesReturnKeyAutomatically = true
                }
            })

        disposeBag.insert(
            onUsernameEditingChanged.drive(signUpView.usernameTextField.rx.onEditingChanged),
            onUsernameEditingChanged.drive(signUpView.usernameLabel.rx.onEditingChanged),
            onEmailEditingChanged.drive(signUpView.emailTextField.rx.onEditingChanged),
            onEmailEditingChanged.drive(signUpView.emailLabel.rx.onEditingChanged),
            onPasswordEditingChanged.drive(signUpView.passwordTextField.rx.onEditingChanged),
            onPasswordEditingChanged.drive(signUpView.passwordLabel.rx.onEditingChanged),
            keyboardKeyEnabled
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

    func setupScrollView() {
        let scrollView = UIScrollView()

        let myView = UIView()
        myView.backgroundColor = .blue

        let views = [emailView, UIView(), UIView(), UIView()]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
        for i in 0 ..< views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.add(to: view)
        scrollView.pinToEdges(of: view)
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
