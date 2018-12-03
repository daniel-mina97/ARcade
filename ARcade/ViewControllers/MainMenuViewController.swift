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
    
    @IBOutlet weak var hostButton: CustomB!
    @IBOutlet weak var joinButton: CustomB!
    @IBOutlet weak var settingsButton: CustomB!
    
    
    func initializeUserDefaults () {
        if UserDefaults.standard.object(forKey: "name") == nil{
            UserDefaults.standard.set("Player", forKey: "name")
            UserDefaults.standard.set(1, forKey: "color")
            UserDefaults.standard.set(1, forKey: "ship")
        }
    }
    
    @IBAction func returnFromSettings(Destination segue: UIStoryboardSegue){
        
    }
    
    @IBAction func joinSession() {
        netManager = NetworkManager(host: false, displayName: UserDefaults.standard.object(forKey: "name") as! String)
        let browser = MCBrowserViewController(serviceType: (netManager?.gameServiceType)!, session: (netManager?.session)!)
        browser.delegate = self
        present(browser, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserDefaults()
        
    }
}

extension MainMenuViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("INFO: Stopped looking for advertised session.")
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("INFO: Successfully joined an advertised session.")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gvc = storyBoard.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        if let newPlayerID = netManager?.session.myPeerID.hash {
            netManager?.playerID = newPlayerID
        } else {
            print("ERROR: Unable to generate new playerID.")
        }
        gvc.networkManager = netManager
        self.present(gvc, animated: true, completion: nil)
    }
}
