//
//  Prompt.swift
//  HengLiMarketing
//
//  Created by lian on 2021/3/11.
//

import Foundation

/// 提示语 类
public struct Prompt: RawRepresentable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Prompt {
    static let `提示语` = Prompt(rawValue: "提示语")
    static let `没有` = Prompt(rawValue: "没有")
}

extension Prompt {
    func localizable() -> String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
