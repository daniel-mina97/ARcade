//
//  NetworkManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/15/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation

class NetworkManager {
    var isHost: Bool
    var playerID: Int
    
    init(host: Bool){
        isHost = host
        playerID = 1
    }
}
