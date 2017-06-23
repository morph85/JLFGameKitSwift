//
//  JLFGKGraphNode.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKGraphNode: NSObject {
    var nodes = [JLFGKGraphNode]()
    
    override init() {
        super.init()
        nodes = [JLFGKGraphNode]()
    }
    
    func connectedNodes() -> [JLFGKGraphNode] {
        return nodes
    }
    
    func addConnections(toNodes nodes: [JLFGKGraphNode], bidirectional: Bool) {
        //assert(nodes != nil, "JLFGKGraphNode -addConnectionsToNodes:bidirectional: Cannot call with a nil nodes array.")
        for node: JLFGKGraphNode in nodes {
            if node == self {
                // Let's not add circular connections to ourselves, shall we?
                continue
            }
            if !self.nodes.contains(node) {
                self.nodes.append(node)
            }
            if bidirectional {
                node.addConnections(toNodes: [self], bidirectional: false)
            }
        }
    }
    
    func removeConnections(toNodes nodes: [JLFGKGraphNode], bidirectional: Bool) {
        //assert(nodes != nil, "JLFGKGraphNode -removeConnectionsToNodes:bidirectional: Cannot call with a nil nodes array.")
        for node: JLFGKGraphNode in nodes {
            if self.nodes.contains(node) {
                self.nodes.remove(at: self.nodes.index(of: node)!)
                if bidirectional {
                    node.removeConnections(toNodes: [self], bidirectional: false)
                }
            }
        }
    }
    
    func cost(to node: JLFGKGraphNode) -> Float {
        if nodes.contains(node) {
            return 1.0
        }
        else {
            return Float.greatestFiniteMagnitude
        }
    }
    
    func estimatedCost(to node: JLFGKGraphNode) -> Float {
        if nodes.contains(node) {
            return 0.0
        }
        else {
            return Float.greatestFiniteMagnitude
        }
    }
    
    func findPath(from startNode: JLFGKGraphNode) -> [JLFGKGraphNode]? {
        return startNode.findPath(to: self)
    }
    
    func findPath(to goalNode: JLFGKGraphNode) -> [JLFGKGraphNode]? {
        let frontier = JLFGKSimplePriorityQueue()
//        let cameFrom = NSMapTable<AnyObject, AnyObject>(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableWeakMemory)
//        let costSoFar = NSMapTable<AnyObject, AnyObject>(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableWeakMemory)
        let cameFrom = NSMapTable<JLFGKGraphNode, JLFGKGraphNode>(keyOptions: NSMapTableStrongMemory, valueOptions: NSMapTableStrongMemory)
        let costSoFar = NSMapTable<JLFGKGraphNode, NSNumber>(keyOptions: NSMapTableStrongMemory, valueOptions: NSMapTableStrongMemory)
        frontier.insert(self, withPriority: 0.0)
        costSoFar.setObject(NSNumber(value:0.0), forKey: self)
        while frontier.count() > 0 {
            let current: JLFGKGraphNode? = frontier.get() as? JLFGKGraphNode
            if current == goalNode {
                // Done. Walk back through the cameFrom map to build up the node list, reverse and return it.
                var reversedPath = [JLFGKGraphNode]()
                reversedPath.append(current!)
                var previousNode: JLFGKGraphNode? = cameFrom.object(forKey: current)
                while previousNode != nil {
                    reversedPath.append(previousNode!)
                    previousNode = cameFrom.object(forKey: previousNode)
                }
                let enumerator: NSEnumerator = (reversedPath as NSArray).reverseObjectEnumerator()
                return Array(enumerator) as? [JLFGKGraphNode]
            }
            for next: JLFGKGraphNode in (current?.connectedNodes())! {
                let newCost = CFloat((costSoFar.object(forKey: current))!) + (current?.cost(to: next))!
                let existingCost = (costSoFar.object(forKey: next))
                if existingCost == nil || newCost < CFloat(existingCost!) {
                    costSoFar.setObject(NSNumber(value:newCost), forKey: next)
                    let priority: Float = newCost + next.estimatedCost(to: goalNode)
                    frontier.insert(next, withPriority: priority)
                    cameFrom.setObject(current, forKey: next)
                }
            }
        }
        // If we end up here, that means the goal node wasn't reachable from the start node.
        return nil
    }
}
