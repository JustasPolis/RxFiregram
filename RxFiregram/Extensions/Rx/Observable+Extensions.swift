//
//  Observable+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }

    func withPrevious() -> SharedSequence<SharingStrategy, (Element, Element)> where Element == String {
        scan((String(), String())) { ($0.1, $1) }
    }

    func take(if trigger: Driver<Bool>) -> SharedSequence<SharingStrategy, Element> {
        withLatestFrom(trigger) { (myValue, triggerValue) -> (Element, Bool) in
            (myValue, triggerValue)
        }
        .filter { (_, triggerValue) -> Bool in
            triggerValue == true
        }
        .map { (myValue, _) -> Element in
            myValue
        }
    }

    func didChange() -> SharedSequence<SharingStrategy, Bool> where Element == (String, String) {
        map { element1, element2 in
            if element1 != element2 {
                return true
            }
            else {
                return false
            }
        }
    }
}

extension ObservableType {

    func ignoreAll() -> Observable<Void> {
        map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}
