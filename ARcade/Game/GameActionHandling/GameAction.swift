//
//  PGameAction.swift
//  ARcade
//
//  Created by Daniel Mina on 11/8/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class GameAction {
    
    enum ActionTypes {
        case playerShootAlien
        case alienShootPlayer
        case alienShootCity
        case pickup
    }
    
    static var overallActionID: Int = 0
    
    let type: ActionTypes
    let actionID: Int
    let sourceID: Int
    let targetID: Int
    
    init(type: ActionTypes, sourceID: Int, targetID: Int) {
        self.type = type
        self.actionID = GameAction.overallActionID
        GameAction.overallActionID += 1
        self.sourceID = sourceID
        self.targetID = targetID
    }
}


