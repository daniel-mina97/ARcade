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
    var sceneManager: SKSceneManager!
    var players: [Int: Player?]!
    var city: City!
    var aliens: [Int: Alien?]!
    var queue: GameActionQueue!
    var isHost: Bool
    var sessionState: GameState
    
    init(host: Bool, scene: SCNScene) {
        queue = GameActionQueue()
        //city = City()
        isHost = host
        sessionState = .startup
    }
    
    func addPlayer(player: Player){
        
    }
    
    func addAlien(alien: Alien){
        
    }
    
    func receiveAction(action: GameAction){
        queue.enqueue(act: action)
    }
    
    func executeNextAction(){
        guard let action = queue.dequeue() as? PGameAction else {return}
        action.execute()
    }
    
    func removePlayer(at: Int){
        players[at] = nil
    }
    
    func removeAlien(at: Int){
        aliens[at] = nil
    }
    
    func getActionQueue() -> GameActionQueue {
        return queue
    }
    
    func updateQueue(aq: GameActionQueue){
        //scary
    }
}
