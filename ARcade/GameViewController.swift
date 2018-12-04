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
        case waitingForCity
        case waitingForPeers
        case gameStarted
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var shareWorldButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var playerHealthBar: UIProgressView!
    
    
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
        if networkManager.isHost {
            configuration.planeDetection = .horizontal
        }
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
        if state == .cityPlaced {
            gridNode?.removeFromParentNode()
            state = .waitingForPeers
            cancelButton.isHidden = true
            saveButton.isHidden = true
            shareWorldButton.isHidden = false
            networkManager.startAdvertising()
        }
    }
    
    @IBAction func shareWorld(_ sender: UIButton) {
        networkManager.stopAdvertising()
        guard let currentFrame = sceneView.session.currentFrame else {return}
        switch currentFrame.worldMappingStatus {
        case .notAvailable, .limited:
            print("ARCADE-ERROR: World mapping status insufficient.")
        case .extending, .mapped:
            shareWorldButton.isEnabled = true
            sceneView.session.getCurrentWorldMap { worldMap, error in
                guard let map = worldMap
                    else { print("ARCADE-ERROR: No worldMap found. Unable to create beginningScene."); return}
                guard let cityAnchor = self.cityAnchor
                    else { print("ARCADE-ERROR: No cityAnchor found. Unable to create beginningScene."); return}
                self.beginningScene = ScenePeerInitialization(worldMap: map, cityAnchor: cityAnchor, hostID: self.networkManager.session.myPeerID)
                if let sceneToSend = self.beginningScene {
                    self.networkManager.send(object: sceneToSend)
                } else {
                    print("ARCADE-ERROR: No beginningScene available found to send to peers.")
                }
            }
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
    
    
    @IBAction func unwindToMainMenu() {}
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //if session state is looking for plane
        if networkManager.isHost{
            if state == .lookingForPlane {
                print("ARCADE-INFO: Looking for plane.")
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    state = .cityPlaced
                    cityAnchor = ARAnchor(name: "city", transform: anchor.transform)
                    sceneView.session.add(anchor: cityAnchor!)
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
        else {
            print("ARCADE-INFO: I am getting called so that's cool")
            if let name = anchor.name, name.hasPrefix("city") {
                let cityScene = SCNScene(named: "art.scnassets/City.dae")
                let cityNode = SCNNode()
                for childNode in (cityScene?.rootNode.childNodes)! {
                    cityNode.addChildNode(childNode)
                }
                cityNode.scale = SCNVector3(0.03, 0.03, 0.03)
                //cityNode.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
                cityNode.name = "-1"
                node.addChildNode(cityNode)
                manager.sceneManager.setSceneNode(node: node)
            }
        }
    }
    
    /*
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !networkManager.isHost else {return nil}
        let node = manager.sceneManager.spawnCity(x: anchor.transform.columns.3.x,
                                                  y: anchor.transform.columns.3.y,
                                                  z: anchor.transform.columns.3.z)
        print("ARCADE-INFO: Node created.")
        return node
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameButton.isHidden = true
        shareWorldButton.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
        if networkManager.isHost {
            state = .lookingForPlane
        }
        else {
            state = .waitingForCity
        }
        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.scene = scene
        playerHealthBar.setProgress(100, animated: false)
        configureSession()
        manager = GameManager(scene: scene, netManager: networkManager)
        manager.sceneViewDelegate = self
        networkManager.gameManagerDelegate = manager
        networkManager.sceneManagerDelegate = manager.sceneManager
        if networkManager.isHost{
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        }
        else{
            manager.sceneManager.setSceneNode(node: sceneView.scene.rootNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkManager.session.disconnect()
    }
    
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
