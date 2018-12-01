//
//  Alien.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Alien: GameActor {
    
    enum AlienType {
        case diving
        case shooting
        case boss
        case multiTakedown
    }
    
    static let AlienTypeArray = [AlienType.diving, AlienType.shooting, AlienType.multiTakedown]

    var moveSpeed: Int
    var identifier: Int
    static var numOfAliens = 0
    var type: AlienType
    static var numOfPlayers = 0
    var listOfIdentifiers: [Int] = [Int]()
    
    init(type t: AlienType, moveSpeed m: Int, health h: Int,
        damage d: Int, node n: SCNNode) {
        moveSpeed = m
        identifier = Alien.numOfAliens
        Alien.numOfAliens += 1
        type = t
        
        super.init(health: h, maxHealth: h, damage: d, node: n)
    }
    
    func ReachCity(city:City) -> Bool {
        if (city.takeDamage(from: damage) == lifeState.dead){
            city.death()
            return true;
        }
        return false
    }
    
    func takeDamage(fromPlayerNumber playerNumber: Int) -> GameActor.lifeState {
        /// Specific implementation for MultiTakeDownType alien
        print("LOOK HERE: \(Alien.numOfPlayers)")
        print("LOOK HERE: \(listOfIdentifiers.count)")
        if (!listOfIdentifiers.contains(playerNumber)){
            listOfIdentifiers.append(playerNumber)
        }
        if (listOfIdentifiers.count == Alien.numOfPlayers){
            return lifeState.dead
        }
        return lifeState.alive
    }
    
    func getmoveSpeed() -> Int{
        return moveSpeed;
        
    }
}
