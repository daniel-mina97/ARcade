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
    var gameManagerDelegate: GameManager!
    let gameServiceType: String = "ARcadeSession"
    var numberOfPeersAcknowledged: Int
    
    init(host: Bool, displayName: String){
        isHost = host
        let myPeerID: MCPeerID = MCPeerID(displayName: displayName)
        playerID = myPeerID.hash
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        numberOfPeersAcknowledged = 0
        super.init()
        self.session.delegate = self
    }
    
    func startAdvertising() {
        advertiser = MCNearbyServiceAdvertiser(peer: session.myPeerID, discoveryInfo: nil, serviceType: gameServiceType)
        advertiser?.delegate = self
        advertiser!.startAdvertisingPeer()
        print("ARCADE-INFO: Advertiser started.")
    }
    
    func stopAdvertising() {
        advertiser!.stopAdvertisingPeer()
    }
    
    func send<T>(object: T) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            else {
                print("ARCADE-ERROR: Unable to encode object of type \(T.self)")
                return
        }
        do {
            if object is GameAction || object is IntegerAcknowledge {
                try session.send(data, toPeers: [hostID!], with: .reliable)
            } else if object is SceneUpdate || object is ScenePeerInitialization {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            print("ARCADE-INFO: Sent object of type \(T.self) to peers successfully.")
        } catch {
            print("ARCADE-ERROR: \(error)")
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
            print("ARCADE-INFO: \(peerID.displayName) connected")
            
        case .connecting:
            print("ARCADE-INFO: \(peerID.displayName) connecting")
        case .notConnected:
            print("ARCADE-INFO: \(peerID.displayName) not connected")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("I recieved data")
        do {
            if let data = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [ScenePeerInitialization.self, GameAction.self, SceneUpdate.self, IntegerAcknowledge.self], from: data) {
                switch data {
                case let gameAction as GameAction:
                    print("ARCADE-INFO: GameAction Detected. \(gameAction.sourceID)")
                    gameManagerDelegate.actionQueue!.enqueue(act: gameAction)
                case let sceneUpdate as SceneUpdate:
                    print("ARCADE-INFO: SceneUpdate Detected. \(sceneUpdate.type)")
                    print("LOOK HERE2: \(sceneUpdate.alienID)")
                    gameManagerDelegate.apply(this: sceneUpdate)
                case let startingState as ScenePeerInitialization:
                    print("ARCADE-INFO: ScenePeerInitialization Detected.")
                    hostID = startingState.hostID
                    gameManagerDelegate.peerGameSetup(map: startingState.worldMap, cityAnchor: startingState.cityAnchor)
                case _ as IntegerAcknowledge:
                    print("ARCADE-INFO: Acknowledgement Detected.")
                    numberOfPeersAcknowledged += 1
                default:
                    print("ARCADE-ERROR: Unable to convert unarchived data to relevant data type.")
                }
            }
        } catch {
            print("ARCADE-ERROR: \(error)")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("ARCADE-INFO: Stream recieved.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("ARCADE-INFO: Started receiving resource with name '\(resourceName)'")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("ARCADE-INFO: Finished receiving resource with name '\(resourceName)'")
    }
    
    /*
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
        print("ARCADE-INFO: Recieved certificate.")
    }
    */
}

class IntegerAcknowledge: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    let message: Int
    
    init(message: Int) {
        self.message = message
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(message, forKey: CodingKeys.message.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        message = aDecoder.decodeInteger(forKey: CodingKeys.message.rawValue)
    }
}
