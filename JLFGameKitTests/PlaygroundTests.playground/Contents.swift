//: Playground - noun: a place where people can play

import UIKit

class BasicClass {
    static func instance() -> BasicClass {
        return (self).init()
    }
    static func name() -> String {
        return String(describing: self)
    }
    static func name(by instance: BasicClass) -> String {
        return String(describing: type(of: instance))
    }
    required init() {
    }
}

class InheritedClass: BasicClass {
}

var basicInstance: AnyObject
var inheritedInstance: AnyObject

basicInstance = BasicClass()
inheritedInstance = InheritedClass()

var passingClass: AnyClass
var passingInstance: AnyObject

passingClass = InheritedClass.self
passingInstance = basicInstance

// print basic class instance info
print("-- basic type --")
print(String(describing:type(of:basicInstance)))
print(String(describing:type(of:basicInstance.self)))
print(String(describing:type(of:BasicClass.self))) // note: self used for class only

// print instance class
print("-- inherited type --")
print(String(describing:inheritedInstance)) // x
print(String(describing:inheritedInstance.self)) // x
print(String(describing:type(of:inheritedInstance.self)))

// print passing class as parameter (do not use type of)
print(String(describing:passingClass))

// check type of class
print("-- basic instance --")
print(basicInstance is BasicClass)
print(basicInstance is InheritedClass)
print(inheritedInstance is BasicClass)
print(inheritedInstance is InheritedClass)

print("-- passing instance --")
//print(inheritedInstance.self == basicInstance.self)
print(inheritedInstance === basicInstance.self)
print(passingInstance === basicInstance.self)
print(passingInstance === inheritedInstance.self)

print("-- inheritance technique --")
print(BasicClass.name())
print(InheritedClass.name())
print(InheritedClass.instance())
print(InheritedClass.name(by: InheritedClass.instance()))
print(BasicClass.name(by: InheritedClass.instance()))

