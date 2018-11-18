//
//  GameManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation


class GameManager{
    var players: [Player?]!
    var city: City!
    var aliens: [Alien?]!
    var queue: GameActionQueue!
    var isHost: Bool
    
    init(host: Bool) {
        queue = GameActionQueue()
        players = []
        aliens = []
        isHost = host
    }
    
    func addPlayer(player: Player){
        players.append(player)
    }
    
    func addAlien(alien: Alien){
        aliens.append(alien)
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
