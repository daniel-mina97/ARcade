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
    
    enum ActionTypes: String {
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
        type = aDecoder.decodeObject(forKey: CodingKeys.actionType.rawValue) as! ActionTypes
        actionID = aDecoder.decodeInteger(forKey: CodingKeys.actionID.rawValue)
        sourceID = aDecoder.decodeInteger(forKey: CodingKeys.sourceID.rawValue)
        targetID = aDecoder.decodeInteger(forKey: CodingKeys.targetID.rawValue)
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(type, forKey: CodingKeys.actionType.rawValue)
        encoder.encode(actionID, forKey: CodingKeys.actionType.rawValue)
        encoder.encode(sourceID, forKey: CodingKeys.actionType.rawValue)
        encoder.encode(targetID, forKey: CodingKeys.actionType.rawValue)
    }
}


