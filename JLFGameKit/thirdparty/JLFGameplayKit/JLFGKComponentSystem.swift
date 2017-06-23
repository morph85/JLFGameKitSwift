//
//  JLFGKComponentSystem.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import ObjectiveC;

class JLFGKComponentSystem: NSObject {
    var componentClass: AnyClass
    var componentArray = [JLFGKComponent]()
    
    init(componentClass: AnyClass) {
        self.componentClass = componentClass
        super.init()
        componentArray = [JLFGKComponent]()
    }
    
    func components() -> [JLFGKComponent] {
        return componentArray
    }
    
    func addComponent(_ component: JLFGKComponent) {
        assert(className(forObject: component) == className(forClass: componentClass), "This JLFGKComponentSystem instance only accepts components of type \(componentClass)")
        // TODO: Should I be checking to make sure a component doesn't exist twice in the array?
        componentArray.append(component)
    }
    
    func addComponent(with entity: JLFGKEntity) {
        let component: JLFGKComponent? = entity.component(for: componentClass)
        if component != nil {
            addComponent(component!)
        }
    }
    
    func remove(_ component: JLFGKComponent) {
        componentArray.remove(at: componentArray.index(of: component)!)
    }
    
    func removeComponent(with entity: JLFGKEntity) {
        let component: JLFGKComponent? = entity.component(for: componentClass)
        if component != nil {
            componentArray.remove(at: componentArray.index(of: component!)!)
        }
    }
    
    func update(withDeltaTime seconds: TimeInterval) {
            // Making a copy of the components before iterating over it just in case some component decides
            // to add or remove components during the updateWithDeltaTime call.
        let components: [JLFGKComponent] = componentArray
        for component: JLFGKComponent in components {
            component.update(withDeltaTime: seconds)
        }
    }

    func object(atIndexedSubscript idx: Int) -> JLFGKComponent {
        return componentArray[idx]
    }
}
