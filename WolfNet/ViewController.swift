//
//  ViewController.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

enum CellTitle: String{
    case get
    case post
    case upload
    case download
}

class ViewController: UITableViewController {
    
    let dataSource:[CellTitle]  = [.get, .post, .upload, .download]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.name())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class PriceModel: Mappable {
    var prices: [PriceType]?
    func mapping(map: Map) {
        prices <- map["prices"]
    }
    required init?(map: Map) {
        
    }
    
    class PriceType: Mappable {
        
        var type: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            type <- map["type"]
        }
        
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 如果要查看全部请求数据
        WolfNetworkParams.isDebug = true
        // 服务器第一层数据需要提供对应key
        //        WolfNetworkParams.code = "code"
        //        WolfNetworkParams.msg = "msg"
        //        WolfNetworkParams.data = "data"
        // 设置通用请求头
        //        WolfNetworkParams.header = ["":""]
        // 设置通用请求session, 比如超时时间等.
        //        WolfNetworkParams.sessionManager = Alamofire.SessionManager
        let _ = WolfNetwork.requestObjc(type: WolfApi.wolfGet, completion: { (data: PriceModel?) in
            print(data?.prices?.first?.type ?? "")
        }) { (_, code) in
            print(code ?? 0)
        }
        
        let type = dataSource[indexPath.row]
        switch type {
        case .get:
            print("get")
        case .post:
            print("get")
        case .upload:
            print("get")
        case .download:
            print("get")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.name())
        cell?.textLabel?.text = dataSource[indexPath.row].rawValue
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

extension NSObject {
    class func name() -> String {
        return String.init(describing: self)
    }
}

