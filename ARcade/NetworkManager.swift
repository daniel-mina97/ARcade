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
    var hostID: MCPeerID?
    let session: MCSession
    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?
    let gameServiceType: String = "ARcadeSession"

    init(host: Bool, displayName: String){
        isHost = host
        let myPeerID: MCPeerID = MCPeerID(displayName: displayName)
        playerID = myPeerID.hash
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        self.session.delegate = self
    }
    
    func startAdvertising() {
        advertiser = MCNearbyServiceAdvertiser(peer: session.myPeerID, discoveryInfo: nil, serviceType: gameServiceType)
        advertiser?.delegate = self
        advertiser!.startAdvertisingPeer()
        print("INFO: Advertiser started.")
    }
    
    func stopAdvertising() {
        advertiser!.stopAdvertisingPeer()
    }
    
    func send<T>(object: T) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            else {
                print("ERROR: Unable to encode object of type \(T.self)")
                return
        }
        do {
            if object is GameAction {
                try session.send(data, toPeers: [hostID!], with: .reliable)
            } else if object is SceneUpdate || object is ScenePeerInitialization {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            print("INFO: Sent object of type \(T.self) to peers successfully.")
        } catch {
            print("ERROR: \(error)")
        }
    }
}

extension NetworkManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension NetworkManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("INFO: \(peerID.displayName) connected")
        case .connecting:
            print("INFO: \(peerID.displayName) connecting")
        case .notConnected:
            print("INFO: \(peerID.displayName) not connected")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("I recieved data")
        do {
            if let data = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [ScenePeerInitialization.self, GameAction.self, SceneUpdate.self], from: data) {
                switch data {
                case let gameAction as GameAction:
                    print("INFO: GameAction Detected. \(gameAction.sourceID)")
                case let sceneUpdate as SceneUpdate:
                    print("INFO: SceneUpdate Detected. \(sceneUpdate.type)")
                case let startingState as ScenePeerInitialization:
                    hostID = startingState.hostID
                    print("INFO: ScenePeerInitialization Detected.")
                default:
                    print("ERROR: Unable to convert unarchived data to relevant data type.")
                }
            }
        } catch {
            print("ERROR: \(error)")
        }
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
    
    /*
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
        print("INFO: Recieved certificate.")
    }
    */
}

