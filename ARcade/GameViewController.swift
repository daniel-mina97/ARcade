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
    
    enum SessionState{
        case lookingForPlane
        case cityPlaced
        case waitingForPeers
        case gameStarted
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var shareWorldButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var PlayerHealyBar: UIProgressView!
    
    var manager: GameManager!
    var networkManager: NetworkManager!
    var baseNode: SCNNode?
    var gridNode: SCNNode?
    var cityNode: SCNNode?
    var cityAnchor: ARAnchor?
    var beginningScene: ScenePeerInitialization?
    var state: SessionState = .lookingForPlane
    
    func configureSession(){
        let configuration = ARWorldTrackingConfiguration()
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        //do state checking here
        sceneView.session.run(configuration)
    }
    
    @IBAction func cancelCityPlane(_ sender: UIButton) {
        if let oldGridNode = gridNode {
            oldGridNode.removeFromParentNode()
        }
        if let oldCityNode = cityNode {
            oldCityNode.removeFromParentNode()
        }
        if let oldBaseNode = baseNode {
            oldBaseNode.removeFromParentNode()
        }
        
        saveButton.isHidden = true
        cancelButton.isHidden = true
        
        state = .lookingForPlane
    }
    
    @IBAction func saveCityPlane(_ sender: UIButton) {
        //sessionstate is startup game
        if state == .cityPlaced {
            gridNode?.removeFromParentNode()
            state = .waitingForPeers
            cancelButton.isHidden = true
            saveButton.isHidden = true
            shareWorldButton.isHidden = false
            
            if let cityAnchor = cityAnchor {
                beginningScene = ScenePeerInitialization(cityAnchor: cityAnchor, planeNode: baseNode!)
            } else {
                print("ERROR: Unable to construct beginning scene package. No cityAnchor found.")
            }
        }
    }
    
    @IBAction func shareWorld(_ sender: UIButton) {
        if let sceneToSend = beginningScene {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: sceneToSend, requiringSecureCoding: false) else {
                print("ERROR: Unable to encode beginningScene.")
                return
            }
            do {
                try networkManager.session.send(data, toPeers: networkManager.session.connectedPeers, with: .reliable)
                print("INFO: Sent beginningScene to peers successfully.")
            } catch {
                print("ERROR: \(error)")
            }
        } else {
            print("ERROR: No beginningScene available found to send to peers")
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        state = .gameStarted
        startGameButton.isHidden = true
        manager.startGame(cityNode: cityNode!)
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer){
        if manager.sessionState == .ended{
            self.performSegue(withIdentifier: "returnToMainMenu", sender: self)
        }
        if manager.sessionState != .ongoing {
            return
        }
        let location = sender.location(in: sceneView)
        let result = sceneView.hitTest(location, options: nil)

        if ((result.first?.node.name) != nil){ //if tapped alien
            if let node = result.first?.node{
                var nodeTapped = node
                while(nodeTapped.parent?.parent?.parent != nil){
                    nodeTapped = nodeTapped.parent!
                }
                manager.nodeTapped(node: nodeTapped)
            }
        }
    }
    
    @IBAction func unwindToMainMenu() {
        /*networkManager = NetworkManager(host: true)
        // Set the scene to the view
        sceneView.scene = scene
        configureSession()
        manager = GameManager(host: networkManager.isHost, scene: scene, id: networkManager.playerID)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]*/
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //if session state is looking for plane
        if state == .lookingForPlane {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                state = .cityPlaced
                cityAnchor = anchor
                DispatchQueue.main.async{
                    self.cancelButton.isHidden = false
                    self.saveButton.isHidden = false
                }
                
                let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
                let planeNode = SCNNode()
                
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
                planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                
                let gridMaterial = SCNMaterial()
                gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
                plane.materials = [gridMaterial]
                planeNode.geometry = plane
                sceneView.scene.rootNode.addChildNode(node)
                node.addChildNode(planeNode)
                baseNode = node
                gridNode = planeNode
                cityNode = manager.spawnCity(x: planeNode.position.x, y: planeNode.position.y, z: planeNode.position.z)
                node.addChildNode(cityNode!)
                manager.sceneManager.setSceneNode(node: node)
            } else {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create classes
        startGameButton.isHidden = true
        shareWorldButton.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
        state = .lookingForPlane
        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.scene = scene
        configureSession()
        manager = GameManager(host: networkManager.isHost, scene: scene, SceneView: sceneView,  id: networkManager.playerID)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        if networkManager.isHost {
            networkManager.startHosting()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // the player health progress bar 
        PlayerHealyBar.setProgress(100, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
