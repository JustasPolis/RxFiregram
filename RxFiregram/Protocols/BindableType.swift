//
//  BindableType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

protocol BindableType {
    associatedtype ViewModel: ViewModelType
    typealias Input = ViewModel.Input
    typealias Output = ViewModel.Output

    var viewModel: ViewModel { get }

    func bindInput() -> Input
    func bind(output: Output)
}

extension BindableType {

    func bindViewModel() {
        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output: output)
    }
}
