//
//  HomeViewModel.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-23.
//

import Resolver
import RxCocoa
import RxSwift

final class HomeViewModel: ViewModelType {

    @Injected private var sceneCoordinator: SceneCoordinatorType

    struct Input {}

    struct Output {}

    func transform(input: Input) -> Output {

        Output()
    }
}
