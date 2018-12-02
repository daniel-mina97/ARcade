//
//  hostSessionViewController.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 10/4/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import MultipeerConnectivity

class hostSessionViewController: UIViewController {
    
    var netManager: NetworkManager?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toGame"){
            let dst = segue.destination as! GameViewController
            dst.networkManager = netManager
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        netManager = NetworkManager(host: true, displayName: UserDefaults.standard.object(forKey: "name") as! String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
