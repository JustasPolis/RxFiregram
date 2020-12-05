//
//  Observable+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift

extension ObservableType {

    func ignoreAll() -> Observable<Void> {
        map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            Driver.empty()
        }
    }
}
