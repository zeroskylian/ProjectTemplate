//
//  NetworkManager.swift
//  SwiftTs
//
//  Created by Xinbo Lian on 2020/12/20.
//

import Foundation
import Moya

public protocol NetworkDelegate: class {
    
    func networkActivityBegan(target: TargetType)
    func networkActivityEnded(target: TargetType)
    
    func networkActivitySuccess(target: TargetType)
    func networkActivityFailure(target: TargetType, error: NetworkError)
}

public enum NetworkError: Error {
    case parseModelError(String)
    case systemNetworkError(Error)
    case serverError(Error)
    case bussinessError
}

public final class NetworkManager<R:RequestTarget,S:ResponseTarget> {
    
    typealias NetworkCompletion = (Result<S, NetworkError>) -> Void
    
    typealias NetworkListCompletion = (Result<[S], NetworkError>) -> Void
    
    public weak var delegate: NetworkDelegate?
    
    public var callbackQueue: DispatchQueue
    
    init(delegate: NetworkDelegate?, callbackQueue: DispatchQueue! = .main) {
        self.delegate = delegate
        self.callbackQueue = callbackQueue
    }
    
    lazy var plugin: NetworkActivityPlugin = {
        return NetworkActivityPlugin { (activityType, targetType) in
            switch activityType {
            case .began:
                self.delegate?.networkActivityBegan(target: targetType)
            case .ended:
                self.delegate?.networkActivityEnded(target: targetType)
            }
        }
    }()
    
    
    func request(target: R, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping NetworkCompletion) {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        /*
         // simpleData
         let provider = MoyaProvider<R>(stubClosure: MoyaProvider<R>.immediatelyStub, callbackQueue: callbackQueue,session: Session(configuration: configuration, startRequestsImmediately: false))
         */
        let provider = MoyaProvider<R>(callbackQueue: callbackQueue,session: Session(configuration: configuration))
        provider.request(target) { (result) in
            switch result{
            case .success(let response):
                do {
                    let parser = try response.map(S.Parser.self)
                    if parser.code == 200 {
                        completion(.success(parser.value))
                        self.delegate?.networkActivitySuccess(target: target)
                    }else {
                        let error = self.validateResponse(with: response, parser: parser)
                        completion(.failure(error))
                        self.delegate?.networkActivityFailure(target: target, error: error)
                    }
                } catch  {
                    let error: NetworkError = .parseModelError(error.localizedDescription)
                    completion(.failure(.parseModelError(error.localizedDescription)))
                    self.delegate?.networkActivityFailure(target: target, error: error)
                }
            case .failure(let error):
                let sysError = NetworkError.serverError(error)
                completion(.failure(sysError))
                self.delegate?.networkActivityFailure(target: target, error: sysError)
            }
        }
    }
    
    
    private func validateResponse<T, P: ResponseParser>(with response: Moya.Response, parser: P) -> NetworkError where P.Response == T  {
        switch Environment.current() {
        case .release:
            Logger.log(message: "success", type: .bridges)
        case .smoking:
            fallthrough
        case .develop:
            fallthrough
        case .test:
            Logger.log(message: response.response?.url, type: .bridges)
            do {
                Logger.log(message: try response.mapJSON(), type: .bridges)
            } catch  {
                Logger.log(message: "转json 失败", type: .failure)
            }
        }
        
        /*
         处理服务端错误
         */
        return .bussinessError
    }
}
