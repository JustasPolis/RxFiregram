//
//  HomeViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-23.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewController: ViewController<HomeViewModel>, BindableType {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViewModel()
    }

    func bindInput() -> Input {

        Input()
    }

    func bind(output: Output) {}
}
