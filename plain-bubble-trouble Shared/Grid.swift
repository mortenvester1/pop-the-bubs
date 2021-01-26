//
//  Grid.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 1/5/21.
//

import Foundation
import SpriteKit

class Grid : SKSpriteNode {
    var rows:Int!
    var cols:Int!

    var cellSize:CGFloat!
    var elementSize:CGFloat!
    let viewLeftBoundary = CGFloat(35.0)
    let viewBottomBoundary = CGFloat(300.0)
    let waitAction = SKAction.wait(forDuration: 0.2)
    let nothingAction = SKAction.run({print("nothing to do")})
    var levelIsOver: Bool = false
    var gameIsOver: Bool = false
    
    //  override to allow integration with SpriteKit Scene Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    // override too all access to all convienve init mehtods
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init?(cellSize:CGFloat, elementSize:CGFloat, rows:Int, cols:Int) {
        guard let texture = Grid.gridTexture(cellSize: cellSize, elementSize: elementSize, rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.black, size: texture.size())
        self.cellSize = cellSize
        self.elementSize = elementSize
        self.rows = rows
        self.cols = cols
    }
    
    
    class func gridTexture(cellSize:CGFloat, elementSize:CGFloat, rows:Int, cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*cellSize, height: CGFloat(rows)*cellSize)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        // set fill color
        context.setFillColor(UIColor.black.cgColor)
            
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }
    
    
    func getNumberOfLabels(level: Int) -> Int {
        switch level {
        case 1...5:
            return 4
        case 6...10:
            return 5
        default:
            return 6
        }
    }
    
    
    func getDifficulty(level: Int) -> Double {
        switch level {
        case 1...5:
            return 0.6
        case 6...10:
            return 0.7
        default:
            return 0.8
        }
    }
    
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        //let ffset = cellSize / 2.0 + 0.5
        //let x = CGFloat(150) + CGFloat(col) * cellSize - (cellSize * CGFloat(cols)) / 2.0 + offset
        //let y = CGFloat(500) + CGFloat(rows - row - 1) * cellSize - (cellSize * CGFloat(rows)) / 2.0 + offset
        
        let centerOffset = cellSize / 2.0
        let x = viewLeftBoundary + CGFloat(col - 1) * cellSize + centerOffset
        let y = viewBottomBoundary + CGFloat(row - 1) * cellSize + centerOffset
        return CGPoint(x:x, y:y)
    }
    
    
    func fillGrid(level: Int, scene: GameScene) {
        var elements: [Element] = []
        let nLabels:Int = getNumberOfLabels(level: level)
        let difficulty: Double = getDifficulty(level: level)
        for r in 1...rows {
            for c in 1...cols {
                let pos = gridPosition(row: r, col: c)
                if readElementByPosition(position:pos, scene:scene)==nil{
                    let element = createElement(row:r, col:c, nLabels:nLabels, difficulty: difficulty)
                    elements.append(element)
                }
            }
        }
        elements.forEach({ scene.addChild($0) })
        return
    }
    
    func printGrid(scene: GameScene) {
        for r in 1...rows {
            for c in 1...cols {
                let pos = gridPosition(row: r, col: c)
                guard let element = readElementByPosition(position:pos, scene:scene) else {
                    print("[grid] [\(r),\(c)] nil")
                    continue
                }
                print("[grid] (\(r),\(c)) name: \(element.name!)") //[\(element.position.x),\(element.position.y)],
            }
        }
    }
        
    
    public func playRound(element: Element, level: Int, scene: GameScene) -> (Int, Int, SKAction) {
        // combo, score, (element, SKAction)
        let connectedElements = findConnectedElements(label: element.label, row: element.row, col: element.col, scene: scene, connectedElements: [])
        let combo: Int = connectedElements.count
        
        if combo < 3 {
            print("[grid] less than 3 elements")
            return (0, 0, nothingAction)
        }
        let score: Int = getScore(combo: combo, level: level)
        
        // build actions to remove Elements
        let removeActions = connectedElements.map({ ($0, removeElementAction() ) })
        let removeAction = SKAction.sequence([
            SKAction.group(removeActions.map({SKAction.run($1, onChildWithName: $0.name!)})),
            SKAction.wait(forDuration: 0.01)
        ])
        
        // build actions to move Elements
        let elementsToRemove = removeActions.map({$0.0.name!})
        let moveActions = moveElementsActions(elementsToRemove: elementsToRemove, scene: scene)
        let moveAction = SKAction.sequence([
            SKAction.group(moveActions.map({SKAction.run($1, onChildWithName: $0.name!)})),
            waitAction
        ])
        
        // action to update elements row and column
        let updateAction = SKAction.run({self.updateRowColInElements(scene: scene)})
        // action to check if level is over and fill grid if needed
        let fillGridAction = SKAction.run({
            if self.isLevelOver(scene: scene) {
                self.fillGrid(level: level+1, scene: scene)
                self.levelIsOver = true
            }
            self.gameIsOver = self.isLevelOver(scene: scene)
        })
        
        let actionToRun = SKAction.sequence([removeAction, moveAction, updateAction, fillGridAction])
        
        return (combo, score, actionToRun)
    }
    
    func isLevelOver(scene: GameScene) -> Bool {
        var elementsSeen: [String] = []
        for r in 1...rows {
            for c in 1...cols {
                let pos = gridPosition(row: r, col: c)
                guard let element = readElementByPosition(position:pos, scene:scene) else {
                    continue
                }
                
                if elementsSeen.contains(element.name!) {
                    continue
                }
                elementsSeen.append(element.name!)
                
                let connectedElements = findConnectedElements(label: element.label, row: r, col: c, scene: scene, connectedElements: [])
                if connectedElements.count > 2 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func findConnectedElements(label: Int, row: Int, col: Int, scene: GameScene, connectedElements: [Element]) -> [Element] {
        var connectedElements = connectedElements
        let pos = gridPosition(row: row, col: col)
        guard let element = readElementByPosition(position:pos, scene:scene) else {
            return connectedElements
        }
        
        if connectedElements.map({ $0.name }).contains(element.name) {
            return connectedElements
        }
        
        let nodeLabel = element.label
        if nodeLabel==label {
            connectedElements.append(element)
            connectedElements = findConnectedElements(label: label, row: row-1, col: col, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row+1, col: col, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row, col: col-1, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row, col: col+1, scene: scene, connectedElements: connectedElements)
        }
        
        return connectedElements
    }
        
    
    func moveElementsActions(elementsToRemove: [String], scene: GameScene) -> [(Element, SKAction)] {
        var actions: [(Element, SKAction)] = [] //, SKAction, String)] = []
        for c in 1...cols {
            actions.append(contentsOf: moveElementsOfColumn(elementsToRemove: elementsToRemove, col: c, scene: scene))
        }
        return actions
    }
    
    
    func moveElementsOfColumn(elementsToRemove: [String], col: Int, scene: GameScene) -> [(Element, SKAction)] {//(Element, SKAction, String)] {
        var elements: [Element] = []
        for r in 1...rows {
            let pos = gridPosition(row: r, col: col)
            guard let element = readElementByPosition(position:pos, scene:scene) else {
                continue
            }
            // skip if element is being removed
            if elementsToRemove.contains(element.name!) {
                continue
            }
            elements.append(element)
        }
        return elements.enumerated().map({ moveElementAction(newRow: $0+1, newCol:col, element:$1) })
    }
    
    func moveElementAction(newRow: Int, newCol: Int, element: Element) -> (Element, SKAction) {
        let newPosition = gridPosition(row: newRow, col: newCol)
        let action = SKAction.move(to: newPosition, duration: 0.2)
        return (element, action)
    }
    
    func removeElementAction() -> SKAction {
        return SKAction.removeFromParent()
    }
    
    func createElement(row:Int, col:Int, nLabels:Int, difficulty: Double) -> Element{
        let pos = gridPosition(row: row, col: col)
        let size = CGSize(width: elementSize, height: elementSize)
        let element = Element(row: row, col:col, nLabels: nLabels, difficulty: difficulty, size:size, position: pos)
        return element
    }
    
    func readElementByName(name: String, scene:GameScene) -> Element? {
        guard let node = scene.childNode(withName: name) else {
            return nil
        }
        return node as! SKSpriteNode as? Element
        
    }
    
    func readElementByRowCol(row:Int, col:Int, scene:GameScene) -> Element? {
        let pos = gridPosition(row: row, col: col)
        guard let element = readElementByPosition(position:pos, scene:scene) else {
            return nil
        }
        return element
    }
    
    func readElementByPosition(position:CGPoint, scene:GameScene) -> Element? {
        let node = scene.atPoint(position)
        if !(node.name ?? "").starts(with: "element") {
            return nil
        }

        return node as! SKSpriteNode as? Element
    }
    
    
    func updateRowColInElements(scene: GameScene) {
        for r in 1...rows {
            for c in 1...cols {
                let pos = gridPosition(row: r, col: c)
                guard let element = readElementByPosition(position:pos, scene:scene) else {
                    continue
                }
                element.row = r
                element.col = c
            }
        }
    }
    
    
    func getLocationDelta(left: CGPoint, right: CGPoint) -> (CGFloat, CGFloat) {
        return (left.x - right.x, left.y - right.y)
    }
    
    func getScore(combo:Int, level:Int) -> Int {
        return Int( Double(combo) * (Double(combo) - 1.0) * ( log( Double(level) ) + 1.0) / 2.0 )
    }
    
    func removeAllElements(scene:GameScene) {
        scene.children.filter({ ($0.name ?? "").starts(with: "element")}).forEach({ $0.removeFromParent() })
    }
}
