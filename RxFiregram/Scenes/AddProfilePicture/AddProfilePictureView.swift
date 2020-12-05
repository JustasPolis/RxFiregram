//
//  AddProfilePictureView.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import Then
import UIKit

class AddProfilePictureView: UIView {

    let plusPhotoButton = UIButton(type: .system).then {
        $0.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        $0.contentMode = .bottom
        $0.imageView?.contentMode = .scaleAspectFit
    }

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {}
}
