//
//  JLFGKObstacleGraph.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

//extension Array {
//    mutating func remove(at indexes: [Int]) {
//        for index in indexes.sorted(by: >) {
//            remove(at: index)
//        }
//    }
//}

func removeFromArray(array: [NSObject], byIndices indices: [Int]) -> [NSObject] {
    var result = array
    let newIndices = indices.sorted().reversed()
    for num in newIndices {
        result.remove(at: num);
    }
    return result
}

class JLFGKObstacleGraph: JLFGKGraph {
    //private(set) var obstacles = [JLFGKObstacle]()
    private(set) var bufferRadius: Float = 0.0
    
    var obstacleToNodes: NSMapTable<JLFGKPolygonObstacle, NSArray>
    var userNodes = [JLFGKObstacleGraphUserNode]()
    var lockedConnections = [JLFGKObstacleGraphConnection]()
    
    static func graph(obstacles: [JLFGKPolygonObstacle], bufferRadius: Float) -> JLFGKObstacleGraph {
        return JLFGKObstacleGraph(obstacles: obstacles, bufferRadius: bufferRadius)
    }
    
    init(obstacles: [JLFGKPolygonObstacle], bufferRadius: Float) {
        assert(bufferRadius > 0.0, "JLFGKObstacleGraph -initWithObstacles:bufferRadius: Buffer radius cannot be <= 0!")
        //obstacles = [JLFGKObstacle]()
        for obj: JLFGKObstacle in obstacles {
            assert((obj is JLFGKPolygonObstacle), "JLFGKObstacleGraph only works with polygon obstacles.")
        }
        //obstacleToNodes = NSMapTable(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableStrongMemory)
        obstacleToNodes = NSMapTable(keyOptions: NSMapTableStrongMemory, valueOptions: NSMapTableStrongMemory)
        super.init(nodes: [])
        lockedConnections = [JLFGKObstacleGraphConnection]()
        userNodes = [JLFGKObstacleGraphUserNode]()
        self.bufferRadius = bufferRadius
        addObstacles(obstacles)
    }
    
    convenience override init(nodes: [JLFGKGraphNode]) {
        assert(false, "JLFGKObstacleGraph must be initialized using -initWithObstacles:bufferRadius:")
        self.init(nodes: nodes)
    }
    
    convenience init() {
        assert(false, "JLFGKObstacleGraph must be initialized using -initWithObstacles:bufferRadius:")
        self.init()
    }
    
    func obstacles() -> [JLFGKObstacle] {
        return Array(obstacleToNodes.keyEnumerator()) as! [JLFGKObstacle]
    }
    
