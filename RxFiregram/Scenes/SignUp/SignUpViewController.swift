//
//  TestViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
//

import FirebaseAuth
import RxCocoa
import RxSwift
import Then
import UIKit

class SignUpViewController: ViewController<SignUpViewModel>, BindableType {

    private let emailView = FormView()
    private let usernameView = FormView()
    private let passwordView = FormView()
    private var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupFormViews()
        bindViewModel()

        emailView.textField.becomeFirstResponder()
        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)
    }

    func bindInput() -> Input {

        // TextField inputs

        let email = emailView.textField.rx.text.orEmpty.asDriver()
        let password = passwordView.textField.rx.text.orEmpty.asDriver()
        let username = usernameView.textField.rx.text.orEmpty.asDriver()

        // Button inputs

        let emailNextButtonTap = emailView.nextButton.rx.tap.asDriver()
        let usernameNextButtonTap = usernameView.nextButton.rx.tap.asDriver()
        let passwordNextButtonTap = passwordView.nextButton.rx.tap.asDriver()
        let emailBackButtonTap = emailView.backButton.rx.tap.asDriver()

        return Input(username: username,
                     password: password,
                     email: email,
                     emailNextButtonTap: emailNextButtonTap,
                     usernameNextButtonTap: usernameNextButtonTap,
                     passwordNextButtonTap: passwordNextButtonTap,
                     emailBackButtonTap: emailBackButtonTap)
    }

    func bind(output: Output) {

        // MARK: TextField setup

        let emailTextField = emailView.textField.rx
        let usernameTextField = usernameView.textField.rx
        let passwordTextField = passwordView.textField.rx

        output.emailNextButtonTap.drive(usernameTextField.becomesFirstResponsder).disposed(by: disposeBag)
        output.usernameNextButtonTap.drive(passwordTextField.becomesFirstResponsder).disposed(by: disposeBag)
        usernameView.backButton.rx.tap.asDriver().drive(emailTextField.becomesFirstResponsder).disposed(by: disposeBag)
        passwordView.backButton.rx.tap.asDriver().drive(usernameTextField.becomesFirstResponsder).disposed(by: disposeBag)
        // passwordView

        // MARK: Navigation setup

        output.popToLandingScene.drive().disposed(by: disposeBag)
        usernameView.backButton.rx.tap.asDriver().drive(scrollView.rx.scrollBack).disposed(by: disposeBag)
        passwordView.backButton.rx.tap.asDriver().drive(scrollView.rx.scrollBack).disposed(by: disposeBag)

        // MARK: Button State

        emailView.textField.rx.isEmpty.skip(1).drive(emailView.nextButton.rx.isDisabled).disposed(by: disposeBag)

        // MARK: Validation setup

        output.validatedEmail.drive(emailView.rx.validationResult).disposed(by: disposeBag)

        output.validatedEmail.drive(onNext: { [weak self] result in
            switch result {
                case .validating:
                    self?.view.endEditing(true)
                case .ok:
                    self?.usernameView.textField.becomeFirstResponder()
                case .failed:
                    self?.emailView.textField.becomeFirstResponder()
            }
        }).disposed(by: disposeBag)
    }

    func setupScrollView() {

        let views = [emailView, usernameView, passwordView, UIView()]

        scrollView.do {
            $0.add(to: view)
            $0.pinToEdges(of: view)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.isPagingEnabled = false
            $0.isScrollEnabled = false
            $0.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
        }

        for i in 0 ..< views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
    }

    func setupFormViews() {

        // EmailView Setup

        emailView.topLabel.do {
            $0.text = "Please enter your email address"
        }
        emailView.textField.do {
            $0.placeholder = "Email"
            $0.textContentType = .emailAddress
            $0.returnKeyType = .next
            $0.autocorrectionType = .no
        }

        // PasswordView Setup

        passwordView.topLabel.do {
            $0.text = "Please enter your password"
        }
        passwordView.textField.do {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
            $0.textContentType = .password
            $0.keyboardType = .default
        }

        // UsernameView Setup

        usernameView.topLabel.do {
            $0.text = "Please enter your username"
        }
        usernameView.textField.do {
            $0.placeholder = "Username"
            $0.textContentType = .username
            $0.returnKeyType = .next
            $0.autocorrectionType = .yes
        }
    }
}

extension Reactive where Base: FormView {

    var validationResult: Binder<ValidationResult> {
        Binder<ValidationResult>(base) { view, result in
            view.nextButton.validationResult = result
            view.textField.validationResult = result
            view.errorLabel.validationResult = result
            view.validationResult = result
        }
    }
}

extension UIScrollView {
    func scrollForward() {
        let x = CGFloat(contentOffset.x)
        let viewWidth = UIScreen.main.bounds.width
        let offset = x + viewWidth
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}
