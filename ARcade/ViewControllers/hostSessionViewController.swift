//
//  hostSessionViewController.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 10/4/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import MultipeerConnectivity

class hostSessionViewController: UIViewController, UITextFieldDelegate {
    
    var netManager: NetworkManager?
    
    @IBOutlet weak var SessionName: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SessionName.resignFirstResponder()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toGame"){
            let dst = segue.destination as! GameViewController
            netManager = NetworkManager(host: true, displayName: SessionName.text!)
            dst.networkManager = netManager
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SessionName.delegate = self
        SessionName.text = (UserDefaults.standard.object(forKey: "name") as! String)
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
