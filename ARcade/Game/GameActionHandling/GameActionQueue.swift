//
//  GameActionQueue.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/14/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class GameActionQueue {
    
    var head: GameActionQueueNode?
    var tail: GameActionQueueNode?
    var size: Int
    
    init(){
        size = 0
    }
    
    func isEmpty() -> Bool{
        return size == 0
    }
    
    func dequeue () -> GameAction? {
        if (!isEmpty()){
            size -= 1
            let node: GameActionQueueNode = head!
            head = head!.child
            return node.action
        }
        else {
            return nil
        }
    }
    
    func enqueue (act: GameAction){
        size += 1
        let node: GameActionQueueNode = GameActionQueueNode(a: act)
        if(isEmpty()){
            head = node
            tail = node
        }
        else{
            tail?.child = node
            tail = node
        }
    }
    
}

class GameActionQueueNode {
    var action: GameAction!
    var child: GameActionQueueNode?
    
    init(a: GameAction){
        action = a
    }
    
    func addChild (node: GameActionQueueNode){
        child = node
    }
}
