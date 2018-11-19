//
//  ARSceneManager.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 11/17/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

enum startupState{
    case lookingForPlane
    case placingCity
}

class ARSceneManager : NSObject, ARSCNViewDelegate{
    
    var sceneView:ARSCNView!
    var configuration:ARWorldTrackingConfiguration = ARWorldTrackingConfiguration()
    
    init(view: ARSCNView){
        sceneView = view
    }
    
    func setupSession(){
        setDelegate()
        
    }
    
    func setDelegate(){
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    func configureSession(manager: GAmeManager){
        switch GameManager.sesstionState{
        case .startup:
            
        case .ongoing:
            <#code#>
        case .joining:
            <#code#>
        case .ending:
            <#code#>
        case .ended:
            <#code#>
        }
        
    }
    
    func runSession(){
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func pauseSession(){
        // Pause the view's session
        sceneView.session.pause()
    }

}
