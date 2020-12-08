//
//  Resources.swift
//  RxFiregram
//
//  Created by Justin on 2020-12-05.
//

import Foundation
import Then
import UIKit

enum Resources {}

extension Resources {
    enum Appearance {
        enum Color {
            static let lightBlue = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            static let darkBlue = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            static let red = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 0.7)
            static let green = UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1)
        }
    }
}

extension Resources.Appearance {
    enum Style {
        static let imageCornersRadius: CGFloat = 8.0
    }

    enum Icon {

        static var blackHomeIcon: UIImage {
            #imageLiteral(resourceName: "home_selected")
        }

        static var transparentHomeIcon: UIImage {
            #imageLiteral(resourceName: "home_unselected")
        }

        static var transparentProfileIcon: UIImage {
            #imageLiteral(resourceName: "profile_unselected")
        }

        static var failIcon: UIImageView {
            let icon = UIImageView().then {
                $0.image = #imageLiteral(resourceName: "fail_icon").withRenderingMode(.alwaysTemplate)
                $0.tintColor = Resources.Appearance.Color.red
            }
            return icon
        }

        static var okIcon: UIImageView {
            let icon = UIImageView().then {
                $0.image = #imageLiteral(resourceName: "ok_icon").withRenderingMode(.alwaysTemplate)
                $0.tintColor = Resources.Appearance.Color.green
            }
            return icon
        }
    }
}
