# WolfNet - Demo
仅支持Swift4.0+

一个使用 泛型 + Codable + Moya的网络请求框架

Demo

##### 请求部分

> 在你的代码中最终请求, 应该类似于下面的样子
> 
> 如果是一般的网络请求可以写一个接受的Model或者[Model]
> 
> 如果是提示类的空数据, 也可以使用WolfEmpty, 替换例子中的PriceModel


 	let _ = WolfNetwork.request(type: WolfApi.wolfGet, completion: { (user: User?, msg, code) in
		print(user?.name)
		print(user?.age)
	}) { (error) in
            
    }

 
 > 或者
 
    let _ = WolfNetwork.requestList(type: WolfApi.wolfGet, completion: { (user: [User]?, msg, code) in
            
    }) { (error) in
            
    }
    
    
> 或者带进度

    let _ = WolfNetwork.requestObjc(type: WolfApi.wolfGet, progress: { (progressObjc) in
	    print(progressObjc.progress)
	    print(progressObjc.progressObject?.totalUnitCount)
	    print(progressObjc.progressObject?.completedUnitCount)
    }, completion: { (user: [User]?, msg, code) in
            
    }) { (error) in
            
    }

    
> 可见上方参数主要有2个

>> 1. WolfApi.wolfGet
>> 2. PriceModel


> 参数1, WolfApi.wolfGet.
>> 如果你使用过Moya, 那么没错WolfApi.wolfGet这就是Moya的TargetType对象.
>> 在Demo中我简单创建了一个发起请求的方式
> 
> 参数2, PriceModel
> >其实就是你创建的Model, 需要遵守我自定义的WolfProtocl的Codable协议.

> 另外利用WolfNetwork.request...的返回值是一个Cancellable类型, 你可以对发起的请求进行取消.
> 

##### 调试部分

>  Debug模式

    // 这是一个单例对象, 在工程任意地方打开debug
    // 即可打印发起网络请求后的所有参数返回值等信息, 利用的是Moya的插件机制.
    WolfNetworkParams.isDebug = true
    
>  服务器的第一层参数
 
    可以参考WolfBaseModel类文件
    
    
>  设置通用的请求header

    WolfNetworkParams.header = ["":""]
    
>  设置以前Alamofire的session, 比如超时时间等.

    WolfNetworkParams.sessionManager = Alamofire.SessionManager

	
	
