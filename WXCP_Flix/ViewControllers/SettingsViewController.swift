//
//  SettingsViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let choice = defaults.string(forKey: "imagePositioning") ?? "left"
        segControl.selectedSegmentIndex = 0
        if (choice.isEqual("right")) {
            segControl.selectedSegmentIndex = 1
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        let choices = ["left", "right"]
        let choice = choices[segControl.selectedSegmentIndex]
        defaults.set(choice, forKey: "imagePositioning")
        defaults.synchronize()
    }
    
}
