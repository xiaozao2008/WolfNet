//
//  ViewController.swift
//  WolfNet
//
//  Created by xiaozao on 2018/5/10.
//  Copyright © 2018年 Tony. All rights reserved.
//

import UIKit

struct User: WolfProtocol {
    var age: Int?
    var name: String?
    
    func didInit() {
        debugPrint("didInt")
    }
}


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://www.mocky.io
        // {"code":200,"msg":"success","data":{"name":"Tony","age":18}}
        wolf.isDebug = true
        Wolf.request(type: WolfApi.wolfGet, completion: { (user: User?, msg, code) in
            print(user?.name)
            print(user?.age)
        }) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

