//
//  NetworkSimpleData.swift
//  SwiftTs
//
//  Created by Xinbo Lian on 2021/3/14.
//

import Foundation
import Moya


enum Request {
    case common
    case data
    case list
}

extension Request: RequestTarget {
    
    var sampleData: Data {
        switch self {
        case .common:
            return """
            {
                "code": 200,
                "msg": "Error",
                "data": [
                    "1",
                    "2"
                ]
            }
            """.data(using: .utf8)!
        case .data:
            return """
        {
            "code": 200,
            "msg": "Error",
            "data": [
                "1",
                "2"
            ]
        }
        """.data(using: .utf8)!
        case .list:
            return """
            {
                "code": 200,
                "msg": "Error",
                "rows": [
                    "1",
                    "2"
                ]
            }
            """.data(using: .utf8)!
        }
        
    }
    
    var baseURL: URL {
        return URL(string: "https://www.baidu.com")!
    }
    
    var path: String {
        return "ch"
    }
    
    var method: Moya.Method {
        return Method.post
    }
    
    
    var task: Task {
        switch self {
        default: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [:]
    }
    
}

public struct BaseModel<T:Decodable>: Decodable, ResponseParser {
    
    public typealias Response = T
    public let code :Int
    public let msg: String?
    
    let data: Response
    
    public var value: Response {
        return data
    }
}

public struct BaseListModel<T:Decodable>: Decodable, ResponseParser {
    
    public typealias Response = [T]
    public let code :Int
    public let msg: String?
    
    let rows: Response
    let total: Int?
    let pageNum: Int?
    
    public var value: Response {
        return rows
    }
}

extension String: ResponseTarget {
    public typealias Parser = BaseModel<Self>    
}

extension Array: ResponseTarget where Element == String {
    public typealias Parser = BaseListModel<Element>
}

/*
 NetworkManager<Request,[String]>().request(target: .list) { (result) in
     print(result)
 }
 */
