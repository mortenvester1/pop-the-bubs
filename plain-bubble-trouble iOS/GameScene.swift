//
//  GameScene.swift
//  plain-bubble-trouble Shared
//
//  Created by Morten Pedersen on 12/21/20.
//

import SpriteKit

class GameScene: SKScene {

    let xSize: Int = 10
    let ySize: Int = 10
    var cycle: Int = 1
    var points: Array<Int> = []
    var sumpoints: Array<Int> = [0]
    var difficulity: Double = 0.4
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }
    
    var highscoreLabel: SKLabelNode!
    var highscore = UserDefaults.standard.integer(forKey: "HIGHSCORE") {
        didSet {
            highscoreLabel.text = "reset highscore: \(highscore)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "level: \(level)"
        }
    }
    
    var comboLabel: SKLabelNode!
    var combo = 0 {
        didSet {
            comboLabel.text = "combo: \(combo)"
        }
    }
    
    // starting function?
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        initScoreLabel()
        initLevelLabel()
        initComboLabel()
        
        initResetHighscoreButton()
        initRestartGameButton()
        
        initGrid()
    }
    

    func initGrid() {
        let xBoundary: Double = Double(size.width) * 0.1
        let yBoundary: Double = Double(size.height) * 0.4
        let cellWidth: Double = Double(size.width) * 0.8 / Double(xSize)
        let cellHeight: Double = Double(size.height) * 0.5 / Double(ySize)
        
        for i in 1...xSize {
            for j in 1...ySize {
                let x = xBoundary + Double(i) * cellWidth
                let y = yBoundary + Double(j) * cellHeight
                let bubble = Bubble(nLabels: getNumberOfLabels(), x: x, y: y, i: i, j: j, level: level, difficulty: difficulity)
                addChild(bubble)
            }
        }
    }
    
    func initScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "score: \(score)"
        scoreLabel.position = CGPoint(x: Double(size.width) * 0.1, y: Double(size.height) * 0.4)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontSize = 16
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.name = "score"
        addChild(scoreLabel)
    }
    
    func initLevelLabel(){
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "level: \(level)"
        levelLabel.position = CGPoint(x: Double(size.width) * 0.5, y: Double(size.height) * 0.4)
        levelLabel.fontColor = SKColor.black
        levelLabel.fontSize = 16
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelLabel.name = "level"
        addChild(levelLabel)
    }
    
    func initComboLabel(){
        comboLabel = SKLabelNode(fontNamed: "Chalkduster")
        comboLabel.text = "combo: \(combo)"
        comboLabel.position = CGPoint(x: Double(size.width) * 0.7, y: Double(size.height) * 0.4)
        comboLabel.fontColor = SKColor.green
        comboLabel.fontSize = 16
        comboLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        comboLabel.name = "combo"
        addChild(comboLabel)
    }
    
    func initResetHighscoreButton(){
        highscoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highscoreLabel.text = "reset highscore: \(highscore)"
        
        highscoreLabel.position = CGPoint(x: Double(size.width) * 0.1, y: Double(size.height) * 0.3)
        highscoreLabel.fontColor = SKColor.black
        highscoreLabel.fontSize = 16
        highscoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highscoreLabel.name = "reset"
        addChild(highscoreLabel)
    }
    
    func initRestartGameButton(){
        let restartGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartGameLabel.text = "restart game"
        restartGameLabel.position = CGPoint(x: Double(size.width) * 0.1, y: Double(size.height) * 0.2)
        restartGameLabel.fontColor = SKColor.black
        restartGameLabel.fontSize = 16
        restartGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        restartGameLabel.name = "restart"
        addChild(restartGameLabel)
    }
        
    func getNumberOfLabels() -> Int {
        switch self.level {
        case 1...5:
            return 4
        case 6...10:
            return 5
        default:
            return 6
        }
    }
    
    func getDifficulty() -> Double {
        switch self.level {
        case 1...5:
            return 0.6
        case 6...10:
            return 0.7
        default:
            return 0.8
        }
    }
    
    func updateScore(size: Int) {
        score += size
    }
    
    func resetScore() {
        self.score = 0
    }
    
    func updateHighscore(size: Int) {
        if score > highscore {
            highscore = score
            UserDefaults.standard.setValue(score, forKey: "HIGHSCORE")
        }
    }
    
    func resetHighscore() {
        self.highscore = 0
        UserDefaults.standard.setValue(0, forKey: "HIGHSCORE")
    }
    
    func updateCombo(size: Int) {
        combo = size
    }
    
    func resetCombo() {
        self.combo = 0
    }
    
    func updateLevel(size: Int) {
        level += size
    }

    func resetLevel() {
        self.level = 1
    }

    func regexFindAll(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func nameToLabelAndCoordinates(name: String) -> (Int, Int, Int) {
        let matched = regexFindAll(for: "[0-9]+", in: name).map { Int($0) ?? -1 }
        return (matched[0], matched[1], matched[2])
    }
    
    func findNeighBours(label: Int, x: Int, y: Int, neighboursInput: [String]) -> Array<String> {
        var neighbours = neighboursInput
        let key = "\(x),\(y)"
        
        // check if key already exists
        if neighbours.contains(key) {
            return neighbours
        }
        
        // check neightbours it node is not nil
        let nodes = filterBubblesByRowAndColumnIndex(rowIndex: x, columnIndex: y)
        if nodes.count < 1 {
            return neighbours
        }
        if let name = nodes[0].name {
            let (label2, _, _) = nameToLabelAndCoordinates(name: name)
            if label2 == label && !neighbours.contains(key) {
                neighbours.append(key)
                neighbours = findNeighBours(label: label, x: x-1, y:y, neighboursInput: neighbours)
                neighbours = findNeighBours(label: label, x: x+1, y:y, neighboursInput: neighbours)
                neighbours = findNeighBours(label: label, x: x, y:y-1, neighboursInput: neighbours)
                neighbours = findNeighBours(label: label, x: x, y:y+1, neighboursInput: neighbours)
            }
        }
        // no neighbour exists
        else {
            return neighbours
        }

        return neighbours
    }
    
    func moveNodeDown(node: SKNode, yDisplacement: CGFloat) {
        let move = SKAction.moveBy(x: 0.0, y: yDisplacement, duration: 0.2)
        node.run(move)
    }
    
    func filterBubblesByRowAndColumnIndex(rowIndex: Int ,columnIndex: Int) -> Array<SKNode> {
        return self.children.filter({ ($0.name ?? "").matches("bubble\\[\\d+,\(rowIndex),\(columnIndex)\\]")})
    }
    
    func filterBubblesByColumnIndex(columnIndex: Int) -> Array<SKNode> {
        return self.children.filter({ ($0.name ?? "").matches("bubble\\[\\d+,\\d+,\(columnIndex)\\]")})
    }
    
    func checkAnyMovesLeft() -> Bool {
        
        for i in 1...xSize {
            for j in 1...ySize {
                
                // Find Node if none continue
                let node = filterBubblesByRowAndColumnIndex(rowIndex: i, columnIndex: j)
                if node.count==0 {
                    continue
                }
                
                // extract label and find neighbours
                let (label, _, _) = nameToLabelAndCoordinates(name: node[0].name ?? "")
                let neighbours = findNeighBours(label: label, x: i, y: j, neighboursInput: [])
                
                // more than 2 neighbours
                if neighbours.count > 2 {
                    return true
                }
            }
        }
        return false
    }
    
    
    func moveColumnsDown() {
        let bottom = Double(size.height) * 0.4
        let cellHeight = Double(size.height) * 0.5 / Double(ySize)
        
        for columnIndex in 1...ySize {
            let column = filterBubblesByColumnIndex(columnIndex: columnIndex).sorted(by: { $0.position.y < $1.position.y })
            var distanceToMove: Double = 0.0
            if column.count < 1 {
                continue
            }
            for j in 0...column.count - 1 {
                
                if j == 0 {
                    distanceToMove += (Double(column[j].position.y) - bottom - cellHeight)
                }
                else {
                    distanceToMove += (Double(column[j].position.y) - Double(column[j-1].position.y) - cellHeight)
                }
                
                // move node
                if distanceToMove > 1.0 {
                    print("before: ", column[j].name ?? "")
                    moveNodeDown(node: column[j], yDisplacement: -CGFloat(distanceToMove) )
                    let (label, xIndex, _) = nameToLabelAndCoordinates(name: column[j].name ?? "")
                    let newRowIndex = Int( (Double(xIndex) - (distanceToMove / cellHeight)).rounded() )
                    column[j].name = "bubble[\(label),\(newRowIndex),\(columnIndex)]"
                    print("after: ", column[j].name ?? "")
                    
                }
                
                
            }
            
        }
        SKAction.wait(forDuration: 0.2)
    }
    
    func fillGrid() {
        SKAction.wait(forDuration: 0.25)
        var count: Int = 0
        
        let xBoundary: Double = Double(size.width) * 0.1
        let yBoundary: Double = Double(size.height) * 0.4
        let cellWidth: Double = Double(size.width) * 0.8 / Double(xSize)
        let cellHeight: Double = Double(size.height) * 0.5 / Double(ySize)
        var bubbles: Array<Bubble> = []
        for i in 1...xSize {
            for j in 1...ySize {
                let nodes = filterBubblesByRowAndColumnIndex(rowIndex: i, columnIndex: j)
                if nodes.count > 0 {
                    print("existing node:", i, j, nodes[0].position)
                }
                if nodes.count < 1 {
                    let x = xBoundary + Double(j) * cellWidth
                    let y = yBoundary + Double(i) * cellHeight
                    print("addnode: ", i, j, x, y)
                    
                    let bubble = Bubble(nLabels: getNumberOfLabels(), x: x, y: y, i: j, j: i, level: level, difficulty: difficulity)
                    bubbles.append(bubble)
                    count += 1
                }
                
            }
        }
        //print(temp.count, temp.map({ $0.name }))
        //print(bubbles.count, bubbles.map({ $0.name }))
        if bubbles.count > 0 {
            for bubble in bubbles {
                addChild(bubble)
            }
        }
    }
    
    func gameOver() {
        self.children.filter({ ($0.name ?? "").starts(with: "bubble") }).forEach({ $0.removeFromParent() })
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: Double(size.width) * 0.5, y: Double(size.height) * 0.6)
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontSize = 24
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameOverLabel.name = "gameover"
        addChild(gameOverLabel)
    }
    
    func removeGameOver() {
        childNode(withName: "gameover")?.removeFromParent()
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            let name = node.name ?? ""
            
            if name.starts(with: "bubble") {
                print("bubble tapped")
                cycle += 1
                let (label, xIndex, yIndex) = nameToLabelAndCoordinates(name: name)
                let neighbours = findNeighBours(label: label, x: xIndex, y:yIndex, neighboursInput: []).map({ "bubble[\(label),\($0)]"})

                if neighbours.count > 2 {
                    self.children.filter({ neighbours.contains($0.name ?? "") }).forEach({ $0.removeFromParent()})
                    moveColumnsDown()
                }
            
                updateCombo(size: neighbours.count)
                updateScore(size: Int( Double(combo) * (Double(combo) - 1.0) * ( log( Double(level) ) + 1.0) / 2.0 ) )
                updateHighscore(size: 1)
                
                // verify new moves
                if !checkAnyMovesLeft() {
                    print("NO MORE MOVES LEFT")
                    SKAction.wait(forDuration: 1.0)
                    updateLevel(size: 1)
                    fillGrid()
                    
                    if !checkAnyMovesLeft(){
                        print("GAME OVER")
                        gameOver()
                    }
                }
            }
            else if name == "restart" {
                print("restart game tapped")
                self.children.filter({ ($0.name ?? "").starts(with: "bubble") }).forEach({ $0.removeFromParent() })
                resetScore()
                resetLevel()
                resetCombo()
                removeGameOver()
                initGrid()
            }
            else if name == "reset" {
                print("reset highscore tapped")
                resetHighscore()
            }
            else {
                print("nothing tapped")
            }

        }
    }
    
}

class Bubble : SKSpriteNode {
    let label, xIndex, yIndex: Int
    let xPos, yPos: Double
    let coordinates: String
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(nLabels: Int, x: Double, y: Double, i: Int, j:Int, level:Int, difficulty: Double) {
        // custom inits
        if Double.random(in: 0.0..<1.0) <= difficulty {
            label = (i + j * 2) % 4
        } else {
            label = Int( Double.random(in: 0...1) * Double(nLabels) )
        }
        
        xPos = x; yPos = y
        xIndex = i; yIndex = j
        coordinates = "\(yIndex),\(xIndex)"
        
        // SKSprintNode inits
        let texture = SKTexture(imageNamed: "bubble\(label)")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 28.0, height: 28.0))
        name = String(format: "bubble[%d,%d,%d]", label, yIndex, xIndex)
        position = CGPoint(x: xPos, y: yPos)
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
