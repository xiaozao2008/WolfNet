//
//  WolfNetwork.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation
import Alamofire
import Moya

public let wolf = WolfParams()
public protocol WolfMapper: Codable {
    mutating func didInit()
}

public protocol BaseWolfMapper: WolfMapper {
    
}

/// 用以转换 data -> model / model -> data
public class WolfModel {
    
    /// data -> model
    ///
    /// - Parameter data: 请求返回的data
    /// - Returns: 返回<T: WolfMapper>的model
    public static func model<T: WolfMapper>(_ data: Data?) -> T? {
        if let data = data {
            do {
                return try JSONDecoder.init().decode(T.self, from: data)
            } catch {
                // 此问题一般表示model属性的类型不匹配, 比如 age: String?, 可能服务器的参数为Int
                debugPrint("key的类型不匹配" + error.localizedDescription)
                return nil
            }
        } else {
            debugPrint("WolfModel传入data为nil")
            return nil
        }
    }
    
    /// model -> data
    ///
    /// - Parameter model: 遵守Encodable/WolfMapper的Model
    /// - Returns: 转换成功的data
    public static func data<T: Encodable>(_ model: T?) -> Data? {
        if let model = model {
            do {
                return try JSONEncoder.init().encode(model)
            } catch {
                debugPrint("将\(model.self)转成jsondata失败 \(error.localizedDescription)")
                return nil
            }
        } else {
            debugPrint("传入\(String(describing: model))为nil")
            return nil
        }
    }
}

/// 对外的网络请求API
public class Wolf {
    
    /// 返回一个Model的网络请求
    ///
    /// - Parameters:
    ///   - type:       Moya.type
    ///   - progress:   进度
    ///   - completion: 完成回调
    ///   - failure:    失败回调
    /// - Returns:      Cancellable
    public class func request<T: WolfMapper, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: ((T?, String?, Int?) -> ())?, failure: ((MoyaError?) -> ())?) -> Cancellable {

        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                WolfTransformModel.objectFromJSON(response.data, completion)
            case let .failure(error):
                debugPrint(error.localizedDescription)
                failure?(error)
            }
        })
    }
    
    /// 返回一个[Model]的网络请求
    ///
    /// - Parameters:
    ///   - type:       Moya.type
    ///   - progress:   进度
    ///   - completion: 完成回调
    ///   - failure:    失败回调
    /// - Returns:      Cancellable
    public class func requestList<T: WolfMapper, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: (([T]?, String?, Int?) -> Void)?, failure: ((MoyaError?) -> ())?) -> Cancellable {
        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                WolfTransformModel.listFromJSON(response.data, completion)
             case let .failure(error):
                debugPrint(error.localizedDescription)
                failure?(error)
            }
        })
    }
    
    /// 拼凑一下Moya的Provider
    fileprivate class func createProvider<T: TargetType>(_ target: T) -> MoyaProvider<T> {
        
        let endpointClosure = { (target: T) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: { () -> EndpointSampleResponse in
                return .networkResponse(200, target.sampleData)
            }, method: target.method, task: target.task, httpHeaderFields: target.headers)
            return endpoint.adding(newHTTPHeaderFields: wolf.header)
        }
        if wolf.isDebug {
            return MoyaProvider<T>(endpointClosure: endpointClosure, manager: wolf.sessionManager, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        } else {
            return MoyaProvider<T>(endpointClosure: endpointClosure, manager: wolf.sessionManager)
        }
    }
}

// Moya插件, Debug使用
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

fileprivate struct WolfTransformModel {
    
    static func objectFromJSON<T: WolfMapper>(_ Json: Data, _ response: ((T?, String?, Int?) -> Void)?) {
        let tmp: WolfBaseModel<T>? = WolfModel.model(Json)
        response?(tmp?.data, tmp?.msg, tmp?.code)
    }
    
    static func listFromJSON<T: WolfMapper>(_ Json: Data, _ response: (([T]?, String?, Int?) -> Void)?) {
        let tmp: WolfBaseModels<T>? = WolfModel.model(Json)
        response?(tmp?.data, tmp?.msg, tmp?.code)
    }
}

public class WolfParams {
    // 请求头
    public var isDebug = false
    public var header = [String: String]()
    public var sessionManager = DefaultAlamofireManager.sharedManager
}

public class DefaultAlamofireManager: Alamofire.SessionManager {
    
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 60
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return DefaultAlamofireManager(configuration: configuration)
    }()
}


