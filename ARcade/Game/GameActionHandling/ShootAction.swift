//
//  ShootAction.swift
//  ARcade
//
//  Created by Daniel Mina on 11/8/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class ShootAction : GameAction, PGameAction {
    var source : GameActor
    var destination : GameActor
    
    init(source: GameActor, destination: GameActor) {
        self.source = source
        self.destination = destination
    }
    
    func execute() {
        destination.takeDamage(damage: source.damage)
    }
}
