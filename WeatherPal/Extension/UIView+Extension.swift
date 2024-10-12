//
//  UIView+Extension.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit
extension UIView {
    func loadFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView
    }

}
