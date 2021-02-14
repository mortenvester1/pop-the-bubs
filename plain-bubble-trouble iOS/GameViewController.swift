//
//  GameViewController.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 12/21/20.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var highScoreLabel:UILabel?
    @IBOutlet weak var comboLabel:UILabel?
    @IBOutlet weak var levelLabel:UILabel?
    @IBOutlet weak var restartGameButton:UIButton?
    @IBOutlet weak var resetHighScoreButton:UIButton?
    @IBOutlet weak var gameBoard:UIView?

    
    var combo = 0
    var level = 1
    var score = 0
    var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    @IBAction func scoreChanged(_ sender: Any) {
        scoreLabel!.text = "score: \(score)"
    }
    @IBAction func highScoreChanged(_ sender: Any) {
        highScoreLabel!.text = "highscore: \(highScore)"
    }
    @IBAction func comboChanged(_ sender: Any) {
        comboLabel!.text = "combo: \(combo)"
    }
    @IBAction func levelChanged(_ sender: Any) {
        levelLabel!.text = "level: \(level)"
    }
    
    @IBAction func handleResetHighScore(_ sender: Any) {
        print("[GameViewController] handleResetHighScore")
        self.scene.resetHighscore()
    }
    @IBAction func handleRestartGame(_ sender: Any) {
        print("[GameViewController] handleRestartGame")
        self.scene.restartGame()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding tap as gesture to recognize
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        
        // Add button handlers
        resetHighScoreButton!.addTarget(self, action: #selector(handleResetHighScore), for: .touchUpInside)
        restartGameButton!.addTarget(self, action: #selector(handleRestartGame), for: .touchUpInside)
        
        // create gamescene from gameBoard
        self.scene = GameScene(frame: gameBoard!.frame, rows: 10, cols: 10)
        scene.name = "gameboard"
        scene.backgroundColor = UIColor.clear
        
        // cast as SKView
        let skView = gameBoard! as! SKView
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        
        // set reference and init labels
        scene.viewController = self
        highScoreChanged(self)
        scoreChanged(self)
        comboChanged(self)
        levelChanged(self)
      }
      
      override var prefersStatusBarHidden: Bool {
        return true
      }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        print("[GameViewController] tapHandler")
        if gesture.state == .began{
            //
        } else if gesture.state == .ended {
            //
        }
    }
}
