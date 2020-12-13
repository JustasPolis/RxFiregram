//
import RxBlocking
import RxCocoa
//  SignUpViewModel.swift
//  RxFiregramTests
//
//  Created by Justin on 2020-12-06.
//
@testable import RxFiregram
import RxSwift
import XCTest

class SignUpViewModelTests: XCTestCase {

    var viewModel: SignUpViewModel!
    var viewController: SignUpViewController!

    let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()

        viewModel = SignUpViewModel()
    }

    func testUsernameValidation() {

        let usernameInput = PublishSubject<String>()
        let didEndEditingUsername = PublishSubject<Void>()
        let input = createInput(username: usernameInput, didEndEditingUsername: didEndEditingUsername)
        let output = viewModel.transform(input: input)
        let expected = ValidationResult.failed(message: "Username is already taken")

        output.validatedUsername.drive().disposed(by: disposeBag)
        usernameInput.onNext("Mocking")
        didEndEditingUsername.onNext(())
        let actual = try! output.validatedUsername.toBlocking().first()!
        XCTAssertEqual(actual, expected)
    }

    func testSignUp() {
        let usernameInput = PublishSubject<String>()
        let emailInput = PublishSubject<String>()
        let passwordInput = PublishSubject<String>()
        let signUpButtonTap = PublishSubject<Void>()
        let input = createInput(username: usernameInput, password: passwordInput, email: emailInput, signUpButtonTap: signUpButtonTap)
        let output = viewModel.transform(input: input)
    }

    private func createInput(username: Observable<String> = Observable.just(""),
                             password: Observable<String> = Observable.just(""),
                             email: Observable<String> = Observable.just(""),
                             signInButtonTap: Observable<Void> = Observable.just(()),
                             signUpButtonTap: Observable<Void> = Observable.just(()),
                             didEndEditingPassword: Observable<Void> = Observable.just(()),
                             didEndEditingEmail: Observable<Void> = Observable.just(()),
                             didEndEditingUsername: Observable<Void> = Observable.just(()))

        -> SignUpViewModel.Input
    {
        SignUpViewModel.Input(username: username.asDriverOnErrorJustComplete(),
                              password: password.asDriverOnErrorJustComplete(),
                              email: email.asDriverOnErrorJustComplete(),
                              signInButtonTap: signInButtonTap.asDriverOnErrorJustComplete(),
                              signUpButtonTap: signUpButtonTap.asDriverOnErrorJustComplete(),
                              didEndEditingPassword: didEndEditingPassword.asDriverOnErrorJustComplete(),
                              didEndEditingEmail: didEndEditingEmail.asDriverOnErrorJustComplete(),
                              didEndEditingUsername: didEndEditingUsername.asDriverOnErrorJustComplete())
    }
}
