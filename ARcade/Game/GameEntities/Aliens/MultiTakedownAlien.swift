//
//  MultiTakedownAlien.swift
//  ARcade
//
//  Created by Warren, Troy Wayne on 11/17/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
class MultiTakedownAlien: Alien {
    //
    //    var maxHealth: Int // int: maximum health of vessel
    //    var health: Int // int: remaining health of vessel
    //    var speed: Int // int: speed of vessel
    //    var damage: Int //Invasion Damage: amount of damage to deal to City upon arrival
    //    var difficulty: Int // Variable that changes depending on room creator's difficulty setting
    //    var model:SCNNode? //Model/Sprite: points to physical model
    var listOfIdentifiers: [Int] = [Int]()
    
    func TakeDamage(sourceId s: Int) -> lifeState {
        listOfIdentifiers.append(s)
        health -= 1
        if (health == 0){
            return lifeState.dead
        }
        return lifeState.alive
    }
    
}

