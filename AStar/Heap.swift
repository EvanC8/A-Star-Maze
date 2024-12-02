//
//  Heap.swift
//  AStar
//
//  Created by Evan Cedeno on 11/26/24.
//

// Min heap
import Foundation

class Heap {
    private var heap: [Node]
    
    init() {
        self.heap = []
    }
    
    public func contains(_ node: Node) -> Bool {
        if size() == 0 { return false }
        
        let index = locateNode(0, goalNode: node)
        
        return index == -1 ? false : true
    }
    
    public func indexOfNode(_ node: Node) -> Int {
        if size() == 0 { return -1 }
        
        let index = locateNode(0, goalNode: node)
        
        return index
    }
    
    private func locateNode(_ i: Int, goalNode: Node) -> Int {
        guard i < size() else { return -1 }
        
        let node = heap[i]
        
        if node === goalNode { return i }
        
        if goalNode.getF() < node.getF() { return -1 }
        
        if hasLeftChild(i) {
            let contains = locateNode(getLeftChildIndex(i), goalNode: goalNode)
            if contains != -1 { return contains }
        }
        
        if hasRightChild(i) {
            let contains = locateNode(getRightChildIndex(i), goalNode: goalNode)
            if contains != -1 { return contains }
        }
        
        return -1
    }
    
    public func size() -> Int {
        heap.count
    }
    
    public func insert(_ node: Node) {
        heap.append(node)
        heapifyUp(heap.count - 1)
    }
    
    public func heapifyUp(_ index: Int) {
        var i = index
        while hasParent(i) && parent(i).getF() > heap[i].getF() {
            swap(getParentIndex(i), i)
            i = getParentIndex(i)
        }
    }
    
    public func delete() -> Node? {
        if size() == 0 { return nil }
        
        let root = heap[0]
        heap.remove(at: 0)
        
        if size() > 0 {
            heap.insert(heap.removeLast(), at: 0)
            heapifyDown()
        }
        
        return root
    }
    
    public func heapifyDown(_ index: Int? = nil) {
        var i = index ?? 0
        while hasLeftChild(i) {
            var smallerChildIndex = getLeftChildIndex(i)
            if hasRightChild(i) && rightChild(i).getF() < leftChild(i).getF() {
                smallerChildIndex = getRightChildIndex(i)
            }
            if heap[i].getF() > heap[smallerChildIndex].getF() {
                swap(i, smallerChildIndex)
            } else {
                break
            }
            i = smallerChildIndex
        }
    }
    
    
    private func hasParent(_ index: Int) -> Bool {
        return getParentIndex(index) >= 0
    }
    
    private func parent(_ index: Int) -> Node {
        return heap[getParentIndex(index)]
    }
    
    private func getParentIndex(_ index: Int) -> Int {
        return (index - 1) / 2
    }
    
    private func hasLeftChild(_ index: Int) -> Bool {
        return getLeftChildIndex(index) < size()
    }
    
    private func hasRightChild(_ index: Int) -> Bool {
        return getRightChildIndex(index) < size()
    }
    
    private func leftChild(_ index: Int) -> Node {
        return heap[getLeftChildIndex(index)]
    }
    
    private func rightChild(_ index: Int) -> Node {
        return heap[getRightChildIndex(index)]
    }
    
    private func getLeftChildIndex(_ index: Int) -> Int {
        return 2 * index + 1
    }
    
    private func getRightChildIndex(_ index: Int) -> Int {
        return 2 * index + 2
    }
    
    private func swap(_ i: Int, _ j: Int) {
        let temp = heap[i]
        heap[i] = heap[j]
        heap[j] = temp
    }
    
    public func printHeap() {
        for i in 0..<size() {
            let node = heap[i]
            print("\(node.getF()) ")
        }
    }
}
