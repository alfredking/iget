//
//  TestLeak.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/26.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TestLeak: UIViewController {

    let  myLeakVC: myLeakViewController = myLeakViewController.init()
    override func viewDidLoad() {
        super.viewDidLoad()

                self.view.backgroundColor = UIColor.blue
        
                let mainlabel: UILabel! = UILabel(frame:CGRect(x:10, y:20, width:300, height:100))
                mainlabel.backgroundColor = UIColor.white //原来不设置颜色就是透明的
        
                self.view.addSubview(mainlabel)
        
        
        
                myLeakVC.testMethod()
        
                //myLeakVC.view.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        
                let tapGestrue:UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        
                self.view.addGestureRecognizer(tapGestrue)
    }
    

    @objc func tapBack()
    {
        self.navigationController?.pushViewController(myLeakVC, animated: true)
    }


}
