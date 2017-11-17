//
//  WolfNetwork.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

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
    public class func requestObjc<T: Mappable, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: @escaping ((T?) -> Void), msg: @escaping ((String?, Int?) -> Void)) -> Cancellable {

        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                completion(Model.objectFromJSON(response.data, msg)?.data)
            case let .failure(error):
                debugPrint(error) // 错误通用处理一下
                msg("请求发生错误", 404)
            }
        })
    }
    
    // 基础的网络请求返回数组类型
    public class func requestList<T: Mappable, R: TargetType>(type: R, progress: ProgressBlock? = nil, completion: @escaping (([T]?) -> Void), msg: @escaping ((String?, Int?) -> Void)) -> Cancellable {
        let provider = self.createProvider(type)
        return provider.request(type, progress: progress, completion: { (event) in
            switch event {
            case let .success(response):
                completion(Model.listFromJSON(response.data, msg)?.dataList)
             case let .failure(error):
                debugPrint(error) // 错误通用处理一下
                msg("请求发生错误", 404)
            }
        })
    }
    
    
    fileprivate class func createProvider<T: TargetType>(_ target: T) -> MoyaProvider<T> {
        
        let endpointClosure = { (target: T) -> Endpoint<T> in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<T> = Endpoint<T>(url: url, sampleResponseClosure: { () -> EndpointSampleResponse in
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
    
    static func objectFromJSON<T: Mappable>(_ Json: Data, _ msg: ((String?, Int?) -> Void)?) -> WolfBaseModel<T>? {
        let mapperModel = Mapper<WolfBaseModel<T>>()
        if let json = String.init(data: Json, encoding: .utf8) {
            let object = mapperModel.map(JSONString: json)
            msg?(object?.msg, object?.code)
            return object
        }
        return nil
    }
    
    static func listFromJSON<T: Mappable>(_ Json: Data, _ msg: ((String?, Int?) -> Void)?) -> WolfListModel<T>? {
        let mapperModel = Mapper<WolfListModel<T>>()
        if let json = String.init(data: Json, encoding: .utf8) {
            let object = mapperModel.map(JSONString: json)
            msg?(object?.msg, object?.code)
            return object
        }
        return nil
    }

}

