//
//  AppError.swift
//  ProjectTemplate
//
//  Created by lian on 2021/3/30.
//

import Foundation

public struct AppError: LocalizedError {
    
    public let description: String
    
    public let reason: String
    
    public init(reason: String ,file: String = #file, function: String = #function, line: Int = #line) {
        self.reason = reason
        description = "error at " + (file as NSString).lastPathComponent + ":\(line)" + self.reason
    }
    public var errorDescription: String? {
        return description
    }
}
