//
//  TestJLFDemo1Scene.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

class TestJLFDemoPath1Scene: SKScene {
    
    static func unarchive(from file: String) -> TestJLFDemoPath1Scene {
        /* Retrieve scene file path from the application bundle */
        let nodePath: String = Bundle.main.path(forResource: file, ofType: "sks")!
        let nodeUrl: URL = URL.init(fileURLWithPath: nodePath)
        /* Unarchive the file to an SKScene object */
        let data = try? Data(contentsOf: nodeUrl, options: .mappedIfSafe)
        let arch = NSKeyedUnarchiver(forReadingWith: data!)
        arch.setClass(TestJLFDemoPath1Scene.self, forClassName: "TestJLFDemoPath1Scene")
        let scene: TestJLFDemoPath1Scene = arch.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! TestJLFDemoPath1Scene
        arch.finishDecoding()
        return scene
    }
    
    var navigationGraph: JLFGKGraph?
    var namesToGraphNodes = [NSString: JLFGKGraphNode]()
    private var _graphNodesToSceneNodes: NSMapTable<JLFGKGraphNode, SKNode>?
    var graphNodesToSceneNodes: NSMapTable<JLFGKGraphNode, SKNode>? {
        if _graphNodesToSceneNodes == nil {
            _graphNodesToSceneNodes = NSMapTable(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableStrongMemory)
        }
        return _graphNodesToSceneNodes
    }
    var currentGraphNode: JLFGKGraphNode?
    var selectedNode: SKNode?
    var playerEntity: JLFGKEntity?
    var lastUpdate = CFTimeInterval()
    
    func setUpPlayerEntity() {
        let bouncy = BouncyComponent()
        let pathFollower = PathFollowingComponent()
        let sprite = SpriteComponent()
        sprite.sprite = (childNode(withName: "player") as? SKSpriteNode)
        bouncy.baseAnchorPoint = (sprite.sprite?.anchorPoint)!
        let startNode: SKNode? = (graphNodesToSceneNodes?.object(forKey: currentGraphNode))
        sprite.sprite?.position = (startNode?.position)!
        playerEntity = JLFGKEntity.entity()
        playerEntity?.add(bouncy)
        playerEntity?.add(sprite)
        playerEntity?.add(pathFollower)
    }
    
    func mapGraphNode(_ node: JLFGKGraphNode, toNodeName name: NSString) {
        namesToGraphNodes[name] = node
        graphNodesToSceneNodes?.setObject(childNode(withName: name as String), forKey: node)
    }
    