    func rebuildConnections() {
        // The most straightforward way to do this is:
        //  - Remove all nodes. Start with a clean slate.
        //  - For each obstacle, connect all of its nodes together in a loop.
        //  - Again for each obstacle, connect each of its nodes to every other
        //    obstacle node that we can reach without intersecting an obstacle.
        //  - Finally, for each user connection (added with
        //    -connectNodeUsingObstacles:ignoringObstacles:)
        // Before removing all the nodes, make a copy of userNodes. -removeNodes is
        // overriden to clean up that array as well, and we don't want to lose that info
        let userNodesCopy: [JLFGKObstacleGraphUserNode] = userNodes
        removeNodes(self.nodes())
        // Connect each obstacle's nodes together in a loop.
        let obstacles: [JLFGKPolygonObstacle] = Array(obstacleToNodes.keyEnumerator()) as! [JLFGKPolygonObstacle]
        for obstacle: JLFGKPolygonObstacle in obstacles {
            let nodes: [JLFGKGraphNode2D] = obstacleToNodes.object(forKey: obstacle) as! [JLFGKGraphNode2D]
            let numNodes: Int = nodes.count
            for i in 0..<numNodes {
                let current: JLFGKGraphNode2D = nodes[i]
                let previous: JLFGKGraphNode2D = nodes[(i + numNodes - 1) % numNodes]
                let next: JLFGKGraphNode2D = nodes[(i + 1) % numNodes]
                current.addConnections(toNodes: [previous, next], bidirectional: true)
            }
            // Make sure the obstacle's nodes get back into the main node list.
            addNodes(nodes)
        }
        // Run through the obstacle list again. This time, connect the nodes for the obstacle
        // to the nodes for every other obstacle. (not to its own nodes)
        //
        // Man, that's a lot of nested loops.
        for obstacle: JLFGKPolygonObstacle in obstacles {
            let obstacleNodes: [JLFGKGraphNode2D] = obstacleToNodes.object(forKey: obstacle) as! [JLFGKGraphNode2D]
            for otherObstacle: JLFGKPolygonObstacle in obstacles {
                // Don't connect the obstacle to itself
                if obstacle == otherObstacle {
                    continue
                }
                for node: JLFGKGraphNode2D in obstacleNodes {
                    var connections = [JLFGKGraphNode2D]()
                    for otherNode: JLFGKGraphNode2D in obstacleToNodes.object(forKey: otherObstacle) as! [JLFGKGraphNode2D] {
                        if !anyObstaclesBetweenStart(node.position, end: otherNode.position, ignoringObstacles: nil) {
                            connections.append(otherNode)
                        }
                    }
                    node.addConnections(toNodes: connections, bidirectional: true)
                }
            }
        }
        // Connect the user nodes back up
        for userNode: JLFGKObstacleGraphUserNode in userNodesCopy {
            realConnectNode(usingObstacles: userNode.node, ignoringObstacles: userNode.ignoredObstacles as! [JLFGKPolygonObstacle])
        }
        // Put any connections that the user specifically asked for (via locking) back in place.
        for connection: JLFGKObstacleGraphConnection in lockedConnections {
            connection.from.addConnections(toNodes: [connection.to], bidirectional: true)
        }
    }
    
    func addObstacles(_ obstacles: [JLFGKPolygonObstacle]?) {
        assert(obstacles != nil, "JLFGKObstacleGraph -addObstacles: obstacles was nil.")
        // For each obstacle:
        //  - add it to the obstacle list
        //  - get its list of nodes
        //  - connect those nodes together
        //  - connect them to the rest of the graph?
        for obstacle: JLFGKPolygonObstacle in obstacles! {
            let nodes: [JLFGKGraphNode] = obstacle.nodes(withBufferRadius: bufferRadius)
            obstacleToNodes.setObject(nodes as NSArray, forKey: obstacle)
        }
        rebuildConnections()
    }
    
    func connectNode(usingObstacles node: JLFGKGraphNode2D) {
        connectNode(usingObstacles: node, ignoringObstacles: [])
    }
    
    func connectNode(usingObstacles node: JLFGKGraphNode2D, ignoringObstacles obstaclesToIgnore: [JLFGKPolygonObstacle]) {
        let userNode = JLFGKObstacleGraphUserNode(node: node, ignoredObstacles: obstaclesToIgnore)
        userNodes.append(userNode)
        realConnectNode(usingObstacles: node, ignoringObstacles: obstaclesToIgnore)
    }
    
    func realConnectNode(usingObstacles node: JLFGKGraphNode2D, ignoringObstacles obstaclesToIgnore: [JLFGKPolygonObstacle]) {
        // For every node in the graph, if you can draw a line between this node and the other one without
        // bumping into an obstacle (not counting the ones in obstaclesToIgnore), then connect those nodes
        // together.
        let start: vector_float2 = node.position
        var connections = [JLFGKGraphNode2D]()
        for other: JLFGKGraphNode2D in nodes() as! [JLFGKGraphNode2D] {
            if node == other {
                continue
            }
            let end: vector_float2 = other.position
            if !anyObstaclesBetweenStart(start, end: end, ignoringObstacles: obstaclesToIgnore) {
                connections.append(other)
            }
        }
        node.addConnections(toNodes: connections, bidirectional: true)
        addNodes([node])
    }
    
    func removeObstacles(_ obstacles: [JLFGKPolygonObstacle]) {
        for obstacle: JLFGKPolygonObstacle in obstacles {
            removeNodes(obstacleToNodes.object(forKey: obstacle) as! [JLFGKGraphNode])
            obstacleToNodes.removeObject(forKey: obstacle)
        }
        rebuildConnections()
    }
    
