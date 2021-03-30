//
//  UserDefault.swift
//  henglinkiOS
//
//  Created by lian on 2021/2/8.
//  Copyright © 2021 恒力智能科技有限公司. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {

            if let value = newValue as? OptionalProtocol,value.isNil() {
                UserDefaults.standard.removeObject(forKey: key)
            }else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
            UserDefaults.standard.synchronize()
        }
    }
}

///封装一个UserDefault配置文件
struct UserDefaultsConfig {
    ///告诉编译器 我要包裹的是hadShownGuideView这个值。
    ///实际写法就是在UserDefault包裹器的初始化方法前加了个@
    /// hadShownGuideView 属性的一些key和默认值已经在 UserDefault包裹器的构造方法中实现
    @UserDefault("had_shown_guide_view", defaultValue: false)
    static var hadShownGuideView: Bool
}

fileprivate protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional : OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
