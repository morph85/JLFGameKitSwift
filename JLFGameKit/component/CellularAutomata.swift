//
//  CellularAutomata.swift
//  JLFGameKit
//
//  Ported by morph85 on 22/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

typealias CellularAutomataGenerationRule = (_: Int) -> Bool

class CellularAutomata: NSObject {
    private(set) var width: Int = 0
    private(set) var height: Int = 0
    private(set) var cells = [Bool]()
    
    static func automata(width: Int, height: Int) -> CellularAutomata {
        return CellularAutomata(width: width, height: height)
    }
    
    class func randomlyFilledCellularAutomata(width: Int, height: Int, percentFilled: Float) -> CellularAutomata {
        let automata = CellularAutomata(width: width, height: height)
        let numCells: Int = width * height
        for i in 0..<numCells {
            let chance: Float = Float(arc4random_uniform(1000)) / 1000.0
            if chance < percentFilled {
                automata.cells[i] = true
            }
        }
        return automata
    }
    
    init(width: Int, height: Int) {
        assert(width > 0, "CellularAutomata -initWithWidth:height: Doesn't work with width < 1.")
        assert(height > 0, "CellularAutomata -initWithWidth:height: Doesn't work with height < 1.")
        super.init()
        self.width = width
        self.height = height
        //isCells = calloc(MemoryLayout<Bool>.size, width * height)
        for _ in 0 ..< (width * height) {
            cells.append(false)
        }
    }
    
    func nextGeneration(with rule: CellularAutomataGenerationRule) -> CellularAutomata {
        //assert(rule != nil, "CellularAutomata -nextGenerationWithRule: Rule cannot be nil.")
        let next = CellularAutomata(width: width, height: height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let numNeighbors: Int = countNeighborsOfCellAt(x: x, y: y)
                if rule(numNeighbors) {
                    next.cells[x + y * width] = true
                }
            }
        }
        return next
    }
    
    func cellIsWallAt(x: Int, y: Int) -> Bool {
        if x >= width || x < 0 {
            return true
        }
        if y >= height || y < 0 {
            return true
        }
        return cells[x + y * width] != false
    }
    
    func countNeighborsOfCellAt(x: Int, y: Int) -> Int {
        var numNeighbors: Int = 0
        if cellIsWallAt(x: x - 1, y: y - 1) { numNeighbors += 1 }
        if cellIsWallAt(x: x,     y: y - 1) { numNeighbors += 1 }
        if cellIsWallAt(x: x + 1, y: y - 1) { numNeighbors += 1 }
        if cellIsWallAt(x: x - 1, y: y)     { numNeighbors += 1 }
        if cellIsWallAt(x: x + 1, y: y)     { numNeighbors += 1 }
        if cellIsWallAt(x: x - 1, y: y + 1) { numNeighbors += 1 }
        if cellIsWallAt(x: x,     y: y + 1) { numNeighbors += 1 }
        if cellIsWallAt(x: x + 1, y: y + 1) { numNeighbors += 1 }
        return numNeighbors
    }
}
