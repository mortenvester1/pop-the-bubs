//
//  GameViewController.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 12/21/20.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        
        skView.presentScene(scene)

      }
      
      override var prefersStatusBarHidden: Bool {
        return true
      }
    

}
