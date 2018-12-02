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
import MultipeerConnectivity

class ScenePeerInitialization: NSObject, NSCoding {
    
    enum CodingKeys: String, CodingKey {
        case cityAnchor
        case baseNode
        case hostID
    }
    
    let cityAnchor: ARAnchor
    let baseNode: SCNNode
    let hostID: MCPeerID
    
    init(cityAnchor: ARAnchor, planeNode: SCNNode, hostID: MCPeerID) {
        self.cityAnchor = cityAnchor
        self.baseNode = planeNode
        self.hostID = hostID
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cityAnchor = aDecoder.decodeObject(forKey: CodingKeys.cityAnchor.rawValue) as! ARAnchor
        baseNode = aDecoder.decodeObject(forKey: CodingKeys.baseNode.rawValue) as! SCNNode
        hostID = aDecoder.decodeObject(forKey: CodingKeys.hostID.rawValue) as! MCPeerID
        
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(cityAnchor, forKey: CodingKeys.cityAnchor.rawValue)
        encoder.encode(baseNode, forKey: CodingKeys.baseNode.rawValue)
        encoder.encode(hostID, forKey: CodingKeys.hostID.rawValue)
    }
}
