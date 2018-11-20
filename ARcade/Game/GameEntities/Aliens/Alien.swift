//
//  Alien.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class Alien: GameActor {
    //declare variables
//    var maxHealth: Int // int: maximum health of vessel
//    var health: Int // int: remaining health of vessel
//    var speed: Int // int: speed of vessel
//    var damage: Int //Invasion Damage: amount of damage to deal to City upon arrival
//    var difficulty: Int // Variable that changes depending on room creator's difficulty setting
//    var model:SCNNode? //Model/Sprite: points to physical model
    
    // initialize variable values
    init() {
        maxHealth = 10
        health = 10
        speed = 1
        damage = 1
        difficulty = 1
        model = nil
    }
    init(theModel:SCNNode) {
        maxHealth = 10
        health = 10
        speed = 1
        damage = 1
        difficulty = 1
        model = theModel
    }
    init(setDifficulty:Int, theModel:SCNNode) {
        difficulty = setDifficulty
        maxHealth = 10
        health = 10
        speed = 1
        damage = 1
        model = theModel
    }
    
    //Methods
    //todo: implement get-set for health?
    func Move(/*unknown*/) -> Bool {
        //todo:implement method
        return true;
    }
    func ReachCity(/*city:City! */) -> Bool {
        
        //todo:implement method
        return true;
    }
    deinit {
        //If necessary, implement destruction logic here.
        model?.removeFromParentNode()
    }
}
