//
//  Draw.swift
//  Screebe
//
//  Created by Owen on 15.09.18.
//  Copyright © 2018 daven. All rights reserved.
//

import Foundation
import UIKit

class Draw: UIViewController {
    private var Flows: [Flow] = []
    private var currentFlow: Flow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentFlow == nil {
            currentFlow = Flow(frame: CGRect(x: 0, y: 0, width: 500, height: 500), startTouch: touches.first!)
            Flows.append(currentFlow!)
            self.view.addSubview(currentFlow!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentFlow != nil {
            currentFlow!.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentFlow != nil {
            currentFlow!.touchesEnded(touches, with: event)
        }
        currentFlow = nil
    }
}
