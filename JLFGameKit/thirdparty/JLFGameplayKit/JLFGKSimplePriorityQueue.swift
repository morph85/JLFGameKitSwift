//
//  JLFGKSimplePriorityQueue.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

// Gosh, I don't like this having to be an object, but ARC forbids pointers to objective-c
// objects in structs. :-/
class PriorityQueueEntry: NSObject {
    weak var obj: AnyObject?
    var priority: Float = 0.0
    
    convenience init(obj: AnyObject?, priority: Float) {
        self.init()
        self.obj = obj
        self.priority = priority
    }
}

class JLFGKSimplePriorityQueue: NSObject {
    var entries = [PriorityQueueEntry]()
    
    override init() {
        super.init()
        entries = [PriorityQueueEntry]()
    }
    
    func count() -> Int {
        return entries.count
    }
    
    func insert(_ obj: AnyObject?, withPriority priority: Float) {
        assert(obj != nil, "JLFGKSimplePriorityQueue -insertObject:withPriority: Cannot insert a nil object!")
        // Easy case: is the array empty? If so, just stick this in there and be done.
        var numEntries: Int = entries.count
        if numEntries == 0 {
            entries.append(PriorityQueueEntry(obj: obj, priority: priority))
            return
        }
        // Does this object currently exist in the entry set? If so, remove it first.
        for i in 0..<numEntries {
            let entry: PriorityQueueEntry? = entries[i]
            if entry?.obj === obj {
                entries.remove(at: i)
                numEntries -= 1
                // We just pulled one out.
                break
            }
        }
        // Now find the right spot to insert the object and do it.
        var currentIndex: Int = 0
        while currentIndex < numEntries {
            let currentPriority: Float = (entries[currentIndex] as? AnyObject)?.priority ?? 0
            if priority < currentPriority {
                entries.insert(PriorityQueueEntry(obj: obj, priority: priority) , at: currentIndex)
                break
            }
            currentIndex += 1
        }
        // If we ran all the way through the loop, this object goes at the end.
        if currentIndex == numEntries {
            entries.append(PriorityQueueEntry(obj: obj, priority: priority))
        }
    }
    
    func priority(for obj: AnyObject) -> Float {
        for entry in entries {
            if (entry).obj === obj {
                return (entry ).priority
            }
        }
        return Float.greatestFiniteMagnitude
    }
    
    func peek() -> AnyObject? {
        if entries.count > 0 {
            let entry: PriorityQueueEntry? = entries[0]
            return entry?.obj!
        }
        else {
            return nil
        }
    }
    
    func get() -> AnyObject? {
        if entries.count > 0 {
            let entry: PriorityQueueEntry? = entries[0]
            entries.remove(at: 0)
            return entry?.obj!
        }
        else {
            return nil
        }
    }
}
