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

class TestViewController: ViewController<TestViewModel>, BindableType {

    private let emailView = EmailView()
    private let usernameView = UsernameView()
    private let passwordView = PasswordView()
    private var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupKeyboardEvents()
        setupTextFieldEvents()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func bindInput() -> Input {

        let emailNextButtonTap = emailView.formView.nextButton.rx.tap.asDriver()
        let usernameNextButtonTap = usernameView.formView.nextButton.rx.tap.asDriver()
        let passwordNextButtonTap = passwordView.formView.nextButton.rx.tap.asDriver()

        let emailBackButtonTap = emailView.formView.backButton.rx.tap.asDriver()
        usernameView.formView.backButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            let x = CGFloat(self?.scrollView.contentOffset.x ?? 0)
            let viewWidth = self?.view.bounds.width ?? 0
            let offset = x - viewWidth
            self?.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self?.emailView.formView.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        let passwordBackButtonTap = usernameView.formView.backButton.rx.tap.asDriver()

        return Input(emailNextButtonTap: emailNextButtonTap,
                     usernameNextButtonTap: usernameNextButtonTap,
                     passwordNextButtonTap: passwordNextButtonTap)
    }

    func bind(output: Output) {
        output.emailNextButtonTap.drive(onNext: { [weak self] in
            let x = CGFloat(self?.scrollView.contentOffset.x ?? 0)
            let viewWidth = self?.view.bounds.width ?? 0
            let offset = x + viewWidth
            self?.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self?.usernameView.formView.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)

        output.usernameNextButtonTap.drive(onNext: { [weak self] in
            let x = CGFloat(self?.scrollView.contentOffset.x ?? 0)
            let viewWidth = self?.view.bounds.width ?? 0
            let offset = x + viewWidth
            self?.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }).disposed(by: disposeBag)

        output.passwordNextButtonTap.drive(onNext: { [weak self] in
            let x = CGFloat(self?.scrollView.contentOffset.x ?? 0)
            let viewWidth = self?.view.bounds.width ?? 0
            let offset = x + viewWidth
            self?.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }).disposed(by: disposeBag)
    }

    func setupScrollView() {

        let views = [emailView, usernameView, passwordView, UIView()]
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

    func setupKeyboardEvents() {
        rx.hideKeyboardOnTap.drive().disposed(by: disposeBag)
    }

    func setupTextFieldEvents() {
        emailView.formView.textField.becomeFirstResponder()
    }
}
