//
//  PriorityQueue.swift
//  AStar
//
//  Created by Evan Cedeno on 11/25/24.
//

import Foundation

// Priority Queue built off of a min heap
class PriorityQueue {
    private var heap: Heap
    
    init() {
        self.heap = Heap()
    }
    
    public func enqueue(_ node: Node) {
        heap.insert(node)
    }
    
    public func dequeue() -> Node? {
        return heap.delete()
    }
    
    public func isEmpty() -> Bool {
        return heap.size() == 0
    }
    
    public func size() -> Int {
        return heap.size()
    }
    
    public func printQueue() {
        heap.printHeap()
    }
    
    public func contains(_ node: Node) -> Bool {
        return heap.contains(node)
    }
    
    public func nodeIndex(_ node: Node) -> Int? {
        return heap.indexOfNode(node)
    }
    
    public func updatePriority(_ node: Node, increase: Bool) {
        // if value increased, heapify down
        // if value decreased heapify up
        let index = heap.indexOfNode(node)
        
        if increase {
            heap.heapifyDown(index)
        }
        else {
            heap.heapifyUp(index)
        }
    }
    
}
