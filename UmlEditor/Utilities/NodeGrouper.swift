//
//  NodeGrouper.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class NodeGrouper {
    let nodes: [Node]
    
    init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    func group() -> [[Node]] {
        var groups: [[Node]] = []
        
        nodes.forEach { node in
            if var group = groups.first(where: { group in
                group.contains(where: { nodeInGroup in
                    nodeInGroup.content.id == node.content.superClass || nodeInGroup.content.superClass == node.content.id
                })
            }) {
                group.append(node)
            } else {
                groups.append([node])
            }
        }
        
        return groups
    }
}
