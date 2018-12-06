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
    
    enum UpdateTypes: Int, Codable {
        case SpawnAlien
        case RemoveAlien
        case SpawnPickup
        case BulletShot
        case PlayerShot
        case EndGame
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case alienID
        case targetID
        case spawnPointX
        case spawnPointY
        case spawnPointZ
        case healthProgress
        case alienType
       
    }
    
    let type: UpdateTypes
    let alienID: Int
    let targetID: Int
    let spawnPointX: Float
    let spawnPointY: Float
    let spawnPointZ: Float
    let healthProgress: Float
    let alienType: Alien.AlienType
    
    init(alienID: Int, alienType: Alien.AlienType, spawnPoint: Coordinate3D) {
        self.type = .SpawnAlien
        self.alienID = alienID
        self.targetID = -100
        self.spawnPointX = spawnPoint.x
        self.spawnPointY = spawnPoint.y
        self.spawnPointZ = spawnPoint.z
        self.healthProgress = 0.0
        self.alienType = alienType
    }
    
    init(alienID: Int) {
        self.type = .RemoveAlien
        self.alienID = alienID
        self.targetID = -100
        self.spawnPointX = 0.0
        self.spawnPointY = 0.0
        self.spawnPointZ = 0.0
        self.healthProgress = 0.0
        self.alienType = .filler
    }
    
    init(alienID: Int, targetID: Int) {
        self.type = .BulletShot
        self.alienID = alienID
        self.targetID = targetID
        self.spawnPointX = 0.0
        self.spawnPointY = 0.0
        self.spawnPointZ = 0.0
        self.healthProgress = 0.0
        self.alienType = .filler
    }
    
    init(healthProgress: Float, playerID: Int) {
        self.type = .PlayerShot
        self.alienID = 0
        self.targetID = playerID
        self.spawnPointX = 0.0
        self.spawnPointY = 0.0
        self.spawnPointZ = 0.0
        self.healthProgress = healthProgress
        self.alienType = .filler
    }

    
    required init?(coder aDecoder: NSCoder) {
        type = UpdateTypes(rawValue: aDecoder.decodeInteger(forKey: CodingKeys.type.rawValue))!
        alienID = aDecoder.decodeInteger(forKey: CodingKeys.alienID.rawValue)
        targetID = aDecoder.decodeInteger(forKey: CodingKeys.targetID.rawValue)
        spawnPointX = aDecoder.decodeFloat(forKey: CodingKeys.spawnPointX.rawValue)
        spawnPointY = aDecoder.decodeFloat(forKey: CodingKeys.spawnPointY.rawValue)
        spawnPointZ = aDecoder.decodeFloat(forKey: CodingKeys.spawnPointZ.rawValue)
        healthProgress = aDecoder.decodeFloat(forKey: CodingKeys.healthProgress.rawValue)
        alienType = Alien.AlienType(rawValue: aDecoder.decodeInteger(forKey: CodingKeys.alienType.rawValue))!
        
    }
    
    func encode(with encoder: NSCoder) {

        encoder.encode(type.rawValue, forKey: CodingKeys.type.rawValue)
        encoder.encode(alienID, forKey: CodingKeys.alienID.rawValue)
        encoder.encode(targetID, forKey: CodingKeys.targetID.rawValue)
        encoder.encode(spawnPointX, forKey: CodingKeys.spawnPointX.rawValue)
        encoder.encode(spawnPointY, forKey: CodingKeys.spawnPointY.rawValue)
        encoder.encode(spawnPointZ, forKey: CodingKeys.spawnPointZ.rawValue)
        encoder.encode(healthProgress, forKey: CodingKeys.healthProgress.rawValue)
        encoder.encode(alienType.rawValue, forKey: CodingKeys.alienType.rawValue)
    }
}
