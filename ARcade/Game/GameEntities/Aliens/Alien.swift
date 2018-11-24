//
//  Alien.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Alien: GameActor {
    
    enum AlienType {
        case basic
        case diving
        case shooting
        case boss
        case multiTakedown
    }
    //declare variables
//    var maxHealth: Int // int: maximum health of vessel
//    var health: Int // int: remaining health of vessel
    var moveSpeed: Int // int: speed of vessel
//    var damage: Int //Invasion Damage: amount of damage to deal to City upon arrival
    var difficulty: Int // Variable that changes depending on room creator's difficulty setting
//    var model:SCNNode? //Model/Sprite: points to physical model
    var identifier: Int
    static var numOfAliens = 0
    var type: AlienType
    
    // initialize variable values
    init(type t: AlienType, difficulty dif: Int, health h: Int, damage d: Int, location loc: Coordinate3D, anchor a: ARAnchor, node n: SCNNode) {
        
        difficulty = dif
        identifier = Alien.numOfAliens
        Alien.numOfAliens += 1
        type = t
        
        switch t {
        //todo: implement case specific things
        
        case .boss:
            moveSpeed = 1
            super.init(health: h, maxHealth: h, damage: d, location: loc, anchor: a, node: n)
            break
        case .diving:
            moveSpeed = 2
            super.init(health: h, maxHealth: h, damage: d, location: loc, anchor: a, node: n)
            break
        case .shooting:
            moveSpeed = 1
            super.init(health: h, maxHealth: h, damage: d, location: loc, anchor: a, node: n)
            break
        case .multiTakedown:
            moveSpeed = 1
            super.init(health: h, maxHealth: h, damage: d, location: loc, anchor: a, node: n)
            break
        default: //case .basic:
            moveSpeed = 1
            super.init(health: h, maxHealth: h, damage: d, location: loc, anchor: a, node: n)
            break
        }
        
        
    }
    
    //Methods
    func ReachCity(city:City) -> Bool {
        /*returns true if city destroyed, false if city alive*/
        
        
        if (city.takeDamage(from: damage) == lifeState.dead){
            city.death()
            return true;
        }
        return false
    }
    
    func getmoveSpeed() -> Int{
        return moveSpeed;
        
    }
    
    deinit {
        //If necessary, implement destruction logic here.
        
    }
}