    func setUpNavigationStuff() {
        // There's probably a better way to do this, like somehow linking nodes
        // in the scene file? I'm not all that knowledgable with SpriteKit.
        let n1 = JLFGKGraphNode()
        let n2 = JLFGKGraphNode()
        let n3 = JLFGKGraphNode()
        let n4 = JLFGKGraphNode()
        let n5 = JLFGKGraphNode()
        let n6 = JLFGKGraphNode()
        let n7 = JLFGKGraphNode()
        let n8 = JLFGKGraphNode()
        let n9 = JLFGKGraphNode()
        let n10 = JLFGKGraphNode()
        let n11 = JLFGKGraphNode()
        let n12 = JLFGKGraphNode()
        let n13 = JLFGKGraphNode()
        let n14 = JLFGKGraphNode()
        let n15 = JLFGKGraphNode()
        let n16 = JLFGKGraphNode()
        let n17 = JLFGKGraphNode()
        let n18 = JLFGKGraphNode()
        let n19 = JLFGKGraphNode()
        let n20 = JLFGKGraphNode()
        let n21 = JLFGKGraphNode()
        let n22 = JLFGKGraphNode()
        let n23 = JLFGKGraphNode()
        let n24 = JLFGKGraphNode()
        let n25 = JLFGKGraphNode()
        let n26 = JLFGKGraphNode()
        let n27 = JLFGKGraphNode()
        let n28 = JLFGKGraphNode()
        let n29 = JLFGKGraphNode()
        let n30 = JLFGKGraphNode()
        let n31 = JLFGKGraphNode()
        let n32 = JLFGKGraphNode()
        let n33 = JLFGKGraphNode()
        let n34 = JLFGKGraphNode()
        let n35 = JLFGKGraphNode()
        let n36 = JLFGKGraphNode()
        let n37 = JLFGKGraphNode()
        let n38 = JLFGKGraphNode()
        let n39 = JLFGKGraphNode()
        let n40 = JLFGKGraphNode()
        // I started out with bidirectional:YES on these, but it was confusing me keeping track of things.
        // Easier for my head to just lay out each connection specifically.
        n1.addConnections(toNodes: [n2], bidirectional: false)
        n2.addConnections(toNodes: [n1, n3], bidirectional: false)
        n3.addConnections(toNodes: [n2, n4, n11], bidirectional: false)
        n4.addConnections(toNodes: [n3, n5], bidirectional: false)
        n5.addConnections(toNodes: [n4, n6], bidirectional: false)
        n6.addConnections(toNodes: [n5, n7, n8], bidirectional: false)
        n7.addConnections(toNodes: [n6], bidirectional: false)
        n8.addConnections(toNodes: [n6, n9, n10], bidirectional: false)
        n9.addConnections(toNodes: [n8], bidirectional: false)
        n10.addConnections(toNodes: [n8], bidirectional: false)
        n11.addConnections(toNodes: [n3, n12, n14], bidirectional: false)
        n12.addConnections(toNodes: [n11, n13], bidirectional: false)
        n13.addConnections(toNodes: [n12], bidirectional: false)
        n14.addConnections(toNodes: [n11, n15], bidirectional: false)
        n15.addConnections(toNodes: [n14, n16], bidirectional: false)
        n16.addConnections(toNodes: [n15, n17], bidirectional: false)
        n17.addConnections(toNodes: [n16, n18, n20], bidirectional: false)
        n18.addConnections(toNodes: [n17, n19], bidirectional: false)
        n19.addConnections(toNodes: [n18], bidirectional: false)
        n20.addConnections(toNodes: [n17, n21, n22], bidirectional: false)
        n21.addConnections(toNodes: [n20], bidirectional: false)
        n22.addConnections(toNodes: [n20, n23], bidirectional: false)
        n23.addConnections(toNodes: [n22, n24], bidirectional: false)
        n24.addConnections(toNodes: [n23, n25], bidirectional: false)
        n25.addConnections(toNodes: [n24, n26], bidirectional: false)
        n26.addConnections(toNodes: [n25, n27], bidirectional: false)
        n27.addConnections(toNodes: [n26, n28, n29], bidirectional: false)
        n28.addConnections(toNodes: [n27], bidirectional: false)
        n29.addConnections(toNodes: [n27, n30], bidirectional: false)
        n30.addConnections(toNodes: [n29, n31], bidirectional: false)
        n31.addConnections(toNodes: [n30, n32], bidirectional: false)
        n32.addConnections(toNodes: [n31, n33, n34], bidirectional: false)
        n33.addConnections(toNodes: [n32], bidirectional: false)
        n34.addConnections(toNodes: [n32, n35], bidirectional: false)
        n35.addConnections(toNodes: [n34, n36], bidirectional: false)
        n36.addConnections(toNodes: [n35, n37], bidirectional: false)
        n37.addConnections(toNodes: [n36, n38], bidirectional: false)
        n38.addConnections(toNodes: [n37, n39], bidirectional: false)
        n39.addConnections(toNodes: [n38, n40], bidirectional: false)
        n40.addConnections(toNodes: [n39], bidirectional: false)
        let nodes: [JLFGKGraphNode] = [n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40]
        navigationGraph = JLFGKGraph(nodes: nodes)
        var nameIndex: Int = 1
        for node: JLFGKGraphNode in nodes {
            mapGraphNode(node, toNodeName: "node\(nameIndex)" as NSString)
            nameIndex += 1
        }
        
    }
    
    override func didMove(to view: SKView) {
        lastUpdate = -1
        setUpNavigationStuff()
        currentGraphNode = namesToGraphNodes["node1"]
        setUpPlayerEntity()
    }
    
    func pulseAction() -> SKAction {
        let grow = SKAction.scale(to: 1.3, duration: 0.8)
        grow.timingMode = .easeInEaseOut
        let shrink = SKAction.scale(to: 1.0, duration: 0.8)
        shrink.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([grow, shrink]))
    }
    
    //func mouseDown(with theEvent: NSEvent) {
    //    let location: CGPoint = theEvent.location(inNode: self)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count <= 0) {
            return;
        }
        
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        let node: SKNode? = atPoint(location)
        if node != nil {
            // Look up the navigation node for the clicked node, if there was one.
            let graphNode: JLFGKGraphNode? = namesToGraphNodes[(node?.name)! as NSString]
            // Is it the one that we're already sitting on? If so, we're done.
            if graphNode == nil || graphNode == currentGraphNode {
                return
            }
            selectedNode?.removeAllActions()
            selectedNode = node
            selectedNode?.run(pulseAction())
            // If not, find a path from the current node to the one clicked on.
            let graphPath: [JLFGKGraphNode]? = currentGraphNode?.findPath(to: graphNode!)
            if graphPath != nil {
                var nodesOnTheWay = [SKNode]() /* capacity: graphPath?.count */
                for graphNode: JLFGKGraphNode in graphPath! {
                    let node: SKNode? = graphNodesToSceneNodes?.object(forKey: graphNode)
                    nodesOnTheWay.append(node!)
                }
                let pathComponent = (playerEntity?.component(for: PathFollowingComponent.self) as? PathFollowingComponent)
                pathComponent?.followPath(nodesOnTheWay)
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if lastUpdate == -1 {
            lastUpdate = currentTime
        }
        let deltaTime: CFTimeInterval = currentTime - lastUpdate
        lastUpdate = currentTime
        playerEntity?.update(withDeltaTime: deltaTime)
        let sprite = (playerEntity?.component(for: SpriteComponent.self) as? SpriteComponent)
        let nodes: [SKNode]? = self.nodes(at: (sprite?.sprite?.position)!)
        for node: SKNode in nodes! {
            let name: String? = node.name
            if name != nil {
                let graphNode: JLFGKGraphNode? = namesToGraphNodes[name! as NSString]
                if graphNode != nil {
                    currentGraphNode = graphNode
                }
            }
        }
    }
}
