//
//  TestViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-18.
//

import Resolver
import RxCocoa
import RxSwift
import Then
import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {

    @Injected private var viewModel: SignUpViewModel

    typealias Input = SignUpViewModel.Input
    typealias Output = SignUpViewModel.Output

    let disposeBag = DisposeBag()
    let scrollView = UIScrollView()
    let emailView = FormView()
    let usernameView = FormView()
    let passwordView = FormView()
    let signUpView = SignUpView()

    private(set) var shouldEndEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupFormViews()
        bindViewModel()
        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)
        emailView.formTextField.becomeFirstResponder()
        emailView.formTextField.delegate = self
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        shouldEndEditing
    }

    private func bindInput() -> Input {

        let email = emailView.formTextField.rx.text.orEmpty.asDriver()
        let password = passwordView.formTextField.rx.text.orEmpty.asDriver()
        let username = usernameView.formTextField.rx.text.orEmpty.asDriver()
        let emailFormButtonTap = Driver.merge(emailView.formButton.rx.tap.asDriver(), emailView.formTextField.rx.controlEvent(.editingDidEndOnExit).asDriver())
        let usernameFormButtonTap = usernameView.formButton.rx.tap.asDriver()
        let passwordFormButtonTap = passwordView.formButton.rx.tap.asDriver()
        let emailBackButtonTap = emailView.backButton.rx.tap.asDriver()
        let signUpButtonTap = signUpView.formButton.rx.tap.asDriver()

        return Input(username: username,
                     password: password,
                     email: email,
                     emailFormButtonTap: emailFormButtonTap,
                     usernameFormButtonTap: usernameFormButtonTap,
                     passwordFormButtonTap: passwordFormButtonTap,
                     signUpButtonTap: signUpButtonTap,
                     backButtonTap: emailBackButtonTap)
    }

    private func bind(_ output: Output) {

        //MARK: EmailView Bindings

        output.navigateBack
            .drive()
            .disposed(by: disposeBag)

        output.validatedEmail
            .map(\.validating)
            .drive(rx.userInteractionDisabled,
                   emailView.formButton.rx.showActivityIndicator,
                   emailView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        output.validatedEmail
            .map(\.validating)
            .drive(onNext: { [weak self] isValidating in
                self?.shouldEndEditing = isValidating
            }).disposed(by: disposeBag)

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
                    case .error, .networkError:
                        self?.emailView.formTextField.becomeFirstResponder()
                    case .validating:
                        self?.emailView.formTextField.resignFirstResponder()
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
            .drive(emailView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        // MARK: UsernameView bindings

        output.validatedUsername
            .map(\.validating)
            .drive(rx.userInteractionDisabled,
                   usernameView.formButton.rx.showActivityIndicator,
                   usernameView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        output.validatedUsername
            .map(\.errorMessage)
            .drive(usernameView.errorLabel.rx.text)
            .disposed(by: disposeBag)

        output.validatedUsername
            .map(\.borderWidth)
            .drive(usernameView.formTextField.rx.borderWidth)
            .disposed(by: disposeBag)

        output.validatedUsername
            .drive(onNext: { [weak self] state in
                switch state {
                    case .success:
                        self?.scroll(to: .passwordView, direction: .forward)
                    case .error, .networkError:
                        self?.usernameView.formTextField.becomeFirstResponder()
                    case .validating:
                        self?.usernameView.formTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)

        usernameView.formTextField
            .rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(usernameView.rx.editingChanged)
            .disposed(by: disposeBag)

        usernameView.formTextField
            .rx
            .isEmpty
            .drive(usernameView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        usernameView.backButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.scroll(to: .emailView, direction: .back)
            }).disposed(by: disposeBag)

        // MARK: PasswordView bindings

        output.validatedPassword
            .map(\.errorMessage)
            .drive(passwordView.errorLabel.rx.text)
            .disposed(by: disposeBag)

        output.validatedPassword
            .map(\.borderWidth)
            .drive(passwordView.formTextField.rx.borderWidth)
            .disposed(by: disposeBag)

        output.validatedPassword
            .filter { $0 == .success }
            .drive(onNext: { [weak self] _ in
                self?.passwordView.formTextField.resignFirstResponder()
                self?.scroll(to: .signUpView, direction: .forward)
            })
            .disposed(by: disposeBag)

        passwordView.formTextField
            .rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(passwordView.rx.editingChanged)
            .disposed(by: disposeBag)

        passwordView.formTextField
            .rx
            .isEmpty
            .drive(passwordView.formButton.rx.isDisabled)
            .disposed(by: disposeBag)

        passwordView.backButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.scroll(to: .usernameView, direction: .back)
            }).disposed(by: disposeBag)

        // MARK: SignUpView bindings

        signUpView.backButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.scroll(to: .passwordView, direction: .back)
            }).disposed(by: disposeBag)

        signUpView.formButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.scrollView.contentOffset.x = self?.view.frame.width ?? 0
            }).disposed(by: disposeBag)

        output.error.drive().disposed(by: disposeBag)
        output.signUp.drive().disposed(by: disposeBag)
    }

    private func bindViewModel() {

        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output)
    }

    private func setupScrollView() {

        let views = [emailView, usernameView, passwordView, signUpView]

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

    private func setupFormViews() {

        emailView.topLabel.do {
            $0.text = "Please enter your email address"
        }
        emailView.formTextField.do {
            $0.placeholder = "Email"
            $0.textContentType = .emailAddress
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
            $0.autocorrectionType = .yes
        }
    }

    private func scroll(to view: FormViewEnum, direction: ScrollDirection) {
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
                case .signUpView:
                    return
            }
        })
    }
}

extension Reactive where Base: FormView {

    var editingChanged: Binder<Void> {
        Binder<Void>(base) { view, _ in
            view.errorLabel.text = ""
            view.formTextField.layer.borderWidth = 0
        }
    }
}

enum FormViewEnum {
    case emailView
    case usernameView
    case passwordView
    case signUpView
}

enum ScrollDirection {
    case forward
    case back
}
