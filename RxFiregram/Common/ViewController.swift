//
//  ViewController.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-02.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController<VM>: UIViewController {

    let viewModel: VM

    let disposeBag = DisposeBag()

    public required init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
