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
        case citySaved
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //var manager: GameManager!
    var sceneManager: SceneManager!
    //var networkManager: NetworkManager!
    var cityPlaneNode: SCNNode?
    var cityAnchor: ARAnchor?
    var alienCount = 0
    var state: SessionState = .lookingForPlane
    var dummies: [Int: dummy] = [:]
    
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
        if let oldPlaneNode = cityPlaneNode {
            oldPlaneNode.removeFromParentNode()
        }
        //sessionstate is to look for plane
        state = .lookingForPlane
    }
    
    @IBAction func saveCityPlane(_ sender: UIButton) {
        //sessionstate is startup game
        state = .citySaved
        cancelButton.isHidden = true
        saveButton.isHidden = true
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: sceneView)
        let result = sceneView.hitTest(location, options: nil)
        let ARresult = sceneView.hitTest(location, types: .featurePoint)

        if ((result.first?.node.name) != nil){
            var node = result.first?.node
            while(node?.parent?.parent != nil){
                node = node?.parent
            }
            if let dummyID = Int((node?.name!)!){
                if let myDummy = dummies[dummyID]{
                    if myDummy.state == .spawned{
                        let action = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 0), duration: 20)
                        myDummy.node.runAction(action)
                        myDummy.state = .moving
                    }
                    else{
                        myDummy.node.removeFromParentNode()
                    }
                }
            }
            else{
                node?.removeFromParentNode()
            }
        }else{
            print("MADE IT HERE2")
            if let transform = ARresult.first?.worldTransform.columns.3{
                let node = sceneManager.spawnAlienShooter(id: alienCount, x: transform.x, y: transform.y, z: transform.z)
                sceneView.scene.rootNode.addChildNode(node)
                dummies[alienCount] = dummy(s: .spawned, n: node)
                alienCount += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create classes
        dummies = [:]
        state = .lookingForPlane
        let scene = SCNScene()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //networkManager = NetworkManager(host: true)
        // Set the scene to the view
        sceneView.scene = scene
        sceneManager = SceneManager(scene: scene)
        configureSession()
       // manager = GameManager(host: networkManager.isHost, scene: scene)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //if session state is looking for plane
        if state != .lookingForPlane {return}
        
        if let planeAnchor = anchor as? ARPlaneAnchor{
            
            cityAnchor = anchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
            let cNode = sceneManager?.spawnCity(id: 0, x: planeNode.position.x, y: planeNode.position.y, z: planeNode.position.z)
            node.addChildNode(cNode!)
            cityPlaneNode = node
        }else{
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

class dummy{
    enum dummyState {
        case spawned
        case moving
        case done
    }
    public var node: SCNNode
    public var state: dummyState
    
    init(s: dummyState, n: SCNNode){
        node = n
        state = s
    }
    
}
