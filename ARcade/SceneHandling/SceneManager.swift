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
    var cityPlaced: Bool = false
    
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
        scene.rootNode.addChildNode(newAlienNode)
        return newAlienNode
    }
    
    func makePickup(id: Int, at: SCNVector3) -> SCNNode{
        let pickupNode = spawnPickup(x: at.x, y: at.y, z: at.z)
        pickupNode.name = "P" + pickupNode.name!
        return pickupNode
    }
    
    func add(node: SCNNode){
        scene.rootNode.addChildNode(node)
    }
    
    func remove(node: SCNNode){
        node.removeFromParentNode()
    }
    
    func getIDFromNode(node: SCNNode) -> Int{
        return Int(node.name!)!
    }
    
    func getMoveAction(alien: SCNNode, to city: SCNVector3, speed: Int) -> SCNAction{
        let action =  SCNAction.move(to: city, duration: 30.0/Double(speed))
        return action
    }
    
    func creatAlienBullet() -> SCNNode{
        
        let sphere = SCNSphere(radius: 0.01)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
        
        return sphereNode
    }
    
    func bulletMovement(alienBullet: SCNNode, targetCoordinates: SCNVector3) -> SCNAction{
        let action = SCNAction.move(to: targetCoordinates, duration: 30.0/Double(8))
        return action
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
        return spawnObject(asset: "art.scnassets/diving_alien_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienShooter(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/basic_alien_shooting_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienMultiTakedown(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/multi_takedown_alien_ship.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienBoss(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_boss_ship.dae", scale: 0.2, id: id, x: x, y: y, z: z)
    }
    
    func spawnCity(id: Int = -1, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/City.dae", scale: 0.01, id: id, x: x, y: y, z: z)
        //return spawnObject(asset: "art.scnassets/alien_boss_ship.dae", scale: 0.2, id: id, x: x, y: y, z: z)
    }
    
    func spawnPickup(id: Int = 0, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/health_pickup.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
}
