//
//  StateMachineTests.swift
//  JLFGameKit
//
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
@testable import JLFGameKit

/********************************************
 * The state graph used in these tests
 *
 * StateOne -----> StateTwo -----> State Three
 *     ^            |  ^                |
 *     |            |  |                |
 *     -------------|  |----------------|
 *
 * StateThree will set properties when it receives any of the lifecycle messages
 * so that we can make sure they were called.
 *
 * StateFour is a valid JLFGKStateClass, but isn't part of the state machine.
 *
 * And then a fake one that's just not a state: NotAState
 */

class StateOne: JLFGKState {
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        return stateClass == className(forClass: StateTwo.self)
    }
}

class StateTwo: JLFGKState {
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        return stateClass == className(forClass: StateOne.self) || stateClass == className(forClass: StateThree.self)
    }
}

class StateThree: JLFGKState {
    var isDidEnterStateCalled: Bool = false
    var isWillLeaveStateCalled: Bool = false
    var deltaTimeAtLastUpdate = CFTimeInterval()
    
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        return stateClass == className(forClass: StateTwo.self)
    }
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        isDidEnterStateCalled = true
    }
    
    override func willExit(withNextState nextState: JLFGKState) {
        isWillLeaveStateCalled = true
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        deltaTimeAtLastUpdate = seconds
    }
}

class StateFour: JLFGKState {
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        assert(false, "Should never reach this.")
        return true
    }
}

class NotAState: NSObject {
    func isValidNextState(_ stateClass: NSString) -> Bool {
        assert(false, "Should never reach this.")
        return true
    }
}

class StateMachineTests: XCTestCase {
    func testStateCreation() {
        // Making sure I got JLFGKState's +state method right.
        let baseClass = JLFGKState.state()
        XCTAssert(className(fromState: baseClass) == JLFGKState.name())
        let subClass: JLFGKState = StateOne.state()
        XCTAssertFalse(className(fromState: subClass) == JLFGKState.name())
        XCTAssert(className(fromState: subClass) == StateOne.name())
    }
    
    //func testEmptyStateMachineFails() {
    //    XCTAssertThrows(JLFGKStateMachine(states: []))
    //}
    
    //func testBadStateClassesFails() {
    //    XCTAssertThrows(try JLFGKStateMachine(states: [NSNumber(value: false)]))
    //}
    
    func testNormalStateMachineCreationSucceeds() {
        let states: [JLFGKState] = [StateOne.state(), StateTwo.state()]
        XCTAssertNoThrow(JLFGKStateMachine(states: states))
    }
    
    //func testNotUniqueStateClassesFails() {
    //    let states: [JLFGKState] = [StateOne.state(), StateOne.state()]
    //    XCTAssertThrows(JLFGKStateMachine(states: states))
    //}
    
    func testCanEnterInitialState() {
        let states: [JLFGKState] = [StateOne.state(), StateTwo.state()]
        let machine = JLFGKStateMachine(states: states)
        XCTAssert(machine.canEnterState(StateOne.name()))
        XCTAssert(machine.canEnterState(StateTwo.name()))
        XCTAssertFalse(machine.canEnterState(StateThree.name()))
    }
    
    func testRetrieveStates() {
        let stateOne = StateOne.state()
        let stateTwo = StateTwo.state()
        let stateThree = StateThree.state()
        let states: [JLFGKState] = [stateOne, stateTwo, stateThree]
        let machine = JLFGKStateMachine(states: states)
        XCTAssertEqual(stateOne, machine.state(for: StateOne.name()))
        XCTAssertEqual(stateTwo, machine.state(for: StateTwo.name()))
        XCTAssertEqual(stateThree, machine.state(for: StateThree.name()))
        XCTAssertNil(machine.state(for: StateFour.name()))
    }
    
    func testEnterInitialState() {
        let stateOne = StateOne.state()
        let stateTwo = StateTwo.state()
        let stateThree = StateThree.state()
        let states: [JLFGKState] = [stateOne, stateTwo, stateThree]
        let machine = JLFGKStateMachine(states: states)
        XCTAssert(machine.enterState(StateOne.name()))
        XCTAssertEqual(stateOne, machine.currentState)
    }
    
    func testEnterNextState() {
        let stateOne = StateOne.state()
        let stateTwo = StateTwo.state()
        let stateThree = StateThree.state()
        let states: [JLFGKState] = [stateOne, stateTwo, stateThree]
        let machine = JLFGKStateMachine(states: states)
        XCTAssert(machine.enterState(StateOne.name()))
        XCTAssertEqual(stateOne, machine.currentState)
        XCTAssert(machine.enterState(StateTwo.name()))
        XCTAssertEqual(stateTwo, machine.currentState)
    }
    
    func testCantEnterInvalidState() {
        let stateOne = StateOne.state()
        let stateTwo = StateTwo.state()
        let stateThree = StateThree.state()
        let states: [JLFGKState] = [stateOne, stateTwo, stateThree]
        let machine = JLFGKStateMachine(states: states)
        XCTAssert(machine.enterState(StateOne.name()))
        XCTAssertEqual(stateOne, machine.currentState)
        XCTAssertFalse(machine.enterState(StateThree.name()))
        XCTAssertEqual(stateOne, machine.currentState)
    }
    
    func testLifecycleMethods() {
        let stateOne = StateOne.state() as! StateOne
        let stateTwo = StateTwo.state() as! StateTwo
        let stateThree = StateThree.state() as! StateThree
        let states: [JLFGKState] = [stateOne, stateTwo, stateThree]
        let machine = JLFGKStateMachine(states: states)
        let _ = machine.enterState(StateThree.name())
        XCTAssert(stateThree.isDidEnterStateCalled)
        let seconds: CFTimeInterval = 0.6
        machine.update(withDeltaTime: seconds)
        XCTAssertEqual(stateThree.deltaTimeAtLastUpdate, seconds)
        let _ = machine.enterState(StateTwo.name())
        XCTAssert(stateThree.isWillLeaveStateCalled)
    }
    
    func testStateMachinePropertySet() {
        let stateOne = StateOne.state()
        let machine = JLFGKStateMachine(states: [stateOne])
        let _ = machine.enterState(StateOne.name())
        XCTAssertEqual(stateOne.stateMachine, machine)
    }
}
