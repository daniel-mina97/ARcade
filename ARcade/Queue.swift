//
//  Queue.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 12/1/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class Queue<Type> {
    
    var head: QueueNode<Type>?
    var tail: QueueNode<Type>?
    var size: Int
    
    init(){
        size = 0
    }
    
    func isEmpty() -> Bool{
        return size == 0
    }
    
    func dequeue () -> Type? {
        if (!isEmpty()){
            size -= 1
            let node: QueueNode<Type> = head!
            head = head!.child
            return node.action
        }
        else {
            return nil
        }
    }
    
    func enqueue (act: Type){
        let node: QueueNode<Type> = QueueNode<Type>(a: act)
        if(isEmpty()){
            head = node
            tail = node
        }
        else{
            tail?.child = node
            tail = node
        }
        size += 1
    }
    
}

class QueueNode<Type> {
    var action: Type!
    var child: QueueNode<Type>?
    
    init(a: Type){
        action = a
    }
}
