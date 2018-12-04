//
//  PGameAction.swift
//  ARcade
//
//  Created by Daniel Mina on 11/8/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class GameAction: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    enum ActionTypes: Int, Codable {
        case playerShootAlien
        case playerShootMultiTakedown
        case alienShootPlayer
        case alienShootCity
        case alienCrashIntoCity
        case pickup
    }
    
    enum CodingKeys: String, CodingKey {
        case actionType
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
    
    required init?(coder aDecoder: NSCoder) {
        type = ActionTypes(rawValue: aDecoder.decodeInteger(forKey: CodingKeys.actionType.rawValue))!
        actionID = aDecoder.decodeInteger(forKey: CodingKeys.actionID.rawValue)
        sourceID = aDecoder.decodeInteger(forKey: CodingKeys.sourceID.rawValue)
        targetID = aDecoder.decodeInteger(forKey: CodingKeys.targetID.rawValue)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(type.rawValue, forKey: CodingKeys.actionType.rawValue)
        encoder.encode(actionID, forKey: CodingKeys.actionID.rawValue)
        encoder.encode(sourceID, forKey: CodingKeys.sourceID.rawValue)
        encoder.encode(targetID, forKey: CodingKeys.targetID.rawValue)
    }
}


