//
//  GameManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

enum GameState{
    case startup
    case lookingForPlane
    case planeFound
    case PlacingCity
    case CityPlaced
    case ongoing
    case ending
}

class GameManager{
    var players: [Int: Player]
    var aliens: [Int: Alien]
    var city: City!
    var queue: GameActionQueue!
    var isHost: Bool
    var sessionState: GameState
    let localID: Int
    
    init(host: Bool, scene: SCNScene, id: Int) {
        queue = GameActionQueue()
        //city = City()
        isHost = host
        sessionState = .startup
        players = [:]
        aliens = [:]
        localID = id
    }
    
    func executeNextAction(){
        
        guard let action = queue.dequeue() else {return}
        
        switch action.type {
        case .playerShootAlien:
            if aliens[action.targetID]!.takeDamage(from: players[action.sourceID]!.damage) == GameActor.lifeState.dead {
                aliens[action.targetID] = nil
            }
            break
        case .alienShootPlayer:
            if players[action.targetID]!.takeDamage(from : aliens[action.sourceID]!.damage) == GameActor.lifeState.dead {
                // players[action.targetID] = nil
                // We don't want to just kick the player out...
            }
            break
        case .alienShootCity:
            if city.takeDamage(from: aliens[action.sourceID]!.damage) == GameActor.lifeState.dead {
                // Game over!!
            }
            break
        case .pickup:
            // Pick it up
            break
        }
        
    }
    
    }
}
