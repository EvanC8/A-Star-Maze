//
//  Algorithm.swift
//  AStar
//
//  Created by Evan Cedeno on 11/25/24.
//

import Foundation

// AStar algorithm
// Finds shortest path between two points with obstacles
class AStar {
    var openSet: PriorityQueue
    var closedSet: Set<Node>
    
    var grid: [[Node]]
    var width: Int
    var height: Int
    
    var A: Node = Node()
    var B: Node = Node()
    
    init(gridSize: (Int, Int), A: (Int, Int), B: (Int, Int)) {
        self.openSet = PriorityQueue()
        self.closedSet = []
        
        self.width = gridSize.0
        self.height = gridSize.1
        
        self.grid = [[Node]](repeating: [Node](repeating: Node(), count: width), count: height)
        self.grid = (0..<height).map { j in (0..<width).map { i in Node(x: i, y: j, g: 5000, h: 0) } }
        
        self.A = grid[A.1][A.0]
        self.A.setG(0)
        self.B = grid[B.1][B.0]
        
        openSet.enqueue(self.A)
    }
    
    public func insertBarrier(_ loc: (Int, Int)) {
        grid[loc.1][loc.0].setBarrier(true)
    }
    
    public func findPath() -> [(Int, Int)] {
        return main()
    }
    
    private func main() -> [(Int, Int)] {
        var current: Node = Node()
        
        // Loop until we reach destination node or open set contains no more nodes (no paths to destination)
        while true {
            // Check if open set is empty
            if openSet.isEmpty() { print("No path found"); return [] }
            
            // Set current node to be most promising node
            current = openSet.dequeue()!
            
            // Check if current node is goal node
            if (current === B) { break }
            
            // Mark current node as checked
            closedSet.insert(current)
            
            // Check neighbor paths
            let neighbors = getNeighbors(current)
            for n in neighbors {
                // Calculate tentative G value
                let tentativeG = current.getG() + 1
                
                // Check if tentative G shows faster path than neighbor's current G
                if tentativeG >= n.getG() { continue }
                
                // Set the parent to be current node
                n.setParent(current)
                
                // Hold onto old F value
                let oldF = n.getF()
                // Set neighbor's new F value
                n.setG(tentativeG)
                n.setH(findH(n))
                
                // Favor fastest paths that maintain direction of motion
                if (current.getParent() != nil) {
                    if current.getParent()!.getX() == current.getX() {
                        if current.getX() != n.getX() {
                            n.setG(n.getG() + 0.0001)
                        }
                    }
                    else if (current.getParent()!.getY() == current.getY()) {
                        if current.getY() != n.getY() {
                            n.setG(n.getG() + 0.0001)
                        }
                    }
                }
                
                if !openSet.contains(n) {
                    // Add node to open set if not already
                    openSet.enqueue(n)
                } else {
                    if oldF != n.getF() {
                        // Update node and update heap queue
                        openSet.updatePriority(n, increase: oldF < n.getF())
                    }
                }
            }
        }
        
        // Path found, retrace steps back to start
        print("Path found")
        return reconstructPath(self.B)
    }
    
    
    
    private func reconstructPath(_ node: Node) -> [(Int, Int)] {
        var pathVisualizer = [[String]](repeating: [String](repeating: "-", count: width), count: height)
        pathVisualizer[A.getY()][A.getX()] = "A"
        pathVisualizer[B.getY()][B.getX()] = "B"
        
        var current = B
        while current.getParent() != nil && current.getParent() !== A {
            current = current.getParent()!
            pathVisualizer[current.getY()][current.getX()] = "O"
        }
        
        for y in 0..<height {
            var row = ""
            for x in 0..<width {
                if grid[y][x].isBarrier() { row.append("X ") }
                else { row.append(pathVisualizer[y][x] + " ") }
            }
            print(row)
        }
        
        var nodes: [(Int, Int)] = []
        var currentNode = B
        while currentNode.getParent() != nil && currentNode.getParent() !== A {
            currentNode = currentNode.getParent()!
            nodes.insert((currentNode.getX(), currentNode.getY()), at: 0)
        }
        
        return nodes
    }
    
    // Distance along current path from start point A
    private func findG(_ node: Node) -> Float {
        if node.getParent() == nil { return 0 }
        
        let parent: Node = node.getParent()!
        return parent.getG() + 1
    }
    
    // Manhattan Distance Heuristic
    private func findH(_ node: Node) -> Float {
        return Float(abs(node.getX() - B.getX()) + abs(node.getY() - B.getY()))
    }
    
    private func getNeighbors(_ node: Node) -> [Node] {
        let loc = node.getLoc()
        let neighborLocs = [(0, 1), (0, -1), (-1, 0), (1, 0)]
        
        var neighbors: [Node] = []
        
        for n in neighborLocs {
            let nl = (loc.0 + n.0, loc.1 + n.1)
            if inBounds(nl.0, nl.1) {
                let neighbor = grid[nl.1][nl.0]
                if !neighbor.isBarrier() && neighbor !== node.getParent() && !closedSet.contains(where: { $0 === neighbor } ) {
                    neighbors.append(neighbor)
                }
            }
        }
        return neighbors
    }
    
    private func inBounds(_ x: Int, _ y: Int) -> Bool {
        return x >= 0 && x < width && y >= 0 && y < height
    }
    
}
