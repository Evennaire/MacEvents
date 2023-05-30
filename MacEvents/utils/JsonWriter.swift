//
//  JsonWriter.swift
//  MacEvents
//
//  Created by 程思翔 on 2023/5/30.
//

import Foundation
import SwiftyJSON

func writeMouseJson(json: JSON)->[String: Any] {
    var jsonEntries: [String: Any] = [:]
    jsonEntries["type"]         = "mouse"
    jsonEntries["timestamp_ms"] = json["timestamp"].rawValue as! Int64
    jsonEntries["uncomplete"]   = 1
    jsonEntries["x"]            = json["x"].rawValue as! Double
    jsonEntries["y"]            = json["y"].rawValue as! Double
    jsonEntries["clicks"]       = json["click"].rawValue as! Int
    switch json["event"].rawValue as! String {
    case "leftMouseDown", "leftMouseUp":
        jsonEntries["button"] = "Left"
    case "rightMouseDown", "rightMouseUp":
        jsonEntries["button"] = "Right"
    default:
        jsonEntries["button"] = "Middle"
    }
    return jsonEntries
}

func writeKeyJson(json: JSON)->[String: Any] {
    var jsonEntries: [String: Any] = [:]
    jsonEntries["type"]         = "keyboard"
    jsonEntries["timestamp_ms"] = json["timestamp"].rawValue as! Int64
    jsonEntries["uncomplete"]   = 1
    jsonEntries["keydata"]      = json["character"].rawValue as! String
    return jsonEntries
}
