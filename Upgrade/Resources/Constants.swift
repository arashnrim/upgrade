//
//  Constants.swift
//  Upgrade
//
//  Created by Arash on 18/12/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

// swiftlint:disable:next type_name
struct K {

    struct Layout {
        /// Use this value for no distance between items. The value of this constant is 0.0.
        static let noSpaceBetween: CGFloat = 0.0
        /// Use this value for little distance between items. The value of this constant is 8.0.
        static let littleSpaceBetween: CGFloat = 8.0
        /// Use this value for some distance between items. The value of this constant is 20.0.
        static let someSpaceBetween: CGFloat = 20.0
        /// Use this value for more distance between items. The value of this constant is 40.0.
        static let moreSpaceBetween: CGFloat = 40.0

        /// The default height of a Button. The value of this constant is 50.0.
        static let buttonHeight: CGFloat = 50.0
    }

    struct Design {
        /// A pre-defined Gradient Layer with Upgrade's colours.
        static let upGradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [upBlue.cgColor, upPurple.cgColor]
            layer.startPoint = CGPoint(x: 0.0, y: 0.0)
            layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            return layer
        }()

        /// A safely-unwrapped value of Upgrade Blue.
        static let upBlue = UIColor(named: "UP Blue") ?? .systemBlue
        /// A safely-unwrapped value of Upgrade Purple.
        static let upPurple = UIColor(named: "UP Purple") ?? .systemPurple
    }

}
