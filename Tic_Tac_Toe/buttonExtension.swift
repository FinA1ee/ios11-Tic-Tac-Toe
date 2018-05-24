//
//  buttonExtension.swift
//  Tic_Tac_Toe
//
//  Created by Yuchen Zhu on 2018-05-17.
//  Copyright © 2018 Momendie. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    func hasImage(named imageName: String, for state: UIControlState) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        
        return UIImagePNGRepresentation(buttonImage) == UIImagePNGRepresentation(namedImage)
    }
}
