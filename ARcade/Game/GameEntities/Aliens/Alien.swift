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
    //declare variables
//    var maxHealth: Int // int: maximum health of vessel
//    var health: Int // int: remaining health of vessel
    var moveSpeed: Int // int: speed of vessel
//    var damage: Int //Invasion Damage: amount of damage to deal to City upon arrival
    var difficulty: Int // Variable that changes depending on room creator's difficulty setting
//    var model:SCNNode? //Model/Sprite: points to physical model
    
    // initialize variable values
    init(difficulty dif: Int, moveSpeed m: Int, health h: Int, maxHealth mh: Int, damage d: Int,
         canShoot cs: Bool, canMove cm: Bool, location loc: Coordinate3D,
         anchor a: ARAnchor, node n: SCNNode) {
        moveSpeed = m
        difficulty = dif
        super.init(health: h, maxHealth: mh, damage: d, canShoot: cs, canMove: cm, location: loc, anchor: a, node: n)
    }
    
    //Methods
    func ReachCity(/*city:City! */) -> Bool {
        
        //todo:implement method
        return true;
    }
    deinit {
        //If necessary, implement destruction logic here.
        
    }
}
