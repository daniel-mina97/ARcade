//
//  GameActor.swift
//  ARcade
//
//  Created by Daniel Mina on 11/15/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class GameActor {
    var health: Int
    var damage: Int
    
    init(health: Int, damage: Int) {
        self.health = health
        self.damage = damage
    }
    
    func takeDamage(damage: Int) {
        health -= damage
    }
}
