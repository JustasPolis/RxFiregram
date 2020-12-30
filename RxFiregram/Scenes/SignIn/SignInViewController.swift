//
//  SignInViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

class SignInViewController: UIViewController {

    @Injected private var viewModel: SignInViewModel
    typealias Input = SignInViewModel.Input
    typealias Output = SignInViewModel.Output

    let disposeBag = DisposeBag()
    let signInView = SignInView()

    override func viewDidLoad() {
        setupKeyboardEvents()
        bindViewModel()
        super.viewDidLoad()
    }

    override func loadView() {
        view = signInView
    }

    private func bindViewModel() {

        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output)
    }

    private func bindInput() -> Input {

        let backButtonTap = signInView.backButton.rx.tap.asDriver()

        return Input(backButtonTap: backButtonTap)
    }

    private func bind(_ output: Output) {
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
