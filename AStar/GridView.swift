//
//  GridView.swift
//  AStar
//
//  Created by Evan Cedeno on 11/26/24.
//

import SwiftUI


struct GridView: View {
    
    @Binding var grid: [[Int]]
    @Binding var pathDrawn: Bool
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
            Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                ForEach(0..<grid.count, id: \.self) { y in
                    HStack(spacing: 1) {
                        ForEach(0..<grid[0].count) { x in
                            Rectangle()
                                .fill(gridColor(grid[y][x]))
                                .aspectRatio(1.0, contentMode: .fit)
                                .onTapGesture {
                                    if pathDrawn { return }
                                    
                                    var colorInt = 0
                                    
                                    if !gridContains(3) {
                                        colorInt = 3
                                    }
                                    else if !gridContains(4) {
                                        colorInt = 4
                                    }
                                    else {
                                        if grid[y][x] == 0 {
                                            colorInt = 1
                                        }
                                        else if grid[y][x] == 1 {
                                            colorInt = 0
                                        }
                                    }
                                    
                                    grid[y][x] = colorInt
                                }
                        }
                    }
                }
            }
            .padding(1)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    private func gridColor(_ value: Int) -> Color {
        switch value {
        case 0: return .white
        case 1: return .black
        case 2: return .blue
        case 3: return .green
        case 4: return .red
        default: return .white
        }
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
}
