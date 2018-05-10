//
//  WolfNetwork.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation
import Moya

// Moya插件, 可以在特殊情况下打印
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

public class WolfNetwork {
    
    // 基础的网络请求返回字典类型
    public class func request<T: WolfProtocol, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: ((T?, String?, Int?) -> ())?, failure: ((MoyaError?) -> ())?) -> Cancellable {

        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                Model.objectFromJSON(response.data, completion)
            case let .failure(error):
                debugPrint(error.localizedDescription)
                failure?(error)
            }
        })
    }
    
    // 基础的网络请求返回数组类型
    public class func requestList<T: WolfProtocol, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: (([T]?, String?, Int?) -> Void)?, failure: ((MoyaError?) -> ())?) -> Cancellable {
        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                Model.listFromJSON(response.data, completion)
             case let .failure(error):
                debugPrint(error.localizedDescription)
                failure?(error)
            }
        })
    }
    
    
    fileprivate class func createProvider<T: TargetType>(_ target: T) -> MoyaProvider<T> {
        
        let endpointClosure = { (target: T) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: { () -> EndpointSampleResponse in
                return .networkResponse(200, target.sampleData)
            }, method: target.method, task: target.task, httpHeaderFields: target.headers)
            return endpoint.adding(newHTTPHeaderFields: WolfNetworkParams.header)
        }
        if WolfNetworkParams.isDebug {
            return MoyaProvider<T>(endpointClosure: endpointClosure, manager: WolfNetworkParams.sessionManager, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        } else {
            return MoyaProvider<T>(endpointClosure: endpointClosure, manager: WolfNetworkParams.sessionManager)
        }
    }
}

struct Model {
    
    static func objectFromJSON<T: WolfProtocol>(_ Json: Data, _ response: ((T?, String?, Int?) -> Void)?) {
        let tmp: WolfBaseModel<T>? = WolfModel.model(Json)
        response?(tmp?.data, tmp?.msg, tmp?.code)
    }
    
    static func listFromJSON<T: WolfProtocol>(_ Json: Data, _ response: (([T]?, String?, Int?) -> Void)?) {
        let tmp: WolfBaseModels<T>? = WolfModel.model(Json)
        response?(tmp?.data, tmp?.msg, tmp?.code)
    }

}

