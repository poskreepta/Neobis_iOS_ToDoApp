//
//  Extansion + UILabel.swift
//  TodoApp
//
//  Created by poskreepta on 11.05.23.
//

import UIKit

extension UILabel {
    

    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleToFill
//        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 1
    }



}
