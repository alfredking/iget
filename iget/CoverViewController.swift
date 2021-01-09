//
//  CoverViewController.swift
//  iget
//
//  Created by alfredking－cmcc on 2021/1/8.
//  Copyright © 2021 alfredking. All rights reserved.
//

import UIKit


class CoverViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("self.titles?.count is \(String(describing: self.titles.count))" )
        return self.titles.count ;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "covercell", for: indexPath)
        cell.textLabel?.text=String(self.titles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        let className:String = self.classNames[indexPath.row]
//        let vcView = NSClassFromString(clsName! + "." + className) as! UIViewController.Type;
        let vcView = NSClassFromString(className) as! UIViewController.Type;
        let ctrl = vcView.init();
        ctrl.title = titles[indexPath.row];
        self.navigationController?.pushViewController(ctrl ,animated:true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var tableView: UITableView!
    var titles = [String]()
    var classNames = [String]()
    
    
    override func viewDidLoad() {
        
//        self.addCell(title: "深度优先搜索", classname: "ViewController")
        self.addCell(title: "AFNetworking", classname: "AFImageViewController")
        tableView = UITableView(frame: CGRect(x: 0,y: 30,width: self.view.bounds.size.width,height: self.view.bounds.size.height),style: UITableView.Style.plain)
        tableView.delegate=self;
        tableView.dataSource=self;
        self.view.addSubview(tableView);
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"covercell" )
        tableView.reloadData()
        
        
    }
    
    func addCell(title:String,classname:String)->Void
    {
        self.titles.append(title)
        self.classNames.append(classname)
        print("add cell called")
        print("self.titles?.count is \(String(describing: self.titles.count))" )
    
    }
    
    
}
			
