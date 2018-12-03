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

class ScenePeerInitialization: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
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
        cityAnchor = aDecoder.decodeObject(of: ARAnchor.self, forKey: CodingKeys.cityAnchor.rawValue)!
        baseNode = aDecoder.decodeObject(of: SCNNode.self, forKey: CodingKeys.baseNode.rawValue)!
        hostID = aDecoder.decodeObject(of: MCPeerID.self, forKey: CodingKeys.hostID.rawValue)!
        
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(cityAnchor, forKey: CodingKeys.cityAnchor.rawValue)
        encoder.encode(baseNode, forKey: CodingKeys.baseNode.rawValue)
        encoder.encode(hostID, forKey: CodingKeys.hostID.rawValue)
    }
}
