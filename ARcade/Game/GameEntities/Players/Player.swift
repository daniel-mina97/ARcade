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
    
    enum PlayerType {
        case balanced
        case damage
        case tank
    }
    
    
    init(playerType type: PlayerType) {
        switch type {
        case .damage:
            let h = 1
            let d = 3
            super.init(health: h, maxHealth: h, damage: d, node: nil)
            
        case .tank:
            let h = 3
            let d = 1
            super.init(health: h, maxHealth: h, damage: d, node: nil)
            
        default:
            let h = 2
            let d = 2
            super.init(health: h, maxHealth: h, damage: d, node: nil)
        }
        //var loc = self
        
        
    }
}

