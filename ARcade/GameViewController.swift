//
//  ViewController.swift
//  ARcade
//
//  Created by Daniel Mina on 9/19/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class GameViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        sceneView.scene.rootNode.addChildNode(addShip(x: 0.0, y: 0.0, z: -0.5))
        
        sceneView.scene.rootNode.addChildNode(addShip(x: 0.0, y: 0.0, z: -0.1))
        
        sceneView.scene.rootNode.addChildNode(addShip(x: 0.2, y: 0.0, z: -0.5))
        
        sceneView.scene.rootNode.addChildNode(addShip(x: -0.2, y: 0.0, z: -0.1))
        
        sceneView.scene.rootNode.addChildNode(addShip(x: -0.2, y: 0.0, z: -0.5))
        
        sceneView.scene.rootNode.addChildNode(addShip(x: 0.2, y: 0.0, z: -0.1))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if alien tapped, send shoot action
        //if pickup tapped, send pickup action
        //if user is shielding, do shield stuff
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
