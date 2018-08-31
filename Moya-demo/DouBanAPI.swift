//
//  DouBanAPI.swift
//  Moya-demo
//
//  Created by 李永杰 on 2018/8/31.
//  Copyright © 2018年 muheda. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import RxSwift

//即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
let DouBanProvider = MoyaProvider<DouBanAPI>()

//声明一个 enum 来对请求进行明确分类
public enum DouBanAPI {
    case channels
    case playlist(String)
}
//让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息。
extension DouBanAPI: TargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    //请求任务事件，在这里可以添加参数
    public var task: Task {
        switch self {
        case .playlist(let channel):
            var para: [String: Any] = [:]
            para["channel"] = channel
            para["type"] = "n"
            para["from"] = "mainsite"
 
            return .requestParameters(parameters: para,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    //做单元测试的模拟的数据
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    //请求头
    public var headers: [String: String]? {
        return nil
    }
    
}


//字典转模型
extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

//RxSwift+HandyJSON扩展
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> Single<T>{
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapModel(T.self))
        }
    }
    
}















