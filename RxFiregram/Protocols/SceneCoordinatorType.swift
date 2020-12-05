//
//  SceneCoordinatorType.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import RxCocoa
import RxSwift
import UIKit

protocol SceneCoordinatorType {
    init()

    @discardableResult func transition(to scene: TargetScene) -> Driver<Void>
    @discardableResult func pop(animated: Bool) -> Driver<Void>
}
