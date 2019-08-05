//
//  myLeakViewController.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/4.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class myLeakViewController: UIViewController {

    var label: UILabel! = UILabel(frame:CGRect(x:10, y:20, width:300, height:100))
    
    var myView: MyView?
    func testMethod() {
        label.text = "haha"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(label);
         myView = MyView(action: testMethod)
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
