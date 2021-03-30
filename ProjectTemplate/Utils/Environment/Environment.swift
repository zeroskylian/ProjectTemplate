//
//  Environment.swift
//  HengLiMarketing
//
//  Created by lian on 2021/3/19.
//

import Foundation

public enum Environment {
    case release
    case develop
    case test
    case smoking
    
    public static func current() -> Environment {
        #if DEVELOP
        return .develop
        #elseif SMOKING
        return .smoking
        #elseif TEST
        return .test
        #else
        return .release
        #endif
    }
}

