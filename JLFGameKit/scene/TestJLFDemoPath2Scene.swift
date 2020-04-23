//
//  TestJLFDemoPath2Scene.swift
//  JLFGameKit
//
//  Ported by morph85 on 22/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

// The tiles are square and 32 points on a side.
private let kTileSize: CGFloat = 32.0

class TestJLFDemoPath2Scene: SKScene {
    
//    static func unarchive(from file: String) -> TestJLFDemoPath2Scene {
//        /* Retrieve scene file path from the application bundle */
//        let nodePath: String = Bundle.main.path(forResource: file, ofType: "sks")!
//        let nodeUrl: URL = URL.init(fileURLWithPath: nodePath)
//        /* Unarchive the file to an SKScene object */
//        let data = try? Data(contentsOf: nodeUrl, options: .mappedIfSafe)
//        let arch = NSKeyedUnarchiver(forReadingWith: data!)
//        arch.setClass(TestJLFDemoPath2Scene.self, forClassName: "TestJLFDemoPath2Scene")
//        let scene: TestJLFDemoPath2Scene = arch.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! TestJLFDemoPath2Scene
//        arch.finishDecoding()
//        return scene
//    }
    
    var sceneRoot: SKSpriteNode?
    var tiles = [SKSpriteNode]()
    var tilesInPath: NSMapTable<JLFGKGridGraphNode, SKSpriteNode>?
    var tilesWide: Int = 0
    var tilesHigh: Int = 0
    var graph: JLFGKGridGraph?
    var panRecognizer: UIGestureRecognizer?
    var tapRecognizer: UIGestureRecognizer?
    var sceneOffsetAtPanStart = CGPoint.zero
    var playerEntity: JLFGKEntity?
    var playerSprite: SpriteComponent?
    var playerMoveComponent: PathMoveComponent?
    var isFirstUpdate: Bool = false
    var lastUpdateTime = CFTimeInterval()
    
    override func didMove(to view: SKView) {
        removeAllChildren()
        sceneRoot = SKSpriteNode(color: UIColor.green, size: CGSize(width: CGFloat(128.0), height: CGFloat(128.0)))
        sceneRoot?.position = CGPoint.zero
        sceneRoot?.anchorPoint = CGPoint.zero
        addChild(sceneRoot!)
        tilesWide = 30
        tilesHigh = 30
        tiles = [SKSpriteNode]() /* capacity: tilesWide * tilesHigh */
        tilesInPath = NSMapTable(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableWeakMemory)
        generateMap()
        createPlayerEntity()
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(panRecognizer!)
        view.addGestureRecognizer(tapRecognizer!)
        isFirstUpdate = true
    }
    
    override func willMove(from view: SKView) {
        view.removeGestureRecognizer(panRecognizer!)
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if isFirstUpdate {
            lastUpdateTime = currentTime
            isFirstUpdate = false
            return
        }
        var deltaTime: CFTimeInterval = currentTime - lastUpdateTime
        // Clamp those delta values if they get too big: otherwise the simulator can get
        // some weird behavior if it can't keep up.
        if deltaTime > 1.0 / 15.0 {
            deltaTime = 1.0 / 15.0
        }
        lastUpdateTime = currentTime
        playerEntity?.update(withDeltaTime: deltaTime)
    }
    
    func generateMap() {
        // The map is generated using a cellular automata. Basically just the algorithm here:
        // http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
        //
        // I run through two automata: one of them just gives me a nicer looking mix of normal and dry grass
        // tiles, and the second one gives me the forest on top of it. The forest one is the one that's
        // used for pathfinding.
        var baseAutomata = CellularAutomata.randomlyFilledCellularAutomata(width: tilesWide, height: tilesHigh, percentFilled: 0.4)
        for _ in 0 ..< 3 {
            baseAutomata = baseAutomata.nextGeneration(with: {(_ numNeighbors: Int) -> Bool in
                return numNeighbors > 4 || numNeighbors == 2
            })
        }
        for _ in 0 ..< 2 {
            baseAutomata = baseAutomata.nextGeneration(with: {(_ numNeighbors: Int) -> Bool in
                return numNeighbors > 4
            })
        }
        for y in 0 ..< tilesHigh {
            for x in 0 ..< tilesWide {
                let useDirt: Bool = baseAutomata.cells[x + y * tilesWide] == true
                let textureName: String = useDirt == true ? "a_dirt" : "a_grass"
                let node = SKSpriteNode(imageNamed: textureName)
                let position = CGPoint(x: CGFloat(x * Int(32.0)), y: CGFloat(y * Int(32.0)))
                node.position = position
                node.anchorPoint = CGPoint.zero
                tiles.append(node)
                sceneRoot?.addChild(node)
            }
        }
        // Now figure out where we want trees.
        var treeAutomata = CellularAutomata.randomlyFilledCellularAutomata(width: tilesWide, height: tilesHigh, percentFilled: 0.45)
        for _ in 0 ..< 5 {
            treeAutomata = treeAutomata.nextGeneration(with: {(_ numNeighbors: Int) -> Bool in
                return numNeighbors > 4 || numNeighbors == 0
            })
        }
        for y in 0..<tilesHigh {
            for x in 0..<tilesWide {
                if treeAutomata.cells[x + y * tilesWide] == true {
                    let node = SKSpriteNode(imageNamed: "a_tree")
                    let position = CGPoint(x: CGFloat(x * Int(32.0)), y: CGFloat(y * Int(32.0)))
                    node.position = position
                    node.anchorPoint = CGPoint.zero
                    sceneRoot?.addChild(node)
                }
            }
        }
        graph = JLFGKGridGraph.fromGridStarting(at: (vector_int2(0, 0)), width: Int(tilesWide), height: Int(tilesHigh), diagonalsAllowed: false)
        var walls = [JLFGKGridGraphNode]()
        for y in 0..<tilesHigh {
            for x in 0..<tilesWide {
                if treeAutomata.cells[x + y * tilesWide] == true {
                    // is occupied
                    walls.append((graph?.node(atGridPosition: (vector_int2(Int32(x), Int32(y)))))!)
                }
            }
        }
        graph?.removeNodes(walls)
    }
    
