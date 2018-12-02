//
//  PGameAction.swift
//  ARcade
//
//  Created by Daniel Mina on 11/8/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class GameAction: Codable {
    
    enum ActionTypes: String, Codable {
        case playerShootAlien
        case playerShootMultiTakedown
        case alienShootPlayer
        case alienShootCity
        case alienCrashIntoCity
        case pickup
    }
    
    enum CodingKeys: String, CodingKey {
        case actionType = "actionType"
        case actionID
        case sourceID
        case targetID
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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(ActionTypes.self, forKey: .actionType)
        actionID = try values.decode(Int.self, forKey: .actionID)
        sourceID = try values.decode(Int.self, forKey: .sourceID)
        targetID = try values.decode(Int.self, forKey: .targetID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .actionType)
        try container.encode(actionID, forKey: .actionID)
        try container.encode(sourceID, forKey: .sourceID)
        try container.encode(targetID, forKey: .targetID)
    }
}


