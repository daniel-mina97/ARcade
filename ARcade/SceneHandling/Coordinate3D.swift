//
//  Coordinate3D.swift
//  ARcade
//

//  Created by Webb, Christopher Jacob on 11/17/18.

//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit

class Coordinate3D {
    var x: Float
    var y: Float
    var z: Float
    
    init(x: Float, y: Float, z: Float){
        self.x = x
        self.y = y
        self.z = z
    }
    
    func changeValues(xDiff: Float, yDiff: Float, zDiff: Float){
        x += xDiff
        y += yDiff
        z += zDiff
    }
    
    func getVector() -> SCNVector3{
        return SCNVector3(x, y, z)
    }
}
