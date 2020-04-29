//
//  PumlFile.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class PumlFile {
    var name: String
    var location: URL
    
    init(location: URL, name: String) {
        self.name = name
        self.location = location
    }
}
