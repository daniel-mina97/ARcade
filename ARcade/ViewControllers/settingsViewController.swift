//
//  settingsViewController.swift
//  ARcade
//
//  Created by Webb, Christopher Jacob on 10/4/18.
//  Copyright © 2018 University of Houston-Clear lake (ARGuys). All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var colorSelect: UISegmentedControl!
    @IBOutlet weak var shipSelect: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    @IBAction func saveSettings(_ sender: Any) {
        defaults.set(nameField.text!, forKey: "name")
        defaults.set(colorSelect.selectedSegmentIndex, forKey: "color")
        defaults.set(shipSelect.selectedSegmentIndex, forKey: "ship")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        nameField.text = (defaults.object(forKey: "name") as! String)
        colorSelect.selectedSegmentIndex = defaults.integer(forKey: "color")
        shipSelect.selectedSegmentIndex = defaults.integer(forKey: "ship")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
