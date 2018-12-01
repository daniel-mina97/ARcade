//
//  NetworkManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/15/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class NetworkManager: NSObject {
    var isHost: Bool
    var playerID: Int
    let session: MCSession
    var advertiser: MCAdvertiserAssistant?
    var browser: MCBrowserViewController?
    let gameServiceType: String = "session-share"

    init(host: Bool, displayName: String){
        isHost = host
        playerID = 1
        let myPeerID: MCPeerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: myPeerID)
    }
    
    func startHosting() {
        advertiser = MCAdvertiserAssistant(serviceType: gameServiceType, discoveryInfo: nil, session: session)
        advertiser!.start()
    }
    
    func send(worldUpdate: SceneUpdate) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(NSKeyedArchiver.archivedData(withRootObject: worldUpdate, requiringSecureCoding: false), toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("Error occured: \(error)")
            }
        }
    }

    func send(gameAction: GameAction) {
        if session.connectedPeers.count > 0 {
            do {
                // should only send to host instead of all connected peers
                guard let jsonData = GameActionToJson(action: gameAction) else {return}
                try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
                return
            }
            catch let error {
                print("Error occured: \(error)")
            }
        }
    }

    func GameActionToJson(action: GameAction) -> Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(action)
            return jsonData
        }
        catch {
            print("GameActionToJson failed.")
        }
        return nil
    }

    func JsonToGameAction(json: Data) -> GameAction? {
        let jsonDecoder = JSONDecoder()
        do {
            let recievedData = try jsonDecoder.decode(GameAction.self, from: json)
            return recievedData
        }
        catch {
            print("JsonToGameAction failed.")
        }
        return nil
    }
}

