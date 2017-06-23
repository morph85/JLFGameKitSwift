//
//  JLFGKEntity.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKEntity: NSObject {
    var componentMap: NSMapTable<NSString, JLFGKComponent>!
    
    static func entity() -> JLFGKEntity {
        let entity = JLFGKEntity()
        return entity
    }
    
    override init() {
        super.init()
        //componentMap = NSMapTable(keyOptions: NSMapTableObjectPointerPersonality, valueOptions: NSMapTableStrongMemory)
        componentMap = NSMapTable(keyOptions: NSMapTableStrongMemory, valueOptions: NSMapTableStrongMemory)
    }
    
    func components() -> [JLFGKComponent] {
        return Array(componentMap.objectEnumerator()!) as! [JLFGKComponent]
    }
    
    func component(for componentClass: AnyClass) -> JLFGKComponent? {
//        print("-- start enumerate: \(componentClass) --")
//        let components = self.components()
//        for component in components {
//            print("com: \(component)")
//        }
//        let keys = componentMap.keyEnumerator()
//        for key in keys {
//            print("key: \(key)")
//        }
        
        let key = className(forClass: componentClass)
//        print("key key: \(key)")
        return componentMap.object(forKey: key)
    }
    
    func add(_ component: JLFGKComponent) {
        component.entity = self
        let key = className(forObject:component)
        componentMap.setObject(component, forKey: key)
    }
    
    func removeComponent(for componentClass: AnyClass) {
        let key = className(forClass: componentClass)
        let component: JLFGKComponent? = componentMap.object(forKey: key)
        component?.entity = nil
        componentMap.removeObject(forKey: key)
    }
    
    func update(withDeltaTime seconds: TimeInterval) {
        // Making a copy of the components before iterating over it just in case some component decides
        // to add or remove components during the updateWithDeltaTime call.
        let componentsCopy: [JLFGKComponent] = components()
        for component: JLFGKComponent in componentsCopy {
            component.update(withDeltaTime: seconds)
        }
    }
}
