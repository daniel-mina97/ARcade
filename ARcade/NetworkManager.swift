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
    
    func startAdvertising() {
        advertiser = MCAdvertiserAssistant(serviceType: gameServiceType, discoveryInfo: nil, session: session)
        advertiser!.start()
    }
    
    func stopAdvertising() {
        advertiser!.stop()
    }
    
    func send<T>(object: T) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
            else {
                print("ERROR: Unable to encode object of type \(T.self)")
                return
        }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            print("INFO: Sent object of type \(T.self) to peers successfully.")
        } catch {
            print("ERROR: \(error)")
        }
    }
}

extension NetworkManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let data = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [ScenePeerInitialization.self, GameAction.self, SceneUpdate.self], from: data) {
                switch data {
                case let gameAction as GameAction:
                    print("INFO: GameAction Detected. \(gameAction.sourceID)")
                case let sceneUpdate as SceneUpdate:
                    print("INFO: SceneUpdate Detected. \(sceneUpdate.type)")
                case let beginningWorldState as ScenePeerInitialization:
                    print("INFO: ScenePeerInitialization recieved.")
                default:
                    print("ERROR: Unable to convert unarchived data to relevant data type.")
                }
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("INFO: Peer \(peerID.displayName) changed state.")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("INFO: Stream recieved.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("INFO: Started receiving resource with name '\(resourceName)'")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("INFO: Finished receiving resource with name '\(resourceName)'")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("INFO: Recieved certificate.")
    }
}

