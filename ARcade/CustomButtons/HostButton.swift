//
//  HostSessionButton.swift
//  ARcade
//
//  Created by Rudy on 11/28/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import UIKit

class HostButton: UIButton{
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        
    }
}
