//
//  UILabel Extension.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 11/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import UIKit

extension UILabel {
    func getHeight(with width: CGFloat) -> CGFloat {
        // You have to call layoutIfNeeded() if you are using autoLayout
        self.layoutIfNeeded()
        let myText = self.text! as NSString
        let rect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        
        return ceil(CGFloat(labelSize.height)) * 2
    }
}
