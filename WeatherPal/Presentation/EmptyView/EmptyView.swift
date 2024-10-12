//
//  EmptyView.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadFromNib() else {return}
        self.addSubview(view)
        view.frame = self.bounds
        self.setupUI()
    }

    
    private func setupUI() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
    }
}
