//
//  joinSessionViewController.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 10/4/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit
import MultipeerConnectivity

class joinSessionViewController: UIViewController {
    
    var netManager: NetworkManager?
    
    @IBOutlet weak var table: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! GameViewController
        dest.networkManager = network
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        network = NetworkManager(host: false)
        
    }
    
    override func viewDidAppear(_ bool: Bool) {
        let browser = MCBrowserViewController(serviceType: (netManager?.gameServiceType)!, session: (netManager?.session)!)
        browser.delegate = self
        present(browser, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func joinSession() {
        
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

extension joinSessionViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
