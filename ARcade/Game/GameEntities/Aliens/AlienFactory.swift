//
//  AlienFactory.swift
//  ARcade
//
//  Created by Nathan Dill on 11/24/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit

class AlienFactory {
    // initialize letiable values
    static func createAlien(type t: Alien.AlienType, node n: SCNNode) -> Alien {
        switch t {
            //todo: implement case specific things
            
        case .boss:
            let damage = 1
            let health = 1
            let speed = 1
            return Alien(type: t, moveSpeed: speed, health: health, damage: damage, node: n)
            
        case .diving:
            let damage = 1
            let health = 1
            let speed = 1
            return Alien(type: t, moveSpeed: speed, health: health, damage: damage, node: n)
            
        case .shooting:
            let damage = 1
            let health = 1
            let speed = 1
            return Alien(type: t, moveSpeed: speed, health: health, damage: damage, node: n)
            
        case .multiTakedown:
            let damage = 1
            let health = 1
            let speed = 1
            return Alien(type: t, moveSpeed: speed, health: health, damage: damage, node: n)
        }
    }
}
