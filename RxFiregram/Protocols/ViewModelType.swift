//
//  ViewModelType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
