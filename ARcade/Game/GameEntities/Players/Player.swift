//
//  Player.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Player: GameActor {
    //var health: Int
    //var damage: Int
    
    var playerNumber: Int // gives player a number to calculate how many unique players have shot MultiTakedownAlien
    
    init(playerNumber pn: Int, health h: Int, maxHealth mh: Int, damage d: Int, canShoot cs: Bool, canMove cm: Bool, anchor a: ARAnchor, node n: SCNNode) {
        playerNumber = pn
        var loc = 
        
        super.init(health: h, maxHealth: mh, damage: d, location: loc, anchor: a, node: n)
    }
}

