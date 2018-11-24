//
//  SceneUpdate.swift
//  ARcade
//
//  Created by Daniel Mina on 11/24/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class SceneUpdate {
    
    enum UpdateTypes {
        case SpawnAlien
        case RemoveAlien
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
}
