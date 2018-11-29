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
                // should only send to host
                try session.send(NSKeyedArchiver.archivedData(withRootObject: gameAction, requiringSecureCoding: false),
                    toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("Error occured: \(error)")
            }
        }
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
