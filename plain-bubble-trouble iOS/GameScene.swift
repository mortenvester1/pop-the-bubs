//
//  GameScene.swift
//  plain-bubble-trouble Shared
//
//  Created by Morten Pedersen on 12/21/20.
//

import SpriteKit

class GameScene: SKScene {

    let grid = Grid(cellSize:CGFloat(30.0), elementSize:CGFloat(25.0), rows:10, cols:10)!
    var difficulity: Double = 0.4
    var scoreLabel: SKLabelNode!
    
    // Setting the score node and logfic for updating
    var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }
    func initScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "score: \(score)"
        scoreLabel.position = CGPoint(x: 35, y: 265.0)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontSize = 16
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.name = "score"
        addChild(scoreLabel)
    }
    func updateScore(size: Int) {
        score += size
    }
    func resetScore() {
        score = 0
    }
    
    var highscoreLabel: SKLabelNode!
    var highscore = UserDefaults.standard.integer(forKey: "HIGHSCORE") {
        didSet {
            highscoreLabel.text = "reset highscore: \(highscore)"
        }
    }
    func updateHighscore() {
            if score > highscore {
                highscore = score
                UserDefaults.standard.setValue(score, forKey: "HIGHSCORE")
            }
        }
    func initResetHighscoreButton(){
        highscoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highscoreLabel.text = "reset highscore: \(highscore)"
        
        highscoreLabel.position = CGPoint(x: 35.0, y: 205.0)
        highscoreLabel.fontColor = SKColor.black
        highscoreLabel.fontSize = 16
        highscoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highscoreLabel.name = "reset"
        addChild(highscoreLabel)
    }
    func resetHighscore() {
        highscore = 0
        UserDefaults.standard.setValue(0, forKey: "HIGHSCORE")
    }
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "level: \(level)"
        }
    }
    func updateLevel() {
        level += 1
    }
    func initLevelLabel(){
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "level: \(level)"
        levelLabel.position = CGPoint(x: 335.0, y: 265.0)
        levelLabel.fontColor = SKColor.black
        levelLabel.fontSize = 16
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        levelLabel.name = "level"
        addChild(levelLabel)
    }
    func resetLevel() {
        level = 1
    }
    
    var comboLabel: SKLabelNode!
    var combo = 0 {
        didSet {
            comboLabel.text = "combo: \(combo)"
        }
    }
    func updateCombo(size: Int) {
        combo = size
    }
    func initComboLabel(){
        comboLabel = SKLabelNode(fontNamed: "Chalkduster")
        comboLabel.text = "combo: \(combo)"
        comboLabel.position = CGPoint(x: 335.0, y: 235.0)
        comboLabel.fontColor = SKColor.black
        comboLabel.fontSize = 16
        comboLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        comboLabel.name = "combo"
        addChild(comboLabel)
    }
    func resetCombo() {
        combo = 0
    }
    
    
    func initRestartGameButton(){
        let restartGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartGameLabel.text = "restart game"
        restartGameLabel.position = CGPoint(x: 35.0, y: 235.0)
        restartGameLabel.fontColor = SKColor.black
        restartGameLabel.fontSize = 16
        restartGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        restartGameLabel.name = "restart"
        addChild(restartGameLabel)
    }
    
    func gameOver() {
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: Double(size.width) * 0.5, y: Double(size.height) * 0.6)
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontSize = 32
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameOverLabel.name = "gameover"
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
    }
        
    func removeGameOver() {
        childNode(withName: "gameover")?.removeFromParent()
    }
    
    
    override func didMove(to view: SKView) {
        // Initalize the scene
        backgroundColor = SKColor.white
        initScoreLabel()
        initLevelLabel()
        initComboLabel()
        
        initResetHighscoreButton()
        initRestartGameButton()
        
        grid.fillGrid(level: level, scene: self)
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        // updates to happen for each frame, e.g. animate background
        // ignore for now
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // regonizes then fingers moves -> do nothing
        // keep func inplace for instructional purposes
        for _ in touches {
            //print("moved \(location)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // activate after movement ends -> do nothing
        // keep func inplace for instructional purposes
        print("[gamescene] TouchesEnded")
        for _ in touches {
            //print("ended \(location)")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // recognizes taps - > do stuff
        print("[gamescene] TouchesBegan")
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            let name : String = node.name ?? ""

            if name.starts(with: "element") {
                // cast as element preserving attrs
                let element = node as! SKSpriteNode as! Element
                // combo, score, actoin
                let (comboRound, scoreRound, actionToRun) = grid.playRound(element: element, level: level, scene: self)
                
                // nothing was popped
                if comboRound==0{
                    break
                }
                
                let finalizeRoundAction = SKAction.run({
                    self.updateCombo(size: comboRound)
                    self.updateScore(size: scoreRound)
                    self.updateHighscore()

                    if self.grid.gameIsOver==true {
                        self.gameOver()
                        print("[gamescene] game over")
                    }
                    if self.grid.levelIsOver==true {
                        self.updateLevel()
                        self.grid.levelIsOver = false
                        print("[gamescene] round over")
                    }
                })
                
                // after action is done -> the board has been filled if required
                run(SKAction.sequence([actionToRun, grid.waitAction, finalizeRoundAction]), completion: { print("round over") })



            } else if name == "restart" {
                print("[gamescene] restart game tapped")
                grid.removeAllElements(scene: self)
                resetScore()
                resetLevel()
                resetCombo()
                removeGameOver()
                grid.fillGrid(level: level, scene: self)
                grid.levelIsOver = false
                grid.gameIsOver = false
                
            } else if name == "reset" {
                print("[gamescene] reset highscore tapped")
                resetHighscore()
            } else {
                print("[gamescene] nothing tapped")
            }
        }

    }

}


