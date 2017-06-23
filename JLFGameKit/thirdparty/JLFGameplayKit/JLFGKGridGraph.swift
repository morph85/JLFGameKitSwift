//
//  JLFGKGridGraph.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 18/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

func addToArrayIfNotNil(array: [JLFGKGridGraphNode], obj: JLFGKGridGraphNode?) -> [JLFGKGridGraphNode] {
    var result = array
    if obj != nil {
        result.append(obj!)
    }
    return result
}

class JLFGKGridGraph: JLFGKGraph {
    
    private(set) var isDiagonalsAllowed: Bool = false
    private(set) var gridOrigin = vector_int2()
    private(set) var gridWidth: Int = 0
    private(set) var gridHeight: Int = 0
    
    var gridNodes = [JLFGKGridGraphNode]()
    
    class func fromGridStarting(at position: vector_int2, width: Int, height: Int, diagonalsAllowed: Bool) -> JLFGKGridGraph {
        return JLFGKGridGraph.init(at: position, width: width, height: height, diagonalsAllowed: diagonalsAllowed)
    }
    
    init(at position: vector_int2, width: Int, height: Int, diagonalsAllowed: Bool) {
        assert(width > 0, "JLFGKGridGraph -initFromGridStartingAt:width:height:diagonalsAllowed: Cannot create a grid graph with width < 1.")
        assert(height > 0, "JLFGKGridGraph -initFromGridStartingAt:width:height:diagonalsAllowed: Cannot create a grid graph with height < 1.")
        // Before we get to initializing the object, we're going to build up the graph nodes so that we can call [super initWithNodes:]
        //let numNodes: Int = width * height
        let _: Int = width * height
        var gridNodes = [JLFGKGridGraphNode]() /* capacity: numNodes */
        let minX: Int = Int(position.x)
        let minY: Int = Int(position.y)
        let maxX: Int = minX + width
        let maxY: Int = minY + height
        for y in minY..<maxY {
            for x in minX..<maxX {
                gridNodes.append(JLFGKGridGraphNode(gridPosition: [Int32(x), Int32(y)]))
            }
        }
        super.init(nodes: gridNodes)
        gridOrigin = position
        gridWidth = width
        gridHeight = height
        self.isDiagonalsAllowed = diagonalsAllowed
        self.gridNodes = gridNodes
        // A freshly created grid graph starts out fully connected.
        for node: JLFGKGridGraphNode in gridNodes {
            connectNode(toAdjacentNodes: node)
        }
    }
    
    func node(atGridPosition position: vector_int2) -> JLFGKGridGraphNode? {
        // Make sure the given position is in the proper range.
        if position.x < gridOrigin.x {
            return nil
        }
        if position.y < gridOrigin.y {
            return nil
        }
        if position.x >= gridOrigin.x + Int32(gridWidth) {
            return nil
        }
        if position.y >= gridOrigin.y + Int32(gridHeight) {
            return nil
        }
        // What should this do if a node has been removed from the graph via JLFGKGraph -removeNodes:?
        // Nodes that have been removed in that way won't be used for pathfinding any longer, but a user might
        // want to re-add a grid location; for example, if a door was opened.
        // The documentation doesn't say one way or the other, so I'm leaving it more open ended and not
        // checking to see whether a grid node is still in self.connectedNodes.
        let idx = (position.y - gridOrigin.y) * Int32(gridWidth) + (position.x - gridOrigin.x)
        return gridNodes[Int(idx)]
    }
    
    func connectNode(toAdjacentNodes node: JLFGKGridGraphNode) {
        let pos: vector_int2 = node.position
        var newConnections = [JLFGKGridGraphNode]() /* capacity: 8 */
        newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x - 1, pos.y]))
        newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x + 1, pos.y]))
        newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x, pos.y - 1]))
        newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x, pos.y + 1]))
        if isDiagonalsAllowed {
            newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x - 1, pos.y - 1]))
            newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x + 1, pos.y - 1]))
            newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x - 1, pos.y + 1]))
            newConnections = addToArrayIfNotNil(array: newConnections, obj: self.node(atGridPosition: [pos.x + 1, pos.y + 1]))
        }
        node.addConnections(toNodes: newConnections as [JLFGKGraphNode], bidirectional: true)
    }
}
