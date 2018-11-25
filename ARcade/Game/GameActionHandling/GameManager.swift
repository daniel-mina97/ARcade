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
    var sceneManager: SceneManager
    var players: [Int: Player]
    var aliens: [Int: Alien]
    var city: City!
    var queue: GameActionQueue!
    var isHost: Bool
    var sessionState: GameState
    let localID: Int
    
    init(host: Bool, scene: SCNScene, id: Int) {
        queue = GameActionQueue()
        sceneManager = SceneManager(scene: scene)
        //city = City()
        isHost = host
        sessionState = .startup
        players = [:]
        aliens = [:]
        localID = id
    }
    
    func spawnCity(x: Float, y: Float, z: Float) -> SCNNode{
        return sceneManager.spawnCity(x: x, y: y, z: z)
    }
    
    func executeNextAction() {
        
        guard let action = queue.dequeue() else {return}
        
        switch action.type {
        case .playerShootAlien:
            if aliens[action.targetID]!.takeDamage(from: players[action.sourceID]!.damage) == GameActor.lifeState.dead {
                aliens[action.targetID] = nil
            }
            break
        case .playerShootMultiTakedown:
            if aliens[action.targetID]!.takeDamage(from: action.sourceID) == GameActor.lifeState.dead {
                aliens[action.targetID] = nil
            }
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
    
    func nodeTapped(node: SCNNode) {
        let typeOfNode: Character = node.name!.removeFirst()
        let nodeID: Int = Int(node.name!)!
        var gameAction: GameAction?
        if typeOfNode == "A" {
            gameAction = GameAction(type: GameAction.ActionTypes.playerShootAlien, sourceID: localID,
                                                    targetID: nodeID)
        } else if typeOfNode == "P" {
            gameAction = GameAction(type: GameAction.ActionTypes.pickup, sourceID: localID, targetID: nodeID)
        }
        if let gameAction = gameAction {
            if isHost {
                queue.enqueue(act: gameAction)
            } else {
                // send gameAction to host
            }
        }
    }
}
