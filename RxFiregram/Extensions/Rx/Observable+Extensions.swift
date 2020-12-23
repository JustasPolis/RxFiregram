//
//  Observable+Extensions.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift

private let errorMessage = "`drive*` family of methods can be only called from `MainThread`.\n" +
    "This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n"

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    public func drive<Observer: ObserverType>(_ observers: Observer...) -> Disposable where Observer.Element == Element {
        MainScheduler.ensureRunningOnMainThread(errorMessage: errorMessage)
        return self.asSharedSequence()
            .asObservable()
            .subscribe { e in
                observers.forEach { $0.on(e) }
            }
    }

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }

    public func merge(with other: Driver<Element>) -> SharedSequence<SharingStrategy, Element> {
        Driver.merge(self as! SharedSequence<DriverSharingStrategy, Self.Element>, other)
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
