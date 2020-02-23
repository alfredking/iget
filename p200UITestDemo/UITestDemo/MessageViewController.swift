//
//  MessageViewController.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/23.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

let cellId = "cellId"

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier);
        }
        
    
        cell?.detailTextLabel?.text = "待添加内容";
        cell?.detailTextLabel?.font = UIFont .systemFont(ofSize: CGFloat(13))
        cell?.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
        
       
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataList:[String]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "读取中.."
//        self.tableView.registerClass(MessageCell.classForCoder(), forCellReuseIdentifier: cellId)
        
        let queue = OperationQueue.init();
        queue.addOperation { () -> Void in
            // 模拟读取数据的过程
            Thread.sleep(forTimeInterval: 2)
            OperationQueue.main.addOperation({ () -> Void in
                self.title = "我的消息"
                self.getData()
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getData() {
        self.dataList = ["Hello，sun。恭喜你注册成功！","你的密码即将过期，请及时修改，以保证账户安全","你的密码已修改，请注意","你获得VIP体验券一张，有效期是一个月，请尽快使用，谢谢！","ksngoa将你添加为好友","sibo将你添加为好友","min将你拉入黑名单","恭喜你获得了1000个积分奖励，积分可以兑换VIP体验券、动态表情等礼物，详情可留意积分兑换页面。","消息错误"]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataList != nil {
            return self.dataList!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MessageCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! MessageCell
        if self.dataList == nil {
            return cell
        }
        
        if indexPath.row >= self.dataList!.count {
            return cell
        }
        
        let msg:String = self.dataList![indexPath.row]
        let label = cell.msgLabel
        label?.text = msg
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

class MessageCell: UITableViewCell {
    @IBOutlet weak var msgLabel: UILabel!
}
