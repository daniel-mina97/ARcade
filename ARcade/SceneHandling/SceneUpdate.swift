//
//  SceneUpdate.swift
//  ARcade
//
//  Created by Daniel Mina on 11/24/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit

class SceneUpdate: NSObject, NSCoding {
    
    enum UpdateTypes: String {
        case SpawnAlien
        case RemoveAlien
    }
    enum CodingKeys: String, CodingKey {
        case updateID
        case type
        case spawnPoint
        case alienID
    }
    
    static var overallUpdateID: Int = 0
    
    let updateID: Int
    let type: UpdateTypes
    let spawnPoint: Coordinate3D?
    let alienID: Int
    
    init(alienID: Int, spawnPoint: Coordinate3D) {
        self.updateID = SceneUpdate.overallUpdateID
        SceneUpdate.overallUpdateID += 1
        self.type = .SpawnAlien
        self.alienID = alienID
        self.spawnPoint = spawnPoint
    }
    
    init(alienID: Int) {
        self.updateID = SceneUpdate.overallUpdateID
        SceneUpdate.overallUpdateID += 1
        self.type = .RemoveAlien
        self.alienID = alienID
        self.spawnPoint = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        updateID = aDecoder.decodeInteger(forKey: CodingKeys.updateID.rawValue)
        type = aDecoder.decodeObject(forKey: CodingKeys.type.rawValue) as! UpdateTypes
        spawnPoint = Coordinate3D(vector: aDecoder.decodeObject(forKey: CodingKeys.spawnPoint.rawValue) as! SCNVector3)
        alienID = aDecoder.decodeInteger(forKey: CodingKeys.alienID.rawValue)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(updateID, forKey: CodingKeys.updateID.rawValue)
        encoder.encode(type, forKey: CodingKeys.type.rawValue)
        encoder.encode(spawnPoint?.getVector(), forKey: CodingKeys.spawnPoint.rawValue)
        encoder.encode(alienID, forKey: CodingKeys.alienID.stringValue)
    }
}
