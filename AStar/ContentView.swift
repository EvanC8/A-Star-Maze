//
//  ContentView.swift
//  AStar
//
//  Created by Evan Cedeno on 11/25/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var grid: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 20), count: 20)
    @State var pathDrawn: Bool = false
    
    var body: some View {
        VStack {
            GridView(grid: $grid, pathDrawn: $pathDrawn)
            
            Button {
                if pathDrawn {
                    resetGrid()
                    pathDrawn.toggle()
                    return
                }
                
                if (!gridContains(3) || !gridContains(4)) {
                    return
                }
                
                var A: (Int, Int) = (0, 0)
                var B: (Int, Int) = (0, 0)
                var obstacles: [(Int, Int)] = []
                
                for x in 0..<grid.count {
                    for y in 0..<grid[0].count {
                        if grid[y][x] == 1 {
                            obstacles.append((x, y))
                        }
                        else if grid[y][x] == 3 {
                            A = (x, y)
                        }
                        else if grid[y][x] == 4 {
                            B = (x, y)
                        }
                    }
                }
                
                let alg = AStar(gridSize: (grid[0].count, grid.count), A: A, B: B)
                
                for obstacle in obstacles {
                    alg.insertBarrier(obstacle)
                }
                
                let path = alg.findPath()
                
                for node in path {
                    grid[node.1][node.0] = 2
                }
                
                pathDrawn.toggle()
                
            } label: {
                Text(pathDrawn ? "Clear" : "Find Path")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(.blue)
                    }
            }
            .padding()
        }
        .padding()
    }
    
    private func gridContains(_ ColorInt: Int) -> Bool {
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                if grid[y][x] == ColorInt {
                    return true
                }
            }
        }
        return false
    }
    
    private func resetGrid() {
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                grid[y][x] = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
