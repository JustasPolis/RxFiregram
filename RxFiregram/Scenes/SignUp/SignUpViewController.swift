//
//  TestViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
//

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
        emailView.formTextField.becomeFirstResponder()
        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)
    }

    func bindInput() -> Input {

        let email = emailView.formTextField.rx.text.orEmpty.asDriver()
        let password = passwordView.formTextField.rx.text.orEmpty.asDriver()
        let username = usernameView.formTextField.rx.text.orEmpty.asDriver()
        let emailNextButtonTap = emailView.formButton.rx.tap.asDriver()
        let usernameNextButtonTap = usernameView.formButton.rx.tap.asDriver()
        let passwordNextButtonTap = passwordView.formButton.rx.tap.asDriver()
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

        output.loading
            .drive(rx.userInteractionDisabled)
            .disposed(by: disposeBag)

        output.loading
            .drive(rx.endEditing)
            .disposed(by: disposeBag)

        // MARK: EmailView bindings

        output.loading
            .drive(emailView.formButton.rx.isLoading)
            .disposed(by: disposeBag)

        output.navigateBack
            .drive()
            .disposed(by: disposeBag)

        output.validatedEmail
            .map(\.errorMessage)
            .drive(emailView.errorLabel.rx.text)
            .disposed(by: disposeBag)

        output.validatedEmail
            .map(\.borderWidth)
            .drive(emailView.formTextField.rx.borderWidth)
            .disposed(by: disposeBag)

        output.validatedEmail
            .drive(onNext: { [weak self] state in
                switch state {
                    case .success:
                        self?.scroll(to: .usernameView, direction: .forward)
                    case .error:
                        self?.emailView.becomeFirstResponder()
                }
            })
            .disposed(by: disposeBag)

        emailView.formTextField
            .rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(emailView.rx.editingChanged)
            .disposed(by: disposeBag)

        emailView.formTextField
            .rx
            .isEmpty
            .merge(with: output.loading)
            .drive(emailView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        // MARK: UsernameView bindings

        usernameView.formTextField
            .rx
            .isEmpty
            .merge(with: output.loading)
            .drive(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)

        // MARK: PasswordView bindings
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

        emailView.topLabel.do {
            $0.text = "Please enter your email address"
        }
        emailView.formTextField.do {
            $0.placeholder = "Email"
            $0.textContentType = .emailAddress
            $0.returnKeyType = .next
            $0.autocorrectionType = .no
        }
        passwordView.topLabel.do {
            $0.text = "Please enter your password"
        }
        passwordView.formTextField.do {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
            $0.textContentType = .password
            $0.keyboardType = .default
        }
        usernameView.topLabel.do {
            $0.text = "Please enter your username"
        }
        usernameView.formTextField.do {
            $0.placeholder = "Username"
            $0.textContentType = .username
            $0.returnKeyType = .next
            $0.autocorrectionType = .yes
        }
    }

    func scroll(to view: FormViewEnum, direction: ScrollDirection) {
        let x = CGFloat(scrollView.contentOffset.x)
        let width = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.3, animations: {
            switch direction {
                case .forward:
                    self.scrollView.contentOffset.x = x + width
                case .back:
                    self.scrollView.contentOffset.x = x - width
            }
        }, completion: { _ in
            switch view {
                case .usernameView:
                    self.usernameView.formTextField.becomeFirstResponder()
                case .emailView:
                    self.emailView.formTextField.becomeFirstResponder()
                case .passwordView:
                    self.passwordView.formTextField.becomeFirstResponder()
            }
        })
    }
}

enum FormViewEnum {
    case emailView
    case usernameView
    case passwordView
}

enum ScrollDirection {
    case forward
    case back
}

extension Reactive where Base: FormView {

    var editingChanged: Binder<Void> {
        Binder<Void>(base) { view, _ in
            view.errorLabel.text = ""
            view.formTextField.layer.borderWidth = 0
        }
    }
}

extension ValidationState {

    var errorMessage: String {
        switch self {
            case .success:
                return ""
            case .error(let message):
                return message
        }
    }

    var borderWidth: Int {
        switch self {
            case .success:
                return 0
            case .error:
                return 1
        }
    }
}
