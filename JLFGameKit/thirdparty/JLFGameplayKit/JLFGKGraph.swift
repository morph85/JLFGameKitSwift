//
//  JLFGKGraph.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 18/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKGraph: NSObject {
    var realNodes = [JLFGKGraphNode]()
    
    static func graph(nodes: [JLFGKGraphNode]) -> JLFGKGraph {
        return JLFGKGraph(nodes: nodes)
    }
    
    init(nodes: [JLFGKGraphNode]) {
        //assert(nodes != nil, "JLFGKGraph -initWithNodes: Cannot be initialized with a nil nodes array.")
        super.init()
        //realNodes = [JLFGKGraphNode](nodes)
        realNodes = Array(nodes)
    }
    
    func nodes() -> [JLFGKGraphNode] {
        return realNodes
    }
    
    func addNodes(_ nodes: [JLFGKGraphNode]) {
        //assert(nodes != nil, "JLFGKGraph -addNodes: Cannot be called with a nil nodes array.")
        // Make sure we're not adding any duplicates
        for node: JLFGKGraphNode in nodes {
            if !realNodes.contains(node) {
                realNodes.append(node)
            }
        }
    }
    
    func connectNode(toLowestCostNode node: JLFGKGraphNode, bidirectional: Bool) {
        var lowestCostNode: JLFGKGraphNode? = nil
        var lowestCost: Float = Float.greatestFiniteMagnitude
        for n: JLFGKGraphNode in realNodes {
            let cost: Float = node.cost(to: n)
            if cost < lowestCost {
                lowestCost = cost
                lowestCostNode = n
            }
        }
        if lowestCostNode != nil {
            node.addConnections(toNodes: [lowestCostNode!], bidirectional: bidirectional)
        }
    }
    
    func removeNodes(_ nodes: [JLFGKGraphNode]) {
        //assert(nodes != nil, "JLFGKGraph -removeNodes: Cannot be called with a nil nodes array.")
        // Take out any connections from nodes still within the graph to the one being removed.
        for node: JLFGKGraphNode in nodes {
            node.removeConnections(toNodes: realNodes, bidirectional: true)
        }
        //realNodes.removeObjects(in: nodes)
        for node in nodes {
            if (realNodes.contains(node)) {
                let index = realNodes.firstIndex(of: node)
                realNodes.remove(at: index!)
            }
        }
    }
    
    func findPath(from startNode: JLFGKGraphNode, to endNode: JLFGKGraphNode) -> [JLFGKGraphNode]? {
        return startNode.findPath(to: endNode)
    }
}
