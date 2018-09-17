//
//  ViewController.swift
//  Screebe
//
//  Created by Owen on 15.09.18.
//  Copyright © 2018 daven. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    private let app = App(url: "http://192.168.0.220:4000/app")
    
    @IBAction func CreateButtonClick() {
        app.createRoom(username: textUsername.text!, password: textPassword.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
