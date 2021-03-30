//
//  YunZhouLogger.swift
//  YunZhouUtilities
//
//  Created by James on 2018/4/25.
//  Copyright ©2018年 YunZhou. All rights reserved.
//

import Foundation

public struct Logger<T> {
    
    public enum LogType: String {
        case database = "📚"
        case warning = "⚠️"
        case success = "✅"
        case failure = "❎"
        case network = "⛅"
        case surface = "🎬"
        case dealloc = "♻️"
        case bridges = "🌉"
    }
    
    public let level: LogUtility
    
    public let type: LogType
    
    public let message: T
    
    @discardableResult
    init(message: T, type: LogType, level: LogUtility = .debug, file: String = #file, method: String = #function, line: Int = #line) {
        self.level = level
        self.type = type
        self.message = message
        level.doLog(message, raw: self, file: file, method: method, line: line)
    }
    
    static func log(message: T, type: LogType, level: LogUtility = .debug, file: String = #file, method: String = #function, line: Int = #line) {
        Logger(message: message, type: type, level: level, file: file, method: method, line: line)
    }
}

public enum LogUtility {
    
    case debug
    case environment(Environment)
    case error
    
    func doLog<T>(_ message: T, raw: Logger<T>, file: String, method: String, line: Int) {
        #if DEBUG
        let filePath: String = "\((file as NSString).lastPathComponent)"
        self.doPrint("\(filePath)-Line:\(line)-Method:\(method) \(raw.type.rawValue): \(message)")
        #endif
    }
    
    private func doPrint(_ message: String) {
        switch self {
        case .debug:
            #if DEBUG
            print(message)
            #endif
        case .environment(let env):
            switch env {
            case .release:
                break
            case .develop:
                print(message)
            case .test:
                print(message)
            case .smoking:
                print(message)
            }
        case .error:
            fatalError(message)
        }
    }
}