    func createPlayerEntity() {
        playerMoveComponent = PathMoveComponent()
        playerMoveComponent?.distanceBetweenWaypoints = Float(kTileSize)
        let weakSelf: TestJLFDemoPath2Scene? = self
        playerMoveComponent?.waypointCallback = {(_ waypoint: JLFGKGridGraphNode) -> Void in
            let tile: SKSpriteNode? = (weakSelf?.self.tilesInPath?.object(forKey: waypoint))
            tile?.removeAllActions()
            tile?.colorBlendFactor = 0.0
        }
        playerSprite = SpriteComponent()
        playerSprite?.sprite = SKSpriteNode(imageNamed: "a_ranger-left")
        playerSprite?.sprite?.anchorPoint = CGPoint.zero
        let bouncy = BouncyComponent()
        bouncy.baseAnchorPoint = CGPoint.zero
        playerEntity = JLFGKEntity.entity()
        playerEntity?.add(playerSprite!)
        playerEntity?.add(bouncy)
        playerEntity?.add(playerMoveComponent!)
        sceneRoot?.addChild((playerSprite?.sprite)!)
        // Find an open tile to stick him on.
        var tileOpen: Bool = false
        var x: Int32 = 0
        var y: Int32 = 0
        while !tileOpen {
            x = Int32(arc4random_uniform(UInt32(Int(tilesWide) / 3)))
            y = Int32(arc4random_uniform(UInt32(Int(tilesHigh) / 3)))
            tileOpen = (graph?.nodes().contains((graph?.node(atGridPosition: (vector_int2(x,y))))!))!
        }
        playerSprite?.sprite?.position = CGPoint(x: CGFloat(CGFloat(x) * kTileSize), y: CGFloat(CGFloat(y) * kTileSize))
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            sceneOffsetAtPanStart = (sceneRoot?.position)!
        }
        else if sender.state == .changed {
            let translation: CGPoint = sender.translation(in: view)
            var newOffset: CGPoint = sceneOffsetAtPanStart
            newOffset.x += translation.x
            newOffset.y -= translation.y
            let minX: CGFloat = -(CGFloat(tilesWide) * kTileSize) + view!.bounds.size.width
            let minY: CGFloat = -(CGFloat(tilesHigh) * kTileSize) + view!.bounds.size.height
            if newOffset.x <= minX {
                newOffset.x = minX
            }
            if newOffset.x > 0 {
                newOffset.x = 0
            }
            if newOffset.y <= minY {
                newOffset.y = minY
            }
            if newOffset.y > 0 {
                newOffset.y = 0
            }
            sceneRoot?.position = newOffset
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        var location: CGPoint = sender.location(in: view)
        location.y = (view?.bounds.size.height)! - location.y
        location.x -= (sceneRoot?.position.x)!
        location.y -= (sceneRoot?.position.y)!
        let goalX = Int32(floor(location.x / kTileSize))
        let goalY = Int32(floor(location.y / kTileSize))
        let startX = Int32(floor((playerSprite?.sprite?.position.x)! / kTileSize))
        let startY = Int32(floor((playerSprite?.sprite?.position.y)! / kTileSize))
        let path: [JLFGKGridGraphNode]? = graph?.findPath(from: (graph?.node(atGridPosition: (vector_int2(startX, startY))))!, to: (graph?.node(atGridPosition: (vector_int2(goalX, goalY))))!) as? [JLFGKGridGraphNode]
        if path == nil {
            print("Failed to find a path from {\(startX), \(startY)} to {\(goalX), \(goalY)}!")
        } else {
            // Clear any tiles that are already marked
            for tile: SKSpriteNode in tilesInPath?.objectEnumerator()?.allObjects as! [SKSpriteNode] {
                tile.removeAllActions()
                tile.color = UIColor.white
                tile.colorBlendFactor = 0.0
            }
            tilesInPath?.removeAllObjects()
            // Mark the new path
            for node: JLFGKGridGraphNode in path! {
                let position = node.position
                let centerX: Float = Float(CGFloat(position.x) * kTileSize + (kTileSize / 2.0))
                let centerY: Float = Float(CGFloat(position.y) * kTileSize + (kTileSize / 2.0))
                let colorRampUp = SKAction.colorize(withColorBlendFactor: 0.6, duration: 0.4)
                let colorRampDown: SKAction? = colorRampUp.reversed()
                let colorRamp = SKAction.repeatForever(SKAction.sequence([colorRampUp, colorRampDown!]))
                let sprites: [SKSpriteNode]? = sceneRoot?.nodes(at: CGPoint(x: CGFloat(centerX), y: CGFloat(centerY))) as? [SKSpriteNode]
                for sprite: SKSpriteNode in sprites! {
                    if tiles.contains(sprite) {
                        sprite.color = UIColor.red
                        sprite.run(colorRamp)
                        tilesInPath?.setObject(sprite, forKey: node)
                    }
                }
            }
            playerMoveComponent?.followPath(path)
        }
    }
}
