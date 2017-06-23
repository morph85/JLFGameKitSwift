//
//  JLFGKRandomSource.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKRandomSource: NSObject, JLFGKRandom, NSCopying, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    static let sharedRandom: JLFGKRandomSource = {
        JLFGKSystemRandomSource()
    }()
    
//    static func sharedRandom() -> JLFGKRandomSource {
//        var systemRandom: JLFGKSystemRandomSource? = nil
//        var onceToken: Int
//        if (onceToken == 0) {
//            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
//            systemRandom = JLFGKSystemRandomSource()
//        }
//        onceToken = 1
//        return systemRandom!
//    }
    
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        // This particular class doesn't have any state to decode.
        super.init()
    }
    
    func nextInt() -> Int {
        assert(false, "JLFGKRandomSource does not implement -nextInt: use one of its subclasses instead.")
        return 4
    }
    
    func nextInt(withUpperBound upperBound: Int) -> Int {
        assert(false, "JLFGKRandomSource does not implement -nextIntWithUpperBound: use one of its subclasses instead.")
        return 4
    }
    
    func nextUniform() -> Float {
        return Float(nextInt(withUpperBound: Int(INT32_MAX))) / Float(INT32_MAX)
    }
    
    func nextBool() -> Bool {
        return nextInt(withUpperBound: 1) == 1
    }
    
    func arrayByShufflingObjects(inArrays array: [Any]) -> [Any] {
        let copy: NSMutableArray = NSMutableArray(array: array)
        let count: Int = copy.count
        for i in 0..<count {
            let other = nextInt(withUpperBound: count)
            copy.exchangeObject(at: i, withObjectAt: other)
        }
        return copy.objectEnumerator().allObjects
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let source = JLFGKRandomSource()
        return source
    }
    
    //public func copy(with zone: NSZone? = nil) -> Any
    
    func encode(with aCoder: NSCoder) {
        // This particular random source class doesn't have any state to persist.
    }
}
