//
//  NetworkManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/15/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkManager: NSObject {
    var isHost: Bool
    var playerID: Int
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser?
    let browser: MCNearbyServiceBrowser?
    let gameServiceType: String = "session-share"

    init(host: Bool){
        isHost = host
        playerID = 1
        let myPeerID: MCPeerID = MCPeerID(displayName: String(playerID))
        session = MCSession(peer: myPeerID)
        if isHost {
            advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: gameServiceType)
            advertiser?.startAdvertisingPeer()
            browser = nil
        } else {
            browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: gameServiceType)
            browser?.startBrowsingForPeers()
            advertiser = nil
        }
    }

    deinit {
        if isHost {
            advertiser?.stopAdvertisingPeer()
        } else {
            browser?.stopBrowsingForPeers()
        }
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

extension NetworkManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        // do something
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension NetworkManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // do something
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        // do something
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
}
