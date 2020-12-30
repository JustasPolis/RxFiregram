//
//  HomeViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-23.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {

    @Injected private var viewModel: HomeViewModel
    typealias Input = HomeViewModel.Input
    typealias Output = HomeViewModel.Output

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViewModel()
    }

    private func bindInput() -> Input {

        Input()
    }

    private func bind(_ output: Output) {}

    private func bindViewModel() {
        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output)
    }
}
