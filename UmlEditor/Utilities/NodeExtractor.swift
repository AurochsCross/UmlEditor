//
//  NodeExtractor.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class NodeExtractor {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func extract() -> PumlData {
        guard let data = readFile() else {
            print("Failed to read file")
            return PumlData()
        }
        
        
        if let puml = try? JSONDecoder().decode(PumlData.self, from: data) {
            return puml
        }
        
        guard let uml = try? JSONDecoder().decode(UML.self, from: data) else {
            do {
                _ = try JSONDecoder().decode(UML.self, from: data)
            } catch {
                print(error)
            }
            
            print("Failed to decode")
            return PumlData(nodes: [], zoomLevel: 1.0)
        }
        
        let extensionsFix = uml
            .map { element -> UMLElement in
                guard element.typeString == .typeStringExtension else { return element }
                
                var fixedElement = element
                fixedElement.name = uml.first(where: { other in
                    other.extensions?.contains(where: { $0 == element.id}) ?? false
                    
                    })?.name
                
                return fixedElement
            }
        
        let fixedNodes =  extensionsFix.map { element in
            return Node(x: 20, y: 20, content: element)
        }
        
        return PumlData(nodes: fixedNodes, zoomLevel: 1.0)
    }
    
    private func readFile() -> Data? {
        return try? Data(contentsOf: url)
    }
}
