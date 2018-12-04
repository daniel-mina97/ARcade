//
//  SceneUpdate.swift
//  ARcade
//
//  Created by Daniel Mina on 11/24/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit

class SceneUpdate: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    enum UpdateTypes: String {
        case SpawnAlien
        case RemoveAlien
        case SpawnPickup
        case BulletShot
        case EndGame
    }
    enum CodingKeys: String, CodingKey {
        case updateID
        case type
        case spawnPoint
        case alienID
        case targetID
        case alienType
    }
    
    static var overallUpdateID: Int = 0
    
    let updateID: Int
    let type: UpdateTypes
    let spawnPoint: Coordinate3D?
    let alienID: Int
    let targetID: Int?
    let alienType: Alien.AlienType?
    
    init(alienID: Int, alienType: Alien.AlienType, spawnPoint: Coordinate3D) {
        self.updateID = SceneUpdate.overallUpdateID
        SceneUpdate.overallUpdateID += 1
        self.type = .SpawnAlien
        self.alienID = alienID
        self.targetID = nil
        self.spawnPoint = spawnPoint
        self.alienType = alienType
    }
    
    init(alienID: Int) {
        self.updateID = SceneUpdate.overallUpdateID
        SceneUpdate.overallUpdateID += 1
        self.type = .RemoveAlien
        self.alienID = alienID
        self.targetID = nil
        self.spawnPoint = nil
        self.alienType = nil
    }
    
    init(alienID: Int, targetID: Int) {
        self.updateID = SceneUpdate.overallUpdateID
        SceneUpdate.overallUpdateID += 1
        self.type = .BulletShot
        self.alienID = alienID
        self.targetID = targetID
        self.spawnPoint = nil
        self.alienType = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        updateID = aDecoder.decodeInteger(forKey: CodingKeys.updateID.rawValue)
        type = aDecoder.decodeObject(forKey: CodingKeys.type.rawValue) as! UpdateTypes
        spawnPoint = Coordinate3D(vector: aDecoder.decodeObject(forKey: CodingKeys.spawnPoint.rawValue) as! SCNVector3)
        alienType = aDecoder.decodeObject(forKey: CodingKeys.alienType.rawValue) as? Alien.AlienType
        alienID = aDecoder.decodeInteger(forKey: CodingKeys.alienID.rawValue)
        targetID = aDecoder.decodeInteger(forKey: CodingKeys.targetID.rawValue)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(updateID, forKey: CodingKeys.updateID.rawValue)
        encoder.encode(type, forKey: CodingKeys.type.rawValue)
        encoder.encode(spawnPoint?.getVector(), forKey: CodingKeys.spawnPoint.rawValue)
        encoder.encode(alienID, forKey: CodingKeys.alienID.rawValue)
        encoder.encode(targetID, forKey: CodingKeys.targetID.rawValue)
        encoder.encode(alienType, forKey: CodingKeys.alienType.rawValue)
    }
}
