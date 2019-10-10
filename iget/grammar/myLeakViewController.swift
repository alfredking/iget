//
//  myLeakViewController.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/4.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class myLeakViewController: UIViewController {

    var label: UILabel! = UILabel(frame:CGRect(x:100, y:200, width:300, height:100))
    
    var myView: MyView?
    func testMethod() {
        label.textColor = UIColor.black
        label.text = "haha"
    }
    
//    var myView: MyView? = MyView(){ [unowned self] in
//         self.label.text = "haha"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellow
        label.backgroundColor = UIColor.white
        self.view.addSubview(label)
         myView = MyView(action: testMethod)
        
        let tapGestrue:UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        
        self.view.addGestureRecognizer(tapGestrue)
    }
    
    
    @objc func tapBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
