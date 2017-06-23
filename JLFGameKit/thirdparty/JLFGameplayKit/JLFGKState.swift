//
//  JLFGKState.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKState: NSObject {
    //private(set) weak var stateMachine: JLFGKStateMachine
    var stateMachine: JLFGKStateMachine?
    
//    static func state() -> JLFGKState {
//        return JLFGKState()
//    }
    
    static func state() -> JLFGKState {
        return (self).init()
    }
    
    static func name() -> NSString {
        return String(describing: self) as NSString
    }
    
    required override init() {
        super.init()
    }
    
    func isValidNextState(_ stateClass: NSString) -> Bool {
        return true
    }
    
    func didEnter(withPreviousState previousState: JLFGKState?) {
        // nop
    }
    
    func willExit(withNextState nextState: JLFGKState) {
        // nop
    }
    
    func update(withDeltaTime seconds: CFTimeInterval) {
        // nop
    }
}
