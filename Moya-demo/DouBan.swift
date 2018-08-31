//
//  DouBan.swift
//  Moya-demo
//
//  Created by 李永杰 on 2018/8/31.
//  Copyright © 2018年 muheda. All rights reserved.
//

import Foundation
import HandyJSON

//豆瓣接口模型
struct Douban: HandyJSON {
    //频道列表
    var channels: [Channel]?
    
}

//频道模型
struct Channel: HandyJSON {
    var name: String?
    var name_en:String?
    var seq_id: Int?
    var abbr_en: String?
    var channel_id: String?
 
    
}

//歌曲列表模型
struct Playlist: HandyJSON {
    var r: Int?
    var isShowQuickStart: Int?
    var song:[Song]?
    
}

//歌曲模型
struct Song: HandyJSON {
    var title: String?
    var artist: String?
    
}
