//
//  ContentView.swift
//  ResponsiveModalViewController
//
//  Created by 박은비 on 2020/11/18.
//

import UIKit

class ContentView: UIView {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        
        if let loadNib = Bundle.main.loadNibNamed(className,
                                                  owner: self,
                                                  options: nil) {
            for view in loadNib {
                if let view = view as? Self {
                    return view
                }
            }
        }
        
        return UIView() as! Self
    }
}
