//
//  Node.swift
//  AStar
//
//  Created by Evan Cedeno on 11/25/24.
//

import Foundation

// Node that represents one cell in a grid
class Node: Hashable {
    private var x: Int
    private var y: Int
    private var g: Float
    private var h: Float
    private var f: Float
    private var parent: Node?
    private var barrier: Bool = false
    
    init(x: Int, y: Int, g: Float, h: Float, parent: Node? = nil) {
        self.x = x
        self.y = y
        self.g = g
        self.h = h
        self.f = g + h
        self.parent = parent
    }
    
    init() {
        self.x = 0
        self.y = 0
        self.g = 0
        self.h = 0
        self.f = 0
        self.parent = nil
    }
    
    //MARK: Getter Methods
    
    public func getG() -> Float {
        return g
    }
    
    public func getH() -> Float {
        return h
    }
    
    public func getF() -> Float {
        return f
    }
    
    public func getParent() -> Node? {
        return parent
    }
    
    public func getX() -> Int {
        return x
    }
    
    public func getY() -> Int {
        return y
    }
    
    public func getLoc() -> (Int, Int) {
        return (x, y)
    }
    
    public func isBarrier() -> Bool {
        return barrier
    }
    
    //MARK: Setter Methods
    
    public func setParent(_ parent: Node) {
        self.parent = parent
    }
    
    public func setG(_ g: Float) {
        self.g = g
        self.f = self.g + self.h
    }
    
    public func setH(_ h: Float) {
        self.h = h
        self.f = self.g + self.h
    }
    
    public func setBarrier(_ barrier: Bool) {
        self.barrier = barrier
    }
    
    //MARK: Hashable methods
    static func == (lhs: Node, rhs: Node) -> Bool {
            ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
        }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }
    
}
