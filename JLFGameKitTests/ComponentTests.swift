//
//  ComponentTests.swift
//  JLFGameKit
//
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
@testable import JLFGameKit

// not working
func XCTAssertThrows<T>(_ expression: @autoclosure () throws -> T, _ message: StaticString = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
        XCTFail("No error to catch! - \(message)", file: file, line: line)
    } catch {
    }
}

class TestComponent: JLFGKComponent {
    var value: Int = 0
    var isUpdateCalled: Bool = false
    
    override func update(withDeltaTime seconds: TimeInterval) {
        isUpdateCalled = true
    }
}

class SecondTestComponent: JLFGKComponent {
}

class UnrelatedComponent: NSObject {

}

class ComponentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddComponentsToEntity() {
        let entity = JLFGKEntity.entity()
        let component = JLFGKComponent()
        XCTAssertNil(component.entity)
        entity.add(component)
        XCTAssertEqual(entity, component.entity)
    }
    
    func testEntityCallsUpdate() {
        let entity = JLFGKEntity.entity()
        let component = TestComponent()
        entity.add(component)
        XCTAssertFalse(component.isUpdateCalled)
        entity.update(withDeltaTime: 1)
        XCTAssertTrue(component.isUpdateCalled)
    }
    
    func testComponentsAreReplacedInEntity() {
        let entity = JLFGKEntity.entity()
        let componentOne = TestComponent()
        componentOne.value = 1
        let componentTwo = TestComponent()
        componentTwo.value = 2
        entity.add(componentOne)
        entity.add(componentTwo)
        XCTAssertEqual(1, entity.components().count)
        let component = (entity.component(for: TestComponent.self))
        let value1:Int = componentTwo.value
        let value2:Int = (component as! TestComponent).value
        XCTAssertEqual(value1, value2)
    }
    
    func testEntityRemovesComponents() {
        let entity = JLFGKEntity.entity()
        let component = TestComponent()
        XCTAssertEqual(0, entity.components().count)
        entity.add(component)
        XCTAssertEqual(1, entity.components().count)
        entity.removeComponent(for: TestComponent.self)
        XCTAssertEqual(0, entity.components().count)
        XCTAssertNil(component.entity)
    }
    
    func testComponentSystemMustUseDesignatedInitializer() {
        //XCTAssertThrows(expression: JLFGKComponentSystem(componentClass: UnrelatedComponent.self))
    }
    
    func testComponentSystemOnlyAllowsOneTypeOfComponent() {
        let system = JLFGKComponentSystem(componentClass: TestComponent.self)
        XCTAssertNoThrow(system.addComponent(TestComponent()))
        //XCTAssertThrows(expression: system.addComponent(SecondTestComponent()))
    }
    
    func testComponentSystemClassIsCorrect() {
        let system = JLFGKComponentSystem(componentClass: TestComponent.self)
        //let component = TestComponent()
        XCTAssertEqual(String(describing: TestComponent.self), String(describing: system.componentClass))
        //XCTAssertEqual(component.self, system.componentClass as AnyClass)
    }
    
    func testComponentSystemAddComponents() {
        let system = JLFGKComponentSystem(componentClass: TestComponent.self)
        for _ in 0..<12 {
            system.addComponent(TestComponent())
        }
        XCTAssertEqual(12, system.components().count)
    }
    
    func testComponentSystemRemoveComponents() {
        let system = JLFGKComponentSystem(componentClass: TestComponent.self)
        let oneComponent = TestComponent()
        let twoComponent = TestComponent()
        let redComponent = TestComponent()
        let blueComponent = TestComponent()
        for c: JLFGKComponent in [oneComponent, twoComponent, redComponent, blueComponent] {
            system.addComponent(c)
        }
        XCTAssertEqual(4, system.components().count)
        XCTAssertTrue(system.components().contains(oneComponent))
        XCTAssertTrue(system.components().contains(twoComponent))
        XCTAssertTrue(system.components().contains(redComponent))
        XCTAssertTrue(system.components().contains(blueComponent))
        system.remove(redComponent)
        XCTAssertEqual(3, system.components().count)
        XCTAssertFalse(system.components().contains(redComponent))
    }
    
    func testComponentSystemAddRemoveWithEntity() {
        let system = JLFGKComponentSystem(componentClass: TestComponent.self)
        let entity = JLFGKEntity.entity()
        let component = TestComponent()
        entity.add(component)
        system.addComponent(with: entity)
        XCTAssertEqual(1, system.components().count)
        XCTAssertTrue(system.components().contains(component))
        system.removeComponent(with: entity)
        XCTAssertEqual(0, system.components().count)
        XCTAssertFalse(system.components().contains(component))
    }
}
