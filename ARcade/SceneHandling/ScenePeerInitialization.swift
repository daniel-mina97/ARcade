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
        case hostID
    }
    
    let cityAnchor: ARAnchor
    let hostID: MCPeerID
    
    init(cityAnchor: ARAnchor, planeNode: SCNNode, hostID: MCPeerID) {
        self.cityAnchor = cityAnchor
        self.hostID = hostID
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cityAnchor = aDecoder.decodeObject(of: ARAnchor.self, forKey: CodingKeys.cityAnchor.rawValue)!
        hostID = aDecoder.decodeObject(of: MCPeerID.self, forKey: CodingKeys.hostID.rawValue)!
        
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(cityAnchor, forKey: CodingKeys.cityAnchor.rawValue)
        encoder.encode(hostID, forKey: CodingKeys.hostID.rawValue)
    }
}
