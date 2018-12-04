//
//  SceneManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/17/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit

class SceneManager {
    
    var scene: SCNScene
    var sceneNode: SCNNode?
    var cityPlaced: Bool = false
    var manager: GameManager!
    
    init(scene: SCNScene){
        self.scene = scene
    }
    
    func makeAlien(id: Int, type: Alien.AlienType, at: SCNVector3) -> SCNNode{
        var newAlienNode: SCNNode!
        switch type{
        case Alien.AlienType.shooting:
            newAlienNode = spawnAlienShooter(id: id, x: at.x, y: at.y, z: at.z)
            break
        case Alien.AlienType.boss:
            newAlienNode = spawnAlienBoss(id: id, x: at.x, y: at.y, z: at.z)
            break
        case Alien.AlienType.diving:
            newAlienNode = spawnAlienDiver(id: id, x: at.x, y: at.y, z: at.z)
            break
        case Alien.AlienType.multiTakedown:
            newAlienNode = spawnAlienMultiTakedown(id: id, x: at.x, y: at.y, z: at.z)
            break
        }
        newAlienNode.name = "A" + newAlienNode.name!
        sceneNode?.addChildNode(newAlienNode)
        return newAlienNode
    }
    
    func setSceneNode (node: SCNNode) {
        sceneNode = node
    }
    
    func makePickup(id: Int, at: SCNVector3) -> SCNNode{
        let pickupNode = spawnPickup(x: at.x, y: at.y, z: at.z)
        pickupNode.name = "P" + pickupNode.name!
        return pickupNode
    }
    
    func add(node: SCNNode){
        sceneNode?.addChildNode(node)
    }
    
    func remove(node: SCNNode){
        node.removeFromParentNode()
    }
    
    func getIDFromNode(node: SCNNode) -> Int{
        return Int(node.name!)!
    }
    
    func getAlienMoveAction(object: SCNNode, to city: SCNVector3, speed: Int) -> SCNAction{
        let newVector: SCNVector3 = SCNVector3(x: city.x, y: city.y + 0.2, z: city.z)
        let action =  SCNAction.move(to: newVector, duration: 30.0/Double(speed))
        return action
    }
    
    func getBulletMoveAction(object: SCNNode, to city: SCNVector3, speed: Int) -> SCNAction{
        let action =  SCNAction.move(to: city, duration: 30.0/Double(speed))
        return action
    }
    
    func creatAlienBullet(spawnPosition: SCNVector3) -> SCNNode{
        
        let sphere = SCNSphere(radius: 0.01)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = spawnPosition
        sphereNode.name = "-1"
        add(node: sphereNode)
        return sphereNode
    }
    
   
    func spawnObject(asset: String, scale: Float, id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        let scene = SCNScene(named: asset)!
        let node = SCNNode()
        let sceneChildNodes = scene.rootNode.childNodes
        for childNode in sceneChildNodes{
            node.addChildNode(childNode)
        }
        node.scale = SCNVector3(x: scale, y: scale, z: scale)
        node.position = SCNVector3(x: x, y: y, z: z)
        node.name = String(id)
        return node
    }
    
    func spawnAlienDiver(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning diver alien.")
        return spawnObject(asset: "art.scnassets/diving_alien_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienShooter(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning shooter alien.")
        return spawnObject(asset: "art.scnassets/basic_alien_shooting_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienMultiTakedown(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning multi-takedown alien.")
        return spawnObject(asset: "art.scnassets/multi_takedown_alien_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienBoss(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning boss alien.")
        return spawnObject(asset: "art.scnassets/alien_boss_ship.dae", scale: 0.2, id: id, x: x, y: y, z: z)
    }
    
    func spawnCity(id: Int = -1, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning city.")
        return spawnObject(asset: "art.scnassets/City.dae", scale: 0.03, id: id, x: x, y: y, z: z)    }
    
    func spawnPickup(id: Int = 0, x: Float, y: Float, z: Float) -> SCNNode{
        print("ARCADE-INFO: Spawning pickup.")
        return spawnObject(asset: "art.scnassets/health_pickup.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func apply(this update: SceneUpdate) {
        switch update.type {
        case .SpawnAlien:
            add(node: makeAlien(id: update.alienID, type: update.alienType!, at: (update.spawnPoint?.getVector())!))
        case .RemoveAlien:
            remove(node: manager.aliens![update.alienID]!.node!)
        case .SpawnPickup:
            print("ARCADE-ERROR: No implementation for spawning pickups.")
        case .BulletShot:
            manager.AlienShootCity(alienID: update.alienID)
        case .EndGame:
            manager.endGame()
        }
    }
}
