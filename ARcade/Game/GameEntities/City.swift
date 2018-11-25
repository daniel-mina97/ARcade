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
    
    
    init(location loc: Coordinate3D, node n: SCNNode) {
        let h = 10
        super.init(health: h, maxHealth: h, damage: 0, node: n)
        
    }
}
