//
//  NodePositioner.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class NodePositioner {
    private enum Config {
        static let verticalOffset: CGFloat = -900
        static let horizontalOffset: CGFloat = -900
        static let maxHorizontalSpace: CGFloat = 2000
        static let padding: CGFloat = 20
    }
    
    let nodes: [Node]
    
    init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    func position() {
        var currentLineOccupiedSpace: CGFloat = 0
        
        var currentLineHeightPosition = 0
        var nextLineHeightPosition = 0
        
        nodes.forEach { node in
            
            let potentialNextLineHeightPosition = currentLineHeightPosition + Int(node.rendering.height)
            
            nextLineHeightPosition = nextLineHeightPosition > potentialNextLineHeightPosition ? nextLineHeightPosition : potentialNextLineHeightPosition
            
            
            let potentialLineOccupiedSpace = currentLineOccupiedSpace + node.rendering.width
            
            if potentialLineOccupiedSpace < Config.maxHorizontalSpace {
                // Put node on the same line
            } else {
                // Put node on the next line
                currentLineHeightPosition = nextLineHeightPosition
                currentLineOccupiedSpace = 0
            }
            
            node.rendering.x = currentLineOccupiedSpace + node.rendering.width / 2 + Config.horizontalOffset
            node.rendering.y = CGFloat(currentLineHeightPosition) + node.rendering.height / 2 + Config.verticalOffset
            currentLineOccupiedSpace += node.rendering.width
            
        }
    }
    
    func createConnections() -> [Connection] {
        let childNodes = nodes.filter({ $0.content.superClass != nil})
        
        return childNodes.map { child -> Connection in
            let parent = nodes.first(where: { $0.content.id == child.content.superClass! })!
            
            return Connection(from: parent, to: child)
        }
    }
}
