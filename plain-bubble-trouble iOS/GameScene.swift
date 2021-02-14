//
//  GameScene.swift
//  plain-bubble-trouble Shared
//
//  Created by Morten Pedersen on 12/21/20.
//

import SpriteKit

class GameScene: SKScene {
    weak var viewController: GameViewController!
    let rows, cols: Int
    let cellSize, elementSize: CGFloat
    var grid: Grid
    
    
    init(frame: CGRect, rows:Int, cols:Int) {
        print(frame)
        self.rows = rows
        self.cols = cols
        self.cellSize = frame.size.width / CGFloat(rows+1)
        self.elementSize = self.cellSize * CGFloat(5.0/6.0)
        
        self.grid = Grid(minX: frame.minX, minY: frame.minY, cellSize:cellSize, elementSize:elementSize, rows:rows, cols:cols)!

        super.init(size: frame.size)
    }
    
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    var difficulity: Double = 0.4
    
    // Setting the score node and logfic for updating
    var score = 0
    func updateScore(size: Int) {
        score += size
        viewController.score = score
        viewController.scoreChanged(self)
    }
    func resetScore() {
        score = 0
        viewController.score = score
        viewController.scoreChanged(self)
    }

    var highscore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    func updateHighscore() {
        if score > highscore {
            highscore = score
            UserDefaults.standard.setValue(score, forKey: "HIGHSCORE")
            viewController.highScore = highscore
            viewController.highScoreChanged(self)
        }
        
    }
    func resetHighscore() {
        highscore = 0
        UserDefaults.standard.setValue(0, forKey: "HIGHSCORE")
        viewController.highScore = highscore
        viewController.highScoreChanged(self)
    }

    var level = 1
    func updateLevel() {
        level += 1
        viewController.level = level
        viewController.levelChanged(self)
    }
    func resetLevel() {
        level = 1
        viewController.level = level
        viewController.levelChanged(self)
    }

    var combo = 0
    func updateCombo(size: Int) {
        combo = size
        viewController.combo = combo
        viewController.comboChanged(self)
    }
    func resetCombo() {
        combo = 0
        viewController.combo = combo
        viewController.comboChanged(self)
    }
    
    func removeGameOver() {
        print("[gamescene] removeGameOver")
        childNode(withName: "gameover")?.removeFromParent()
    }
    
    func gameOver() {
        print("[gamescene] gameOver")
        // remove all bubbles
        self.grid.removeAllElements(scene: self)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: Double(size.width) * 0.5, y: Double(size.height) * 0.4)
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontSize = 36
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameOverLabel.name = "gameover"

        addChild(gameOverLabel)
    }
    
    func restartGame() {
        print("[gamescene] restart game tapped")
        self.grid.removeAllElements(scene: self)
        resetScore()
        resetLevel()
        resetCombo()
        removeGameOver()
        self.grid.fillGrid(level: level, scene: self)
        self.grid.levelIsOver = false
        self.grid.gameIsOver = false
    }
    
    override func didMove(to view: SKView) {
        // Initalize the scene
        //backgroundColor = SKColor.white
        print("[gamescene] didMove \(self)")
        self.grid.fillGrid(level: level, scene: self)
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        // updates to happen for each frame, e.g. animate background
        // ignore for now
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // regonizes then fingers moves -> do nothing
        // keep func inplace for instructional purposes
        print("[gamescene] TouchesMoved")
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
        //print("[gamescene] TouchesBegan \(self.children)")
        guard let touch: UITouch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let node : SKNode = self.atPoint(location)
        let name : String = node.name ?? ""

        print("[gamescene] TouchesBegan node.name \(name)")
        if name.starts(with: "element") {
            // cast as element preserving attrs
            let element = node as! SKSpriteNode as! Element
            // combo, score, actoin
            let (comboRound, scoreRound, actionToRun) = self.grid.playRound(element: element, level: level, scene: self)
            
            // nothing was popped
            if comboRound==0{
                return
            }
            
            let finalizeRoundAction = SKAction.run({
                self.updateCombo(size: comboRound)
                self.updateScore(size: scoreRound)
                self.updateHighscore()

                if self.grid.gameIsOver==true {
                    self.gameOver()
                    print("[gamescene] TouchesBegan game over")
                }
                if self.grid.levelIsOver==true {
                    self.updateLevel()
                    self.grid.levelIsOver = false
                    print("[gamescene] TouchesBegan level over")
                }
            })
                
            // after action is done -> the board has been filled if required
            run(SKAction.sequence([actionToRun, self.grid.waitAction, finalizeRoundAction]), completion: { print("[gamescene] TouchesBegan round over") })
        } else {
            print("[gamescene] TouchesBegan nothing tapped")
        }

    }

}


