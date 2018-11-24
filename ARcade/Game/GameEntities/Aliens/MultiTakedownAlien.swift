//
//  MultiTakedownAlien.swift
//  ARcade
//
//  Created by Warren, Troy Wayne on 11/17/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit

class MultiTakedownAlien: Alien {
    //
    //    var maxHealth: Int // int: maximum health of vessel
    //    var health: Int // int: remaining health of vessel
    //    var speed: Int // int: speed of vessel
    //    var damage: Int //Invasion Damage: amount of damage to deal to City upon arrival
    //    var difficulty: Int // Variable that changes depending on room creator's difficulty setting
    //    var model:SCNNode? //Model/Sprite: points to physical model
    var listOfIdentifiers: [Int]
    
    init(identifiers ident: [Int], difficulty dif: Int, moveSpeed m: Int, damage d: Int, canShoot cs: Bool, canMove cm: Bool, location loc: Coordinate3D, anchor a: ARAnchor, node n: SCNNode) {
        
        listOfIdentifiers = ident
        super.init(type: Alien.AlienType.multiTakedown, difficulty: dif, moveSpeed: m, health: 1, maxHealth: 1, damage: 1, location: loc, anchor: a, node: n)
    }
    
    func TakeDamage(sourceId s: Int) -> lifeState {
        
    }
    
}

