//
//  SceneManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/17/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import SceneKit



class SKSceneManager {
    
    var scene: SCNScene
    var cityPlaced: Bool = false
    
    init(scene: SCNScene){
        self.scene = scene
    }
    
    func addShips(){
        scene.rootNode.addChildNode(addShip(x: 0.0, y: 0.0, z: -0.5))
        
        scene.rootNode.addChildNode(addShip(x: 0.0, y: 0.0, z: -0.1))
        
        scene.rootNode.addChildNode(addShip(x: 0.2, y: 0.0, z: -0.5))
        
        scene.rootNode.addChildNode(addShip(x: -0.2, y: 0.0, z: -0.1))
        
        scene.rootNode.addChildNode(addShip(x: -0.2, y: 0.0, z: -0.5))
        
        scene.rootNode.addChildNode(addShip(x: 0.2, y: 0.0, z: -0.1))
    }
    
    func addShip(x: Float, y: Float ,z: Float) -> SCNNode{
        let scene = SCNScene(named: "art.scnassets/alien ship.dae")!
        let shipNode = SCNNode()
        let sceneChildNodes = scene.rootNode.childNodes
        for childNode in sceneChildNodes{
            shipNode.addChildNode(childNode)
        }
        shipNode.position = SCNVector3(x: x, y: y, z: z)
        shipNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        return shipNode
    }
    
    func addAlien(at coord: Coordinate3D) -> SCNNode{
        let scene = SCNScene(named: "art.scnassets/alien ship.dae")!
        let shipNode = SCNNode()
        let sceneChildNodes = scene.rootNode.childNodes
        for childNode in sceneChildNodes{
            shipNode.addChildNode(childNode)
        }
        shipNode.position = coord.getVector()
        shipNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        return shipNode
    }
}
