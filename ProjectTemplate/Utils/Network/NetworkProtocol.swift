//
//  NetworkProtocol.swift
//  SwiftTs
//
//  Created by Xinbo Lian on 2021/3/14.
//

import Foundation
import Moya

public protocol RequestTarget: Moya.TargetType {}

public protocol ResponseTarget  {
    associatedtype Parser: ResponseParser where Parser.Response == Self
}

public protocol ResponseParser: Decodable {

    associatedtype Response: Decodable

    var code :Int { get }
    var msg: String? { get }
    var value: Response { get }

}
