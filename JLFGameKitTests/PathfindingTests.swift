//
//  PathfindingTests.swift
//  JLFGameKit
//
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
import simd
@testable import JLFGameKit

class PathfindingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConnectingToNodesOneWay() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2, n3, n4], bidirectional: false)
        n2.addConnections(toNodes: [n5, n6], bidirectional: false)
        XCTAssert(n1.connectedNodes().contains(n2))
        XCTAssert(n1.connectedNodes().contains(n3))
        XCTAssert(n1.connectedNodes().contains(n4))
        XCTAssert(n2.connectedNodes().contains(n5))
        XCTAssert(n2.connectedNodes().contains(n6))
        XCTAssertFalse(n2.connectedNodes().contains(n1))
        XCTAssertFalse(n3.connectedNodes().contains(n1))
        XCTAssertFalse(n4.connectedNodes().contains(n1))
        XCTAssertFalse(n5.connectedNodes().contains(n2))
        XCTAssertFalse(n6.connectedNodes().contains(n2))
    }
    
    func testConnectingToNodesBidirectional() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        n1?.addConnections(toNodes: [n2, n3, n4], bidirectional: true)
        n2?.addConnections(toNodes: [n5, n6], bidirectional: false)
        XCTAssert(n1.connectedNodes().contains(n2))
        XCTAssert(n1.connectedNodes().contains(n3))
        XCTAssert(n1.connectedNodes().contains(n4))
        XCTAssert(n2.connectedNodes().contains(n5))
        XCTAssert(n2.connectedNodes().contains(n6))
        XCTAssert(n2.connectedNodes().contains(n1))
        XCTAssert(n3.connectedNodes().contains(n1))
        XCTAssert(n4.connectedNodes().contains(n1))
        XCTAssertFalse(n5.connectedNodes().contains(n2))
        XCTAssertFalse(n6.connectedNodes().contains(n2))
    }
    
    func testRemoveConnectionsToNodes() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        n1?.addConnections(toNodes: [n2, n3, n4], bidirectional: true)
        n2?.addConnections(toNodes: [n5, n6], bidirectional: true)
        n2?.removeConnections(toNodes: [n5], bidirectional: false)
        XCTAssert(n1.connectedNodes().contains(n2))
        XCTAssert(n1.connectedNodes().contains(n3))
        XCTAssert(n1.connectedNodes().contains(n4))
        XCTAssertFalse(n2.connectedNodes().contains(n5))
        XCTAssert(n2.connectedNodes().contains(n6))
        XCTAssert(n2.connectedNodes().contains(n1))
        XCTAssert(n3.connectedNodes().contains(n1))
        XCTAssert(n4.connectedNodes().contains(n1))
        XCTAssert(n5.connectedNodes().contains(n2))
        XCTAssert(n6.connectedNodes().contains(n2))
    }
    
    func testCostsAreCorrect() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2], bidirectional: false)
        XCTAssertEqual(1.0, n1.cost(to: n2))
        XCTAssertEqual(Float.greatestFiniteMagnitude, n2.cost(to: n1))
    }
    
    func testFindSimplePath() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2, n3, n4], bidirectional: true)
        n2.addConnections(toNodes: [n5, n6], bidirectional: true)
        let path: [JLFGKGraphNode]? = n1.findPath(to: n6)
        XCTAssertNotNil(path)
        XCTAssertEqual(path?.count, 3)
        XCTAssertEqual(path?[0], n1)
        XCTAssertEqual(path?[1], n2)
        XCTAssertEqual(path?[2], n6)
    }
    
    func testFindMoreComplexPath() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        for node: JLFGKGraphNode in [n1, n2, n3, n4, n5, n6] {
            var moreNodes = [JLFGKGraphNode]()
            for _ in 0..<12 {
                moreNodes.append(JLFGKGraphNode())
            }
            node.addConnections(toNodes: moreNodes, bidirectional: true)
        }
        n1.connectedNodes()[1].addConnections(toNodes: [n2], bidirectional: true)
        n2.connectedNodes()[2].addConnections(toNodes: [n3], bidirectional: true)
        n3.connectedNodes()[3].addConnections(toNodes: [n4], bidirectional: true)
        n4.connectedNodes()[4].addConnections(toNodes: [n5], bidirectional: true)
        n5.connectedNodes()[5].addConnections(toNodes: [n6], bidirectional: true)
        let path: [JLFGKGraphNode]? = n1?.findPath(to: n6)
        XCTAssertNotNil(path)
        XCTAssertEqual(path?.count, 11)
        XCTAssertEqual(path?[0], n1)
        XCTAssertEqual(path?[1], n1.connectedNodes()[1])
        XCTAssertEqual(path?[2], n2)
        XCTAssertEqual(path?[3], n2.connectedNodes()[2])
        XCTAssertEqual(path?[4], n3)
        XCTAssertEqual(path?[5], n3.connectedNodes()[3])
        XCTAssertEqual(path?[6], n4)
        XCTAssertEqual(path?[7], n4.connectedNodes()[4])
        XCTAssertEqual(path?[8], n5)
        XCTAssertEqual(path?[9], n5.connectedNodes()[5])
        XCTAssertEqual(path?[10], n6)
    }
    
    func testFindPathsInDirectedGraph() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        var n3: JLFGKGraphNode!
        var n4: JLFGKGraphNode!
        var n5: JLFGKGraphNode!
        var n6: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n4 = JLFGKGraphNode()
        n5 = JLFGKGraphNode()
        n6 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2, n3], bidirectional: true)
        n2.addConnections(toNodes: [n5], bidirectional: true)
        n3.addConnections(toNodes: [n4], bidirectional: false)
        n4.addConnections(toNodes: [n6], bidirectional: false)
        n6.addConnections(toNodes: [n5], bidirectional: false)
        let n1_n6: [JLFGKGraphNode]? = n1.findPath(to: n6)
        let n6_n1: [JLFGKGraphNode]? = n1.findPath(from: n6)
        XCTAssertNotNil(n1_n6)
        XCTAssertEqual(n1_n6?.count, 4)
        XCTAssertEqual(n1_n6?[0], n1)
        XCTAssertEqual(n1_n6?[1], n3)
        XCTAssertEqual(n1_n6?[2], n4)
        XCTAssertEqual(n1_n6?[3], n6)
        XCTAssertNotNil(n6_n1)
        XCTAssertEqual(n6_n1?.count, 4)
        XCTAssertEqual(n6_n1?[0], n6)
        XCTAssertEqual(n6_n1?[1], n5)
        XCTAssertEqual(n6_n1?[2], n2)
        XCTAssertEqual(n6_n1?[3], n1)
    }
    
    func testNoDuplicateConnections() {
        var n1: JLFGKGraphNode!
        var n2: JLFGKGraphNode!
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2], bidirectional: true)
        n2.addConnections(toNodes: [n1], bidirectional: true)
        XCTAssertEqual(n1.connectedNodes().count, 1)
        XCTAssertEqual(n2.connectedNodes().count, 1)
    }
    
    func testCantConnectNodeToItself() {
        let n1 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n1], bidirectional: true)
        XCTAssertEqual(n1.connectedNodes().count, 0)
    }
    
    func testRemovingNodesFromGraphRemovesConnections() {
        var n1: JLFGKGraphNode
        var n2: JLFGKGraphNode
        var n3: JLFGKGraphNode
        n1 = JLFGKGraphNode()
        n2 = JLFGKGraphNode()
        n3 = JLFGKGraphNode()
        n1.addConnections(toNodes: [n2, n3], bidirectional: true)
        let graph = JLFGKGraph(nodes: [n1, n2])
        XCTAssertEqual(n1.connectedNodes().contains(n2), true)
        XCTAssertEqual(n1.connectedNodes().contains(n3), true)
        graph.removeNodes([n2])
        XCTAssertEqual(n1.connectedNodes().contains(n2), false)
        XCTAssertEqual(n2.connectedNodes().contains(n1), false)
        XCTAssertEqual(n1.connectedNodes().contains(n3), true)
        XCTAssertEqual(n3.connectedNodes().contains(n1), true)
    }
    
    func testGridGraphProperties() {
        let graph = JLFGKGridGraph.fromGridStarting(at: [-3, -7], width: 3, height: 3, diagonalsAllowed: true)
        XCTAssertEqual(graph.gridOrigin.x, -3)
        XCTAssertEqual(graph.gridOrigin.y, -7)
        XCTAssertEqual(graph.gridWidth, 3)
        XCTAssertEqual(graph.gridHeight, 3)
        XCTAssertEqual(graph.isDiagonalsAllowed, true)
    }
    
    func testGridGraphNodeLookup() {
        let originGraph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: 3, height: 3, diagonalsAllowed: false)
        for x in 0..<3 {
            for y in 0..<3 {
                let node: JLFGKGridGraphNode = originGraph.node(atGridPosition: [Int32(x), Int32(y)])!
                XCTAssertEqual(Int(node.position.x), x)
                XCTAssertEqual(Int(node.position.y), y)
            }
        }
        var invalidNode: JLFGKGridGraphNode? = originGraph.node(atGridPosition: [-1, 0])
        XCTAssertNil(invalidNode)
        invalidNode = originGraph.node(atGridPosition: [3, 0])
        XCTAssertNil(invalidNode)
        invalidNode = originGraph.node(atGridPosition: [1, -1])
        XCTAssertNil(invalidNode)
        invalidNode = originGraph.node(atGridPosition: [1, 3])
        XCTAssertNil(invalidNode)
        let notOriginGraph = JLFGKGridGraph.fromGridStarting(at: [-7, 10], width: 3, height: 3, diagonalsAllowed: false)
        for x in -7 ..< -4 {
            for y in 10..<13 {
                let node: JLFGKGridGraphNode = notOriginGraph.node(atGridPosition: [Int32(x), Int32(y)])!
                XCTAssertEqual(Int(node.position.x), x)
                XCTAssertEqual(Int(node.position.y), y)
            }
        }
        invalidNode = notOriginGraph.node(atGridPosition: [-8, 11])
        XCTAssertNil(invalidNode)
        invalidNode = notOriginGraph.node(atGridPosition: [-4, 11])
        XCTAssertNil(invalidNode)
        invalidNode = notOriginGraph.node(atGridPosition: [-5, 9])
        XCTAssertNil(invalidNode)
        invalidNode = notOriginGraph.node(atGridPosition: [-5, 13])
        XCTAssertNil(invalidNode)
    }

    func testGridGraphCreatedFullyConnectedNoDiagonals() {
        let graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: 3, height: 3, diagonalsAllowed: false)
        XCTAssertNotNil(graph)
        XCTAssertEqual(graph.nodes().count, 9)
        let n00: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 0])!
        let n01: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 1])!
        let n02: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 2])!
        let n10: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 0])!
        let n11: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 1])!
        let n12: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 2])!
        let n20: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 0])!
        let n21: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 1])!
        let n22: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 2])!
        
        XCTAssertEqual(n00.connectedNodes().contains(n00), false)
        XCTAssertEqual(n00.connectedNodes().contains(n10), true)
        XCTAssertEqual(n00.connectedNodes().contains(n20), false)
        XCTAssertEqual(n00.connectedNodes().contains(n01), true)
        XCTAssertEqual(n00.connectedNodes().contains(n11), false)
        XCTAssertEqual(n00.connectedNodes().contains(n21), false)
        XCTAssertEqual(n00.connectedNodes().contains(n02), false)
        XCTAssertEqual(n00.connectedNodes().contains(n12), false)
        XCTAssertEqual(n00.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n10.connectedNodes().contains(n00), true)
        XCTAssertEqual(n10.connectedNodes().contains(n10), false)
        XCTAssertEqual(n10.connectedNodes().contains(n20), true)
        XCTAssertEqual(n10.connectedNodes().contains(n01), false)
        XCTAssertEqual(n10.connectedNodes().contains(n11), true)
        XCTAssertEqual(n10.connectedNodes().contains(n21), false)
        XCTAssertEqual(n10.connectedNodes().contains(n02), false)
        XCTAssertEqual(n10.connectedNodes().contains(n12), false)
        XCTAssertEqual(n10.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n20.connectedNodes().contains(n00), false)
        XCTAssertEqual(n20.connectedNodes().contains(n10), true)
        XCTAssertEqual(n20.connectedNodes().contains(n20), false)
        XCTAssertEqual(n20.connectedNodes().contains(n01), false)
        XCTAssertEqual(n20.connectedNodes().contains(n11), false)
        XCTAssertEqual(n20.connectedNodes().contains(n21), true)
        XCTAssertEqual(n20.connectedNodes().contains(n02), false)
        XCTAssertEqual(n20.connectedNodes().contains(n12), false)
        XCTAssertEqual(n20.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n01.connectedNodes().contains(n00), true)
        XCTAssertEqual(n01.connectedNodes().contains(n10), false)
        XCTAssertEqual(n01.connectedNodes().contains(n20), false)
        XCTAssertEqual(n01.connectedNodes().contains(n01), false)
        XCTAssertEqual(n01.connectedNodes().contains(n11), true)
        XCTAssertEqual(n01.connectedNodes().contains(n21), false)
        XCTAssertEqual(n01.connectedNodes().contains(n02), true)
        XCTAssertEqual(n01.connectedNodes().contains(n12), false)
        XCTAssertEqual(n01.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n11.connectedNodes().contains(n00), false)
        XCTAssertEqual(n11.connectedNodes().contains(n10), true)
        XCTAssertEqual(n11.connectedNodes().contains(n20), false)
        XCTAssertEqual(n11.connectedNodes().contains(n01), true)
        XCTAssertEqual(n11.connectedNodes().contains(n11), false)
        XCTAssertEqual(n11.connectedNodes().contains(n21), true)
        XCTAssertEqual(n11.connectedNodes().contains(n02), false)
        XCTAssertEqual(n11.connectedNodes().contains(n12), true)
        XCTAssertEqual(n11.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n21.connectedNodes().contains(n00), false)
        XCTAssertEqual(n21.connectedNodes().contains(n10), false)
        XCTAssertEqual(n21.connectedNodes().contains(n20), true)
        XCTAssertEqual(n21.connectedNodes().contains(n01), false)
        XCTAssertEqual(n21.connectedNodes().contains(n11), true)
        XCTAssertEqual(n21.connectedNodes().contains(n21), false)
        XCTAssertEqual(n21.connectedNodes().contains(n02), false)
        XCTAssertEqual(n21.connectedNodes().contains(n12), false)
        XCTAssertEqual(n21.connectedNodes().contains(n22), true)
        
        XCTAssertEqual(n02.connectedNodes().contains(n00), false)
        XCTAssertEqual(n02.connectedNodes().contains(n10), false)
        XCTAssertEqual(n02.connectedNodes().contains(n20), false)
        XCTAssertEqual(n02.connectedNodes().contains(n01), true)
        XCTAssertEqual(n02.connectedNodes().contains(n11), false)
        XCTAssertEqual(n02.connectedNodes().contains(n21), false)
        XCTAssertEqual(n02.connectedNodes().contains(n02), false)
        XCTAssertEqual(n02.connectedNodes().contains(n12), true)
        XCTAssertEqual(n02.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n12.connectedNodes().contains(n00), false)
        XCTAssertEqual(n12.connectedNodes().contains(n10), false)
        XCTAssertEqual(n12.connectedNodes().contains(n20), false)
        XCTAssertEqual(n12.connectedNodes().contains(n01), false)
        XCTAssertEqual(n12.connectedNodes().contains(n11), true)
        XCTAssertEqual(n12.connectedNodes().contains(n21), false)
        XCTAssertEqual(n12.connectedNodes().contains(n02), true)
        XCTAssertEqual(n12.connectedNodes().contains(n12), false)
        XCTAssertEqual(n12.connectedNodes().contains(n22), true)
        
        XCTAssertEqual(n22.connectedNodes().contains(n00), false)
        XCTAssertEqual(n22.connectedNodes().contains(n10), false)
        XCTAssertEqual(n22.connectedNodes().contains(n20), false)
        XCTAssertEqual(n22.connectedNodes().contains(n01), false)
        XCTAssertEqual(n22.connectedNodes().contains(n11), false)
        XCTAssertEqual(n22.connectedNodes().contains(n21), true)
        XCTAssertEqual(n22.connectedNodes().contains(n02), false)
        XCTAssertEqual(n22.connectedNodes().contains(n12), true)
        XCTAssertEqual(n22.connectedNodes().contains(n22), false)
    }
    
    func testGridGraphCreatedFullyConnectedWithDiagonals() {
        let graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: 3, height: 3, diagonalsAllowed: true)
        XCTAssertNotNil(graph)
        XCTAssertEqual(graph.nodes().count, 9)
        let n00: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 0])!
        let n01: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 1])!
        let n02: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 2])!
        let n10: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 0])!
        let n11: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 1])!
        let n12: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 2])!
        let n20: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 0])!
        let n21: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 1])!
        let n22: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 2])!
        XCTAssertEqual(n00.connectedNodes().contains(n00), false)
        XCTAssertEqual(n00.connectedNodes().contains(n10), true)
        XCTAssertEqual(n00.connectedNodes().contains(n20), false)
        XCTAssertEqual(n00.connectedNodes().contains(n01), true)
        XCTAssertEqual(n00.connectedNodes().contains(n11), true)
        XCTAssertEqual(n00.connectedNodes().contains(n21), false)
        XCTAssertEqual(n00.connectedNodes().contains(n02), false)
        XCTAssertEqual(n00.connectedNodes().contains(n12), false)
        XCTAssertEqual(n00.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n10.connectedNodes().contains(n00), true)
        XCTAssertEqual(n10.connectedNodes().contains(n10), false)
        XCTAssertEqual(n10.connectedNodes().contains(n20), true)
        XCTAssertEqual(n10.connectedNodes().contains(n01), true)
        XCTAssertEqual(n10.connectedNodes().contains(n11), true)
        XCTAssertEqual(n10.connectedNodes().contains(n21), true)
        XCTAssertEqual(n10.connectedNodes().contains(n02), false)
        XCTAssertEqual(n10.connectedNodes().contains(n12), false)
        XCTAssertEqual(n10.connectedNodes().contains(n22), false)
        XCTAssertEqual(n20.connectedNodes().contains(n00), false)
        XCTAssertEqual(n20.connectedNodes().contains(n10), true)
        XCTAssertEqual(n20.connectedNodes().contains(n20), false)
        XCTAssertEqual(n20.connectedNodes().contains(n01), false)
        XCTAssertEqual(n20.connectedNodes().contains(n11), true)
        XCTAssertEqual(n20.connectedNodes().contains(n21), true)
        XCTAssertEqual(n20.connectedNodes().contains(n02), false)
        XCTAssertEqual(n20.connectedNodes().contains(n12), false)
        XCTAssertEqual(n20.connectedNodes().contains(n22), false)
        XCTAssertEqual(n01.connectedNodes().contains(n00), true)
        XCTAssertEqual(n01.connectedNodes().contains(n10), true)
        XCTAssertEqual(n01.connectedNodes().contains(n20), false)
        XCTAssertEqual(n01.connectedNodes().contains(n01), false)
        XCTAssertEqual(n01.connectedNodes().contains(n11), true)
        XCTAssertEqual(n01.connectedNodes().contains(n21), false)
        XCTAssertEqual(n01.connectedNodes().contains(n02), true)
        XCTAssertEqual(n01.connectedNodes().contains(n12), true)
        XCTAssertEqual(n01.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n11.connectedNodes().contains(n00), true)
        XCTAssertEqual(n11.connectedNodes().contains(n10), true)
        XCTAssertEqual(n11.connectedNodes().contains(n20), true)
        XCTAssertEqual(n11.connectedNodes().contains(n01), true)
        XCTAssertEqual(n11.connectedNodes().contains(n11), false)
        XCTAssertEqual(n11.connectedNodes().contains(n21), true)
        XCTAssertEqual(n11.connectedNodes().contains(n02), true)
        XCTAssertEqual(n11.connectedNodes().contains(n12), true)
        XCTAssertEqual(n11.connectedNodes().contains(n22), true)
        XCTAssertEqual(n21.connectedNodes().contains(n00), false)
        XCTAssertEqual(n21.connectedNodes().contains(n10), true)
        XCTAssertEqual(n21.connectedNodes().contains(n20), true)
        XCTAssertEqual(n21.connectedNodes().contains(n01), false)
        XCTAssertEqual(n21.connectedNodes().contains(n11), true)
        XCTAssertEqual(n21.connectedNodes().contains(n21), false)
        XCTAssertEqual(n21.connectedNodes().contains(n02), false)
        XCTAssertEqual(n21.connectedNodes().contains(n12), true)
        XCTAssertEqual(n21.connectedNodes().contains(n22), true)
        XCTAssertEqual(n02.connectedNodes().contains(n00), false)
        XCTAssertEqual(n02.connectedNodes().contains(n10), false)
        XCTAssertEqual(n02.connectedNodes().contains(n20), false)
        XCTAssertEqual(n02.connectedNodes().contains(n01), true)
        XCTAssertEqual(n02.connectedNodes().contains(n11), true)
        XCTAssertEqual(n02.connectedNodes().contains(n21), false)
        XCTAssertEqual(n02.connectedNodes().contains(n02), false)
        XCTAssertEqual(n02.connectedNodes().contains(n12), true)
        XCTAssertEqual(n02.connectedNodes().contains(n22), false)
        
        XCTAssertEqual(n12.connectedNodes().contains(n00), false)
        XCTAssertEqual(n12.connectedNodes().contains(n10), false)
        XCTAssertEqual(n12.connectedNodes().contains(n20), false)
        XCTAssertEqual(n12.connectedNodes().contains(n01), true)
        XCTAssertEqual(n12.connectedNodes().contains(n11), true)
        XCTAssertEqual(n12.connectedNodes().contains(n21), true)
        XCTAssertEqual(n12.connectedNodes().contains(n02), true)
        XCTAssertEqual(n12.connectedNodes().contains(n12), false)
        XCTAssertEqual(n12.connectedNodes().contains(n22), true)
        XCTAssertEqual(n22.connectedNodes().contains(n00), false)
        XCTAssertEqual(n22.connectedNodes().contains(n10), false)
        XCTAssertEqual(n22.connectedNodes().contains(n20), false)
        XCTAssertEqual(n22.connectedNodes().contains(n01), false)
        XCTAssertEqual(n22.connectedNodes().contains(n11), true)
        XCTAssertEqual(n22.connectedNodes().contains(n21), true)
        XCTAssertEqual(n22.connectedNodes().contains(n02), false)
        XCTAssertEqual(n22.connectedNodes().contains(n12), true)
        XCTAssertEqual(n22.connectedNodes().contains(n22), false)
    }
    
    func testGridGraphConnectAdjacentNodes() {
        // This is kind of a silly-ish test, because -connectAdjacentNodes is used heavily within
        // the grid graph initializer, but I'm including it for clarity's sake.
        var graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: 3, height: 3, diagonalsAllowed: false)
        var extraNode = JLFGKGridGraphNode(gridPosition: [1, 1])
        graph.connectNode(toAdjacentNodes: extraNode)
        var n00: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 0])!
        var n01: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 1])!
        var n02: JLFGKGridGraphNode = graph.node(atGridPosition: [0, 2])!
        var n10: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 0])!
        var n11: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 1])!
        var n12: JLFGKGridGraphNode = graph.node(atGridPosition: [1, 2])!
        var n20: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 0])!
        var n21: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 1])!
        var n22: JLFGKGridGraphNode = graph.node(atGridPosition: [2, 2])!
        XCTAssertEqual(extraNode.connectedNodes().contains(n00), false)
        XCTAssertEqual(extraNode.connectedNodes().contains(n01), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n02), false)
        XCTAssertEqual(extraNode.connectedNodes().contains(n10), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n11), false)
        XCTAssertEqual(extraNode.connectedNodes().contains(n12), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n20), false)
        XCTAssertEqual(extraNode.connectedNodes().contains(n21), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n22), false)
        graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: 3, height: 3, diagonalsAllowed: true)
        extraNode = JLFGKGridGraphNode(gridPosition: [1, 1])
        graph.connectNode(toAdjacentNodes: extraNode)
        n00 = graph.node(atGridPosition: [0, 0])!
        n01 = graph.node(atGridPosition: [0, 1])!
        n02 = graph.node(atGridPosition: [0, 2])!
        n10 = graph.node(atGridPosition: [1, 0])!
        n11 = graph.node(atGridPosition: [1, 1])!
        n12 = graph.node(atGridPosition: [1, 2])!
        n20 = graph.node(atGridPosition: [2, 0])!
        n21 = graph.node(atGridPosition: [2, 1])!
        n22 = graph.node(atGridPosition: [2, 2])!
        XCTAssertEqual(extraNode.connectedNodes().contains(n00), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n01), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n02), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n10), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n11), false)
        XCTAssertEqual(extraNode.connectedNodes().contains(n12), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n20), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n21), true)
        XCTAssertEqual(extraNode.connectedNodes().contains(n22), true)
    }
    
    func testGridGraphFindPathNoDiagonals() {
        // The map being tested. 0s are clear space, 1s are walls, 5 is the start point, 9 the end,
        // 2s the expected path.
        let mapWidth: Int = 10
        let mapHeight: Int = 10
        let map: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 1, 2, 0, 0, 0, 0, 0, 0, 2, 1, 0, 2, 0, 0, 0, 0, 0, 2, 2, 1, 0, 2, 0, 0, 0, 0, 0, 2, 1, 0, 0, 2, 0, 0, 0, 0, 0, 2, 2, 1, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 1, 9, 0, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]
        let graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: mapWidth, height: mapHeight, diagonalsAllowed: false)
        let start: JLFGKGridGraphNode = graph.node(atGridPosition: [4, 8])!
        let goal: JLFGKGridGraphNode = graph.node(atGridPosition: [7, 7])!
        var walls = [JLFGKGridGraphNode]()
        for y in 0..<mapHeight {
            for x in 0..<mapWidth {
                let idx: Int = x + (y * mapWidth)
                if map[idx] == 1 {
                    walls.append(graph.node(atGridPosition: [Int32(x), Int32(y)])!)
                }
            }
        }
        graph.removeNodes(walls)
        let path: [JLFGKGraphNode] = graph.findPath(from: start, to: goal)! 
        XCTAssertNotNil(path)
        XCTAssertEqual(start, path[0])
        var step: JLFGKGraphNode? = graph.node(atGridPosition: [4, 7])
        XCTAssertEqual(step, path[1])
        step = graph.node(atGridPosition: [4, 6])
        XCTAssertEqual(step, path[2])
        step = graph.node(atGridPosition: [3, 6])
        XCTAssertEqual(step, path[3])
        step = graph.node(atGridPosition: [3, 5])
        XCTAssertEqual(step, path[4])
        step = graph.node(atGridPosition: [3, 4])
        XCTAssertEqual(step, path[5])
        step = graph.node(atGridPosition: [4, 4])
        XCTAssertEqual(step, path[6])
        step = graph.node(atGridPosition: [4, 3])
        XCTAssertEqual(step, path[7])
        step = graph.node(atGridPosition: [4, 2])
        XCTAssertEqual(step, path[8])
        step = graph.node(atGridPosition: [5, 2])
        XCTAssertEqual(step, path[9])
        step = graph.node(atGridPosition: [5, 1])
        XCTAssertEqual(step, path[10])
        step = graph.node(atGridPosition: [6, 1])
        XCTAssertEqual(step, path[11])
        step = graph.node(atGridPosition: [7, 1])
        XCTAssertEqual(step, path[12])
        step = graph.node(atGridPosition: [7, 2])
        XCTAssertEqual(step, path[13])
        step = graph.node(atGridPosition: [7, 3])
        XCTAssertEqual(step, path[14])
        step = graph.node(atGridPosition: [7, 4])
        XCTAssertEqual(step, path[15])
        step = graph.node(atGridPosition: [7, 5])
        XCTAssertEqual(step, path[16])
        step = graph.node(atGridPosition: [7, 6])
        XCTAssertEqual(step, path[17])
        XCTAssertEqual(goal, path.last)
    }
    
    func testGridGraphFindPathWithDiagonals() {
        // The map being tested. 0s are clear space, 1s are walls, 5 is the start point, 9 the end,
        // 2s the expected path.
        let mapWidth: Int = 10
        let mapHeight: Int = 10
        let map: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 9, 0, 0, 0, 0, 0, 0, 5, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]
        let graph = JLFGKGridGraph.fromGridStarting(at: [0, 0], width: mapWidth, height: mapHeight, diagonalsAllowed: true)
        let start: JLFGKGridGraphNode = graph.node(atGridPosition: [4, 8])!
        let goal: JLFGKGridGraphNode = graph.node(atGridPosition: [7, 7])!
        var walls = [JLFGKGridGraphNode]()
        for y in 0..<mapHeight {
            for x in 0..<mapWidth {
                let idx: Int = x + (y * mapWidth)
                if map[idx] == 1 {
                    walls.append(graph.node(atGridPosition: [Int32(x), Int32(y)])!)
                }
            }
        }
        graph.removeNodes(walls)
        let path: [JLFGKGridGraphNode] = graph.findPath(from: start, to: goal) as! [JLFGKGridGraphNode]
        XCTAssertNotNil(path)
        XCTAssertEqual(start, path[0])
        var step: JLFGKGridGraphNode? = graph.node(atGridPosition: [5, 7])
        XCTAssertEqual(step, path[1])
        step = graph.node(atGridPosition: [6, 6])
        XCTAssertEqual(step, path[2])
        XCTAssertEqual(goal, path.last)
    }
}
