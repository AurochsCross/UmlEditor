//
//  Node.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class Node: Identifiable, Codable {
    var id: UUID = UUID()
    var rendering: Rendering
    var content: UMLElement
    
    init(x: CGFloat, y: CGFloat, content: UMLElement) {
        self.rendering = Rendering(x: x, y: y)
        self.content = content
    }
    
    init(rendering: Rendering, content: UMLElement) {
        self.rendering = rendering
        self.content = content
    }
}
