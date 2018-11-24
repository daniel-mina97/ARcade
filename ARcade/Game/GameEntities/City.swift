//
//  City.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit


class City: GameActor {
    //var health: Int // health of city
    
    init(health h:Int, location loc: Coordinate3D, anchor a: ARAnchor, node n: SCNNode) {
        super.init(health: h, maxHealth: h, damage: 0, canShoot: false,
                   canMove: false, location: loc, anchor: a, node: n)
        
        
        
    }
}
