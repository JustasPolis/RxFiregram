//
//  InstagramLogo.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-04.
//

import UIKit

class InstagramLogo: UIImageView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.imageSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func imageSetup() {
        self.image = #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysTemplate)
        self.contentMode = .scaleAspectFit
        self.tintColor = .black
    }
}
