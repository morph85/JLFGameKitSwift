//
//  JLFGKStateMachine.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

func className(fromState state: JLFGKState) -> NSString {
    let name = String(describing: type(of: state.self)) as NSString
    //print("-->> get class name from: \(name)")
    return name
}

class JLFGKStateMachine: NSObject {
    private(set) var currentState: JLFGKState?
    var states: NSMapTable<NSString, JLFGKState>
    
    static func stateMachineWith(states: [JLFGKState]) -> JLFGKStateMachine {
        return JLFGKStateMachine(states: states)
    }
    
    /**
     * The states used in the state machine must all be subclasses of JLFGKState, and must
     * all be unique. This function ensures that, and throws an NSAssertionException if it's
     * not true.
     */
    class func ensureClassesAreStatesAndUnique(_ states: [JLFGKState]) {
        //let statesTable = NSHashTable<NSString>(options: NSHashTableObjectPointerPersonality)
        let statesTable = NSHashTable<NSString>(options: NSHashTableStrongMemory)
        for obj: JLFGKState in states {
            let name = className(fromState: obj.self)
            //assert((obj is JLFGKState), "\(class_getName(obj.self)) is not a subclass of JLFGKState.")
            assert(!statesTable.contains(name), "State class \(className(fromState:obj.self)) was present more than once in the states array.")
//            if (!statesTable.contains(name)) {
//                let error = ErrorBase(code: 100, localizedTitle: "fatal error", localizedDescription: "State class \(className(fromState:obj.self)) was present more than once in the states array.")
//                throw error
//            }
            statesTable.add(name)
        }
    }
    
    init(states: [JLFGKState]) {
        assert(states.count > 0, "Can't create a JLFGKStateMachine with an empty states array.")
        JLFGKStateMachine.ensureClassesAreStatesAndUnique(states)
        //self.states = NSMapTable(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableStrongMemory)
        self.states = NSMapTable(keyOptions: NSMapTableStrongMemory, valueOptions: NSMapTableStrongMemory)
        super.init()
        for state: JLFGKState in states {
            state.stateMachine = self
            self.states.setObject(state, forKey: className(fromState: state.self))
            //self.states[className(fromState: state.self) as! NSString] = state
        }
    }
    
    convenience override init() {
        assert(false, "JLFGKStateMachine must be initialized using -initWithStates:")
        self.init()
    }
    
    func canEnterState(_ stateClass: NSString) -> Bool {
        // Can't switch to a state that isn't present in self.states
        if states.object(forKey: stateClass) == nil {
            return false
        }
        // If there's not already a current state set, then of course we can enter it.
        if currentState == nil {
            return true
        } else {
            // Otherwise, ask the current state if it's allowed.
            return currentState!.isValidNextState(stateClass)
        }
    }
    
    func enterState(_ stateClass: NSString) -> Bool {
        if canEnterState(stateClass) == false {
            return false
        }
        let previousState: JLFGKState? = currentState
        let nextState: JLFGKState? = (states.object(forKey: stateClass))
        if (previousState != nil) {
            previousState?.willExit(withNextState: nextState!)
        }
        currentState = nextState
        currentState?.didEnter(withPreviousState: previousState)
        return true
    }
    
    func state(for stateClass: NSString) -> JLFGKState? {
        return states.object(forKey: stateClass)
    }
    
    func update(withDeltaTime seconds: CFTimeInterval) {
        currentState?.update(withDeltaTime: seconds)
    }
}
