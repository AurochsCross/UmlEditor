//
//  ContentViewModel.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {

    @Published var openFile: PumlFile?
    @Published var zoomLevel: CGFloat = 1
    @Published var currentNode: Node?
    @Published var nodes: [Node] = []
    @Published var nodeGroups: [[Node]] = []
    @Published var connections: [Connection] = []
    
    @Published var viewUpdater = false
    
    private var dragOffset: CGPoint?
    
    func setLocation(ofNode node: Node, x: CGFloat, y: CGFloat) {
        
        if dragOffset == nil {
            dragOffset = CGPoint(x: node.rendering.x - x, y: node.rendering.y - y)
        }
        
        if node.id != currentNode?.id {
            selectNode(node)
        }
        
        currentNode?.rendering.x = x + dragOffset!.x
        currentNode?.rendering.y = y + dragOffset!.y
        
        connections = connections.reversed()
        
        viewUpdater.toggle()
    }
    
    func finishedDragging() {
        dragOffset = nil
    }
    
    func selectNode(_ node: Node) {
        currentNode = node
        nodes = nodes.filter({ $0.id != node.id })
        nodes.append(node)
    }
    
    func saveScheme() {
        let manager = FileManager()
        
        let data = PumlData(nodes: nodes, zoomLevel: Double(zoomLevel))
        
        manager.save(puml: data, preferedPath: openFile?.location, preferedName: openFile?.name)
    }
    
    func itemDropped(url: URL) {
        let extractor = NodeExtractor(url: url)
        let puml = extractor.extract()
        let groups = NodeGrouper(nodes: puml.nodes).group()
        
        DispatchQueue.main.async {
            self.nodes = puml.nodes
            self.nodeGroups = groups
            self.zoomLevel = CGFloat(puml.zoomLevel)
            self.setupConnections()
            if url.pathExtension == "puml" {
                self.openFile = PumlFile(location: url, name: url.lastPathComponent)
            } else {
                self.openFile = nil
            }
        }
    }
    
    func setupConnections() {
        let positioner = NodePositioner(nodes: nodes)
        connections = positioner.createConnections()
    }
    
    func arrangeNodes() {
        let positioner = NodePositioner(nodes: nodes)
        
        positioner.position()
        
        DispatchQueue.main.async {
            self.currentNode = nil
        }
    }
}

extension ContentViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [(kUTTypeFileURL as String)]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) {item, error in
            guard
                let data = item as? Data,
                let url = URL(dataRepresentation: data, relativeTo: nil)
            else { return }
            self.itemDropped(url: url)
        }
        return true
    }
}
