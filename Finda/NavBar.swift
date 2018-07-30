//
//  NavBar.swift
//  Finda
//
//  Created by Peter Lloyd on 29/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class NavBar: UINavigationBar {

    override func layoutSubviews() {
        self.backItem?.title = ""
        super.layoutSubviews()
        self.layoutIfNeeded()
    }

}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
