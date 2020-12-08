//
import RxBlocking
//  SignUpViewModel.swift
//  RxFiregramTests
//
//  Created by Justin on 2020-12-06.
//
@testable import RxFiregram
import XCTest
import RxCocoa
import RxSwift
import RxBlocking

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

    private func createInput(username: Observable<String> = Observable.just(""),
                             password: Driver<String> = Driver.just(""),
                             email: Driver<String> = Driver.just(""),
                             signInButtonTap: Signal<Void> = Signal.just(()),
                             signUpButtonTap: Signal<Void> = Signal.just(()),
                             didEndEditingPassword: Driver<Void> = Driver.just(()),
                             didEndEditingEmail: Driver<Void> = Driver.just(()),
                             didEndEditingUsername: Observable<Void> = Observable.just(()))

        -> SignUpViewModel.Input
    {
        SignUpViewModel.Input(username: username.asDriverOnErrorJustComplete(),
                              password: password,
                              email: email,
                              signInButtonTap: signInButtonTap,
                              signUpButtonTap: signUpButtonTap,
                              didEndEditingPassword: didEndEditingPassword,
                              didEndEditingEmail: didEndEditingEmail,
                              didEndEditingUsername: didEndEditingUsername.asDriverOnErrorJustComplete())
    }
}
