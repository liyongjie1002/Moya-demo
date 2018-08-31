//
//  ViewController.swift
//  Moya-demo
//
//  Created by 李永杰 on 2018/8/31.
//  Copyright © 2018年 muheda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/*
 1. 请求数据
 2. 给全局的数据源数组赋值
 3. 绑定tableview的数据源
 */

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    var tableView: UITableView!
    var dataArr = BehaviorRelay(value: [SectionModel<String,Channel>]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加tableview
        tableView = UITableView(frame: self.view.frame,style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        self.view.addSubview(tableView)
        //请求数据
        requestData()
        //tableview的数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Channel>>(configureCell: {(dataSource,tv,indexPath,model) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
            cell.textLabel?.text = model.name
            return cell
        })
        //数组绑定数据源
        dataArr
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //tableview点击事件
        tableView.rx.modelSelected(Channel.self)
            .map{ $0.channel_id! }
            .flatMap{ DouBanProvider.rx.request(.playlist($0)!) }
            .mapJSON()
            .subscribe(onNext:{ [weak self] data in
                if let json = data as? [String: Any],
                    let musics = json["song"] as? [[String: Any]]{
                    let artist = musics[0]["artist"]!
                    let title = musics[0]["title"]!
                    let message = "歌手：\(artist)\n歌曲：\(title)"
                    //将歌曲信息弹出显示
                    self?.showInfo(title: "歌曲信息", message: message)
                }
            })
        .disposed(by: disposeBag)
    }
    
    private func requestData() {
        DouBanProvider
        .rx
        .request(.channels)
        .mapModel(Douban.self)
            .subscribe(onSuccess: { douban in
                if let channels = douban.channels {
                    self.dataArr.accept([SectionModel(model: "1", items: channels)])
                }
            },onError: { error in
                print("请求错误",error)
            })
        .disposed(by: disposeBag)

    }

    private func showInfo(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