    func removeAllObstacles() {
        for nodes: [JLFGKGraphNode2D] in obstacleToNodes.objectEnumerator()!.allObjects as! [[JLFGKGraphNode2D]] {
            removeNodes(nodes)
        }
        obstacleToNodes.removeAllObjects()
        rebuildConnections()
    }
    
    func nodes(for obstacle: JLFGKPolygonObstacle) -> [JLFGKGraphNode2D]? {
        return obstacleToNodes.object(forKey: obstacle) as? [JLFGKGraphNode2D]
    }
    
    func anyObstaclesBetweenStart(_ start: vector_float2, end: vector_float2, ignoringObstacles obstaclesToIgnore: [JLFGKPolygonObstacle]?) -> Bool {
        // This is horribly inefficient: it just loops through each obstacle comparing
        // each line segment that makes up the polygon with the start/end point. It
        // will bail out as soon as an intersection is found, but if there aren't any
        // intersections it has to go through the whole list.
        //
        // It should be augmented with a spatial partition of some kind, but for now
        // let's just get it working.
        for obstacle: JLFGKPolygonObstacle in obstacleToNodes.keyEnumerator().allObjects as! [JLFGKPolygonObstacle] {
            if (obstaclesToIgnore == nil) {
                continue
            }
            if (obstaclesToIgnore!.contains(obstacle)) {
                continue
            }
            let nodes: [JLFGKGraphNode2D] = obstacleToNodes.object(forKey: obstacle) as! [JLFGKGraphNode2D]
            let numNodes: Int = nodes.count
            for i in 0..<numNodes {
                let n1: JLFGKGraphNode2D = nodes[i]
                let n2: JLFGKGraphNode2D = nodes[(i + 1) % numNodes]
                if line_segments_intersect(start, end, n1.position, n2.position) {
                    return true
                }
            }
        }
        return false
    }
    
    func lockConnection(fromNode startNode: JLFGKGraphNode2D, toNode endNode: JLFGKGraphNode2D) {
        for connection: JLFGKObstacleGraphConnection in lockedConnections {
            if connection.from == startNode && connection.to == endNode {
                // This connection is already locked.
                return
            }
        }
        let connection = JLFGKObstacleGraphConnection.fromNode(startNode, toNode: endNode)
        lockedConnections.append(connection)
    }
    
    func unlockConnection(fromNode startNode: JLFGKGraphNode2D, toNode endNode: JLFGKGraphNode2D) {
        var indices = [Int]()
        let numConnections: Int = lockedConnections.count
        for i in 0..<numConnections {
            let conn: JLFGKObstacleGraphConnection? = lockedConnections[i]
            if conn?.from == startNode && conn?.to == endNode {
                indices.append(i)
            }
        }
        lockedConnections = removeFromArray(array: lockedConnections, byIndices: indices) as! [JLFGKObstacleGraphConnection];
        //lockedConnections.remove(at: indices)
    }
    
    func isConnectionLocked(fromNode startNode: JLFGKGraphNode2D, toNode endNode: JLFGKGraphNode2D) -> Bool {
        for connection: JLFGKObstacleGraphConnection in lockedConnections {
            if connection.from == startNode && connection.to == endNode {
                return true
            }
        }
        return false
    }
    
    // MARK: - Overriden methods
    override func removeNodes(_ nodes: [JLFGKGraphNode]) {
        super.removeNodes(nodes)
        // Clean up user added nodes as well.
        let numUserNodes: Int = userNodes.count
        var indices = [Int]()
        for node: JLFGKGraphNode2D in nodes as! [JLFGKGraphNode2D] {
            for i in 0..<numUserNodes {
                let userNode: JLFGKObstacleGraphUserNode? = userNodes[i]
                if userNode?.node == node {
                    indices.append(i)
                }
            }
        }
        userNodes = removeFromArray(array: userNodes, byIndices: indices) as! [JLFGKObstacleGraphUserNode];
        //userNodes.remove(at: indices)
    }
}
