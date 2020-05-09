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
    
    func group() -> [NodeGroup] {
        var groups: [NodeGroup] = []
        
        groups = nodes.map {
            var name = "\($0.content.name ?? "-") - \($0.content.typeString.rawValue)"
            return NodeGroup(name: name, nodes: [$0])
        }
        
        return groups
        
        nodes.forEach { node in
            
            let availableGroups = groups.filter({ group in
                group.nodes.contains(where: { nodeInGroup in
                nodeInGroup.content.id == node.content.superClass || nodeInGroup.content.superClass == node.content.id
                })
            })
            
            if availableGroups.count == 0 {
                groups.append(NodeGroup(name: "\(node.content.name ?? "-")", nodes: [node]))
            } else {
                groups = groups.filter { group in
                    !availableGroups.contains(where: { $0.id == group.id })
                }
                
                var mergedNodes = availableGroups.reduce([Node]()) { result, group in
                    return result + group.nodes
                }
                
                mergedNodes.append(node)
                
                let parentNode = mergedNodes.first(where: { $0.content.superClass == nil })
                
                groups.append(NodeGroup(name: parentNode?.content.name ?? mergedNodes.first?.content.name ?? "-" , nodes: mergedNodes))
            }
            
            
            
//            if var group = groups.first(where: { group in
//                group.nodes.contains(where: { nodeInGroup in
//                    nodeInGroup.content.id == node.content.superClass || nodeInGroup.content.superClass == node.content.id
//                    })
//            }) {
//                group.nodes.append(node)
//            } else {
//
//            }
        }
        
        return groups
    }
}
