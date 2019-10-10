//
//  UITabBarExtension.swift
//  Finda
//
//  Created by cro on 10/10/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import UIKit

extension UITabBar {
    static let height: CGFloat = 49.0
    static let topPadding: CGFloat = 16.0

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = UITabBar.height + window.safeAreaInsets.bottom + UITabBar.topPadding
        } else {
            sizeThatFits.height = UITabBar.height + UITabBar.topPadding
        }
        return sizeThatFits
    }
}
