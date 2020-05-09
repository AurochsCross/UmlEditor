//
//  ContentViewModel.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ContentViewModel: ObservableObject {

    @Published var canvasLocation = CGPoint()
    @Published var openFile: PumlFile?
    @Published var zoomLevel: CGFloat = 1
    @Published var searchText: String = ""
    @Published var currentNode: Node?
    
    @Published var visibleNodes: [Node] = []
    @Published var nodes: [Node] = []
    @Published var visibleNodeGroups: [NodeGroup] = []
    @Published var nodeGroups: [NodeGroup] = []
    @Published var connections: [Connection] = []
    
    @Published var selectedGroupId: UUID = UUID()
    
    @Published var viewUpdater = false
    
    private var dragOffset: CGPoint?
    
    private var cancellables = Set<AnyCancellable>()
    
    func setup() {
        $selectedGroupId
            .map { id in
                return self.nodeGroups.first(where: { id == $0.id })?.nodes ?? self.nodes
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.visibleNodes, on: self)
            .store(in: &cancellables)
        
        $visibleNodes
            .receive(on: DispatchQueue.main)
            .sink { values in
                let positioner = NodePositioner(nodes: self.visibleNodes)
                self.connections = positioner.createConnections()
                self.canvasLocation = .zero
            }
            .store(in: &cancellables)
        
        $searchText
            .map { text -> [NodeGroup] in
                if text.isEmpty {
                    return self.nodeGroups
                }
                
                return self.nodeGroups.filter { group in
                    group.name.lowercased().contains(text.lowercased())
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.visibleNodeGroups, on: self)
            .store(in: &cancellables)
        
    }
    
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
    
    func setCanvasLocation(_ location: CGPoint) {
        if dragOffset == nil {
            dragOffset = CGPoint(x: canvasLocation.x - location.x, y: canvasLocation.y - location.y)
        }
        
        canvasLocation.x = location.x + dragOffset!.x
        canvasLocation.y = location.y + dragOffset!.y
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
        let groups = NodeGrouper(nodes: puml.nodes).group().sorted(by: { $0.name < $1.name })
        
        DispatchQueue.main.async {
            self.nodes = puml.nodes
            self.nodeGroups = groups
            self.visibleNodeGroups = groups
            self.zoomLevel = CGFloat(puml.zoomLevel)
            if url.pathExtension == "puml" {
                self.openFile = PumlFile(location: url, name: url.lastPathComponent)
            } else {
                self.openFile = nil
            }
        }
    }
    
    func arrangeNodes() {
        let positioner = NodePositioner(nodes: visibleNodes)
        positioner.position()
        
        DispatchQueue.main.async {
            self.currentNode = nil
        }
    }
    
    func isNodeVisible(_ node: Node, geometry: GeometryProxy) -> Bool {
        let visibleArea = CGRect(
            x: -canvasLocation.x - geometry.size.width / 2.0 - node.rendering.width / 2,
            y: -canvasLocation.y - geometry.size.height / 2.0 - node.rendering.height / 2,
            width: geometry.size.width + node.rendering.width,
            height: geometry.size.height + node.rendering.height)
        
        return visibleArea.contains(CGRect(x: node.rendering.x - node.rendering.width / 2, y: node.rendering.y - node.rendering.height / 2, width: node.rendering.width, height: node.rendering.height))
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
