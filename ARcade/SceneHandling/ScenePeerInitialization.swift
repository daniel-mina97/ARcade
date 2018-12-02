//
//  ScenePeerInitialization.swift
//  ARcade
//
//  Created by Daniel Mina on 12/2/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class ScenePeerInitialization: NSObject, NSCoding {
    
    let cityAnchor: ARAnchor
    let baseNode: SCNNode
    
    init(cityAnchor: ARAnchor, planeNode: SCNNode) {
        self.cityAnchor = cityAnchor
        self.baseNode = planeNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cityAnchor = aDecoder.decodeObject(forKey: "cityAnchor") as! ARAnchor
        baseNode = aDecoder.decodeObject(forKey: "baseNode") as! SCNNode
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(cityAnchor, forKey: "cityAnchor")
        encoder.encode(baseNode, forKey: "baseNode")
    }
}
