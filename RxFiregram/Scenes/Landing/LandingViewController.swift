//
//  LandingViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

class LandingViewController: UIViewController {

    @Injected private var viewModel: LandingViewModel
    typealias Input = LandingViewModel.Input
    typealias Output = LandingViewModel.Output

    let landingView = LandingView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func loadView() {
        view = landingView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func bindInput() -> Input {

        let signUpButtonTap = landingView.signUpButton.rx.tap.asDriver()
        let signInButtonTap = landingView.signInButton.rx.tap.asDriver()

        return Input(signUpButtonTap: signUpButtonTap, signInButtonTap: signInButtonTap)
    }

    private func bind(_ output: Output) {
        disposeBag.insert(
            output.navigateToSignInScene.drive(),
            output.navigateToSignUpScene.drive()
        )
    }

    private func bindViewModel() {
        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output)
    }
}
