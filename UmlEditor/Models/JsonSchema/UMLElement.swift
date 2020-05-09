// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uML = try? newJSONDecoder().decode(UML.self, from: jsonData)

import Foundation

struct UMLElement: Codable {
    let id: Int
    let typeString: TypeString
    let properties, methods: [Method]?
    var name: String?
    let superClass: Int?
    let cases: [Case]?
    let containedEntities, protocols, extensions: [Int]?
    
    var superClassName: String?
    var protocolNames: [String]?
}

// MARK: - Case
struct Case: Codable {
    let name: String
}

// MARK: - Method
struct Method: Codable {
    let name: String
    let type: TypeEnum
    let accessLevel: AccessLevel
}

enum AccessLevel: String, Codable {
    case accessLevelFileprivate = "fileprivate"
    case accessLevelInternal = "internal"
    case accessLevelOpen = "open"
    case accessLevelPrivate = "private"
    case accessLevelPublic = "public"
}

enum TypeEnum: String, Codable {
    case instance = "instance"
    case type = "type"
}

enum TypeString: String, Codable {
    case typeStringClass = "class"
    case typeStringEnum = "enum"
    case typeStringExtension = "extension"
    case typeStringProtocol = "protocol"
    case typeStringStruct = "struct"
}

typealias UML = [UMLElement]


extension Method: Identifiable {
    var id: Int { name.hashValue }
    var accessLevelSymbol: String {
        switch accessLevel {
        case .accessLevelInternal: return "+"
        case .accessLevelPrivate: return "-"
        case .accessLevelPublic: return "+"
        case .accessLevelOpen: return "+"
        case .accessLevelFileprivate: return "-"
        }
    }
}
