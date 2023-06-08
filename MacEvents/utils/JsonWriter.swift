//
//  JsonWriter.swift
//  MacEvents
//
//  Created by 程思翔 on 2023/5/30.
//

import Foundation
import SwiftyJSON

enum JsonError: Error {
    case writeFileFailure
    case invalidUrl
    case invalidJson
}

extension JsonError: CustomStringConvertible {
    var description: String {
        switch self {
        case .writeFileFailure:
            return "写入文件时出错：\(localizedDescription)"
        case .invalidUrl:
            return "路径不合法"
        case .invalidJson:
            return "Json文件不合法"
        }
    }
}

struct JsonWriter {
    
    func writeAsArray(_ json: JSON, by filename: String, completion: @escaping (String) -> () = { _ in }, exceptionally: @escaping (JsonError) -> () = { _ in }) {
        guard let data = try? JSONSerialization.data(withJSONObject: json.arrayObject ?? [], options: .prettyPrinted) else {
            exceptionally(.invalidJson)
            return
        }
        
        guard let directoryUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            exceptionally(.invalidUrl)
            return
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        do {
            try data.write(to: fileUrl)
            completion(fileUrl.absoluteString)
        } catch {
            exceptionally(.writeFileFailure)
        }
    }
    
    func tryWriteAsArray(_ json: JSON, by filename: String) throws {
        guard let data = try? JSONSerialization.data(withJSONObject: json.arrayObject ?? [], options: .prettyPrinted) else {
            throw JsonError.invalidJson
        }
        
        guard let directoryUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw JsonError.invalidUrl
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        do {
            try data.write(to: fileUrl)
        } catch {
            throw JsonError.writeFileFailure
        }
    }
    
    func writeAsObject(_ json: JSON, by filename: String, completion: @escaping (String) -> () = { _ in }, exceptionally: @escaping (JsonError) -> () = { _ in }) {
        guard let data = try? json.rawData(options: .prettyPrinted) else  {
            exceptionally(.invalidJson)
            return
        }
        
        guard let directoryUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            exceptionally(.invalidUrl)
            return
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        guard let handler = try? FileHandle(forWritingTo: fileUrl) else {
            exceptionally(.invalidUrl)
            return
        }
        
        do {
            defer { try? handler.close() }
            try handler.seekToEnd()
            try handler.write(contentsOf: data)
            try handler.write(contentsOf: ",\n".data(using: .utf8)!)
            completion(fileUrl.absoluteString)
        } catch {
            exceptionally(.writeFileFailure)
        }
    }
    
    func tryWriteAsObject(_ json: JSON, by filename: String) throws {
        guard let data = try? json.rawData(options: .prettyPrinted) else  {
            throw JsonError.invalidJson
        }
        
        guard let directoryUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw JsonError.invalidUrl
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        guard let handler = try? FileHandle(forWritingTo: fileUrl) else {
            throw JsonError.invalidUrl
        }
        
        do {
            defer { try? handler.close() }
            try handler.seekToEnd()
            try handler.write(contentsOf: data)
            try handler.write(contentsOf: ",\n".data(using: .utf8)!)
        } catch {
            throw JsonError.writeFileFailure
        }
    }
}
