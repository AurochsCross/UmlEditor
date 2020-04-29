//
//  PumlData.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class PumlData: Codable {
    var nodes: [Node]
    var zoomLevel: Double
    
    init() {
        self.nodes = []
        self.zoomLevel = 1.0
    }
    
    init(nodes: [Node], zoomLevel: Double) {
        self.nodes = nodes
        self.zoomLevel = zoomLevel
    }
}
