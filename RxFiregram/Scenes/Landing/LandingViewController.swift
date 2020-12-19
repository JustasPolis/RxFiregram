//
//  LandingViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-19.
//

import RxCocoa
import RxSwift
import UIKit

class LandingViewController: ViewController<LandingViewModel>, BindableType {

    private var landingView: LandingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func loadView() {
        landingView = LandingView()
        view = landingView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func bindInput() -> Input {

        let signUpButtonTap = landingView.signUpButton.rx.tap.asDriver()
        let signInButtonTap = landingView.signInButton.rx.tap.asDriver()
        return Input(signUpButtonTap: signUpButtonTap, signInButtonTap: signInButtonTap)
    }

    func bind(output: Output) {
        disposeBag.insert(
            output.navigateToSignInScene.drive(),
            output.navigateToSignUpScene.drive()
        )
    }
}
