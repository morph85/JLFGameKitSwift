//
//  PriorityQueueTests.swift
//  JLFGameKit
//
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
@testable import JLFGameKit

class PriorityQueueTests: XCTestCase {
    
    func testCountIsCorrect() {
        let queue = JLFGKSimplePriorityQueue()
        let one = NSObject()
        let two = NSObject()
        let three = NSObject()
        queue.insert(two, withPriority: 2.0)
        queue.insert(one, withPriority: 1.0)
        queue.insert(three, withPriority: 3.0)
        XCTAssertEqual(queue.count(), 3)
    }
    
    func testInsertsAreOrderedProperly() {
        let queue = JLFGKSimplePriorityQueue()
        let one = NSObject()
        let two = NSObject()
        let three = NSObject()
        queue.insert(two, withPriority: 2.0)
        queue.insert(one, withPriority: 1.0)
        queue.insert(three, withPriority: 3.0)
        XCTAssertEqual(queue.get() === one, true)
        XCTAssertEqual(queue.get() === two, true)
        XCTAssertEqual(queue.get() === three, true)
    }
    
    func testCanRetrievePriorities() {
        let queue = JLFGKSimplePriorityQueue()
        let one = NSObject()
        let two = NSObject()
        let three = NSObject()
        queue.insert(two, withPriority: 2.0)
        queue.insert(one, withPriority: 1.0)
        queue.insert(three, withPriority: 3.0)
        XCTAssertEqual(queue.priority(for: one), 1.0)
        XCTAssertEqual(queue.priority(for: two), 2.0)
        XCTAssertEqual(queue.priority(for: three), 3.0)
    }
    
    func testCanUpdatePriorities() {
        let queue = JLFGKSimplePriorityQueue()
        let one = NSObject()
        let two = NSObject()
        let three = NSObject()
        queue.insert(two, withPriority: 2.0)
        queue.insert(one, withPriority: 1.0)
        queue.insert(three, withPriority: 3.0)
        XCTAssertEqual(queue.count(), 3)
        queue.insert(one, withPriority: 4.0)
        XCTAssertEqual(queue.count(), 3)
        XCTAssertEqual(queue.priority(for: one), 4.0)
        XCTAssertEqual(queue.get() === two, true)
        XCTAssertEqual(queue.get() === three, true)
        XCTAssertEqual(queue.get() === one, true)
    }
}
