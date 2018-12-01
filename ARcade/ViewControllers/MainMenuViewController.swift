//
//  MainMenuViewController.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 10/15/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainMenuViewController: UIViewController {
    
    var netManager: NetworkManager?
    
    func initializeUserDefaults () {
        if UserDefaults.standard.object(forKey: "name") == nil{
            UserDefaults.standard.set("Player", forKey: "name")
            UserDefaults.standard.set(1, forKey: "color")
            UserDefaults.standard.set(1, forKey: "ship")
        }
    }
    
    @IBAction func returnFromSettings(Destination segue: UIStoryboardSegue){
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserDefaults()
        // Do any additional setup after loading the view.
    }
}

extension MainMenuViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("You were declined noob")
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("You were accepted")
        
        let gvc = GameViewController()
        
        gvc.networkManager = netManager
        
        self.present(gvc, animated: true, completion: nil)
        
    }
}
