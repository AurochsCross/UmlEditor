//
//  NodeGroup.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class NodeGroup: Identifiable {
    let id = UUID()
    
    var name: String
    var nodes: [Node]
    
    init(name: String, nodes: [Node]) {
        self.name = name
        self.nodes = nodes
    }
}
