//
//  GameViewController.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 12/21/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var levelLabel:UILabel?
    @IBOutlet weak var comboLabel:UILabel?
    @IBOutlet weak var highScoreLabel:UILabel?
    @IBOutlet weak var resetHighScoreButton:UIButton?
    @IBOutlet weak var resetGameButton:UIButton?
    
    var score = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        updateHighScoreLabel()
        updateLevelLabel()
        updateComboLabel()
    }
    
    func updateScoreLabel(){
        //scoreLabel = Score.compute()
    }
    
    func updateHighScoreLabel(){
        
    }
    
    func updateLevelLabel(){
    
    }
    
    func updateComboLabel(){
        
    }
    

}
