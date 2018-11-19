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
    
    func spawnObject(asset: String, scale: Float, id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        let scene = SCNScene(named: asset)!
        let node = SCNNode()
        let sceneChildNodes = scene.rootNode.childNodes
        for childNode in sceneChildNodes{
            node.addChildNode(childNode)
        }
        node.position = SCNVector3(x: x, y: y, z: z)
        node.scale = SCNVector3(x: scale, y: scale, z: scale)
        node.name = String(id)
        return node
    }
    
    func spawnAlienDiver(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_diver.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienShooter(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_normal.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienMultiTakedown(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_multitakedown.dae", scale: 0.1, id: id, x: x, y: y, z: z)
    }
    
    func spawnAlienBoss(id: Int, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_boss.dae", scale: 0.2, id: id, x: x, y: y, z: z)
    }
    
    func spawnCity(id: Int = 0, x: Float, y: Float, z: Float) -> SCNNode{
        return spawnObject(asset: "art.scnassets/alien_diver.dae", scale: 0.1, id: 0, x: x, y: y, z: z)
    }
    
    func moveObject(node: SCNNode){
        
    }
    
}
