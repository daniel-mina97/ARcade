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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let the = sender as? JoinButton{
            let dst = segue.destination as! GameViewController
            dst.networkManager = netManager
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
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
        
        self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
}
