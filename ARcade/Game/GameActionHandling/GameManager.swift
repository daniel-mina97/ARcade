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
    case ongoing
    case ending
    case ended
}

class GameManager{
    var sceneManager: SceneManager
    var players: [Int: Player]
    var aliens: [Int: Alien]
    var targetList: [Int]
    var city: City!
    var queue: GameActionQueue!
    var isHost: Bool
    var sessionState: GameState
    var spawnAlienTimer: Timer?
    var alienShotTimer: Timer?
    var actionTimer: Timer?
    let localID: Int
    
    static let MAX_ALIENS: Int = 15
    
    init(host: Bool, scene: SCNScene, id: Int) {
        sessionState = .startup
        queue = GameActionQueue()
        sceneManager = SceneManager(scene: scene)
        isHost = host
        players = [:]
        aliens = [:]
        targetList = []
        localID = id
    }
    
    func startGame(cityNode: SCNNode) {
        sessionState = .ongoing
        city = City(node: cityNode)
        players[1] = Player(playerType: .balanced)
        Alien.numOfPlayers = players.count
        targetList.append(-1)
        for player in players.keys{
            targetList.append(player)
        }
        spawnAlienTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnAlien), userInfo: nil, repeats: true)
        actionTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(executeNextAction), userInfo: nil, repeats: true)
        alienShotTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(createAlienShots), userInfo: nil, repeats: true)
    }
    
    func endGame() {
        sessionState = .ending
        spawnAlienTimer?.invalidate()
        actionTimer?.invalidate()
        alienShotTimer?.invalidate()
        //scoreboard??????
        // if scoreboard send peers score list
        //segue back to main menu after update session
        sessionState = .ended
    }
    
    @objc func createAlienShots(){
        let numberOfShooters: Int
        var alienList: [Int] = []
        for element in aliens.keys{
            if aliens[element]?.type != Alien.AlienType.diving{
                alienList.append(element)
            }
        }
        if alienList.count > 3 {
            numberOfShooters = Int.random(in: 0...3)
        }
        else{
            numberOfShooters = Int.random(in: 0...alienList.count)
        }
        var shooterList: [Int] = []
        for _ in 0..<numberOfShooters{
            let alienChosen: Int = alienList.randomElement()!
            alienList.remove(at: alienList.firstIndex(of: alienChosen)!)
            shooterList.append(alienChosen)
        }
        for shooter in shooterList{
            let target = targetList.randomElement()
            let action: GameAction
            if target == -1 {
                action = GameAction(type: .alienShootCity, sourceID: shooter, targetID: target!)
            }
            else{
                action = GameAction(type: .alienShootPlayer, sourceID: shooter, targetID: target!)
            }
            queue.enqueue(act: action)
        }
    }
    
    @objc func spawnAlien() {
        if aliens.count >= GameManager.MAX_ALIENS {return}
        if let alienType: Alien.AlienType = Alien.AlienTypeArray.randomElement() {
            let spawnCoordinates: SCNVector3 = getSpawnCoordinates().getVector()
            let alienNode: SCNNode = sceneManager.makeAlien(id: Alien.numOfAliens, type: alienType, at: spawnCoordinates)
            let alien: Alien = AlienFactory.createAlien(type: alienType, node: alienNode)
            aliens[alien.identifier] = alien
            let action = sceneManager.getMoveAction(alien: alien.node!, to: city!.node!.position, speed: alien.moveSpeed)
            //add alien crash into city gameaction
            alien.node?.runAction(action, completionHandler: {self.queue.enqueue(act: GameAction(type: .alienShootCity, sourceID: alien.identifier, targetID: 0))})
            // get coordinates relative to city location, not local coordinates
            // pass SceneUpdate
        }
    }
    
    func getSpawnCoordinates() -> Coordinate3D {
        let xSign: Int = [-1,1].randomElement()!
        let zSign: Int = [-1,1].randomElement()!
        let xCoordinate: Float = city.node!.position.x + Float(xSign) * Float.random(in: 2.0...5.0)
        let yCoordinate: Float = city.node!.position.y + Float.random(in: 0.2...1.0)
        let zCoordinate: Float = city.node!.position.z + Float(zSign) * Float.random(in: 2.0...5.0)
        return Coordinate3D(x: xCoordinate, y: yCoordinate, z: zCoordinate)
    }
    
    @objc func executeNextAction() {
        
        guard let action = queue.dequeue() else {return}
        
        switch action.type {
        case .playerShootAlien:
            print(aliens[action.targetID]?.health ?? -10)
            if aliens[action.targetID]!.takeDamage(from: players[action.sourceID]!.damage) == GameActor.lifeState.dead {
                aliens[action.targetID]!.node!.removeFromParentNode()
                aliens[action.targetID] = nil
            }
            break
        case .playerShootMultiTakedown:
            print(aliens[action.targetID]?.health ?? -10)
            if aliens[action.targetID]!.takeDamage(fromPlayerNumber: action.sourceID) == GameActor.lifeState.dead {
                aliens[action.targetID]!.node!.removeFromParentNode()
                aliens[action.targetID] = nil
            }
        case .alienShootPlayer:
            //make bullet -- depends on alien location
            //send bullet -- depends on player location
            //send to peer
            if players[action.targetID]!.takeDamage(from : aliens[action.sourceID]!.damage) == GameActor.lifeState.dead {
                // players[action.targetID] = nil
                // We don't want to just kick the player out...
            }
            break
        case .alienShootCity:
            if city.takeDamage(from: aliens[action.sourceID]!.damage) == GameActor.lifeState.dead {
                //Game Ends
                //Players Lose
                //send end game notification to other players
                endGame()
            }
            break
        case .pickup:
            // Pick it up
            break
        }
        
    }
    
    func nodeTapped(node: SCNNode) {
        print(node.name ?? "--unknown")
        if node.name == "-1" {
            return
        }
        let typeOfNode: Character = node.name!.removeFirst()
        let nodeID: Int = Int(node.name!)!
        node.name = String(typeOfNode)+node.name!
        var gameAction: GameAction?
        if typeOfNode == "A" {
            let typeOfAlien: Alien.AlienType = aliens[nodeID]!.type
            if typeOfAlien == Alien.AlienType.multiTakedown {
                gameAction = GameAction(type: GameAction.ActionTypes.playerShootMultiTakedown, sourceID: localID, targetID: nodeID)
            } else {
                gameAction = GameAction(type: GameAction.ActionTypes.playerShootAlien, sourceID: localID,
                    targetID: nodeID)
            }
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
    
    func spawnCity(x: Float, y: Float, z: Float) -> SCNNode{
        let cityNode = sceneManager.spawnCity(x: x, y: y, z: z)
        sceneManager.add(node: cityNode)
        return cityNode
    }
    
    func removeCity(node: SCNNode){
        sceneManager.remove(node: node)
    }
    
}

