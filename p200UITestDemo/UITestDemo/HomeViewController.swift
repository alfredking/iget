//
//  ViewController.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

let name = "sun"
let psd = "111111"

let myTitle = "登录"
let loadingText = "登录中.."

var firstAppear = true;

class HomeViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var psdField: UITextField!
	
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = myTitle;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtnTouch(sender: UIButton) {
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
        self.title = loadingText;
        sender.isEnabled = false
        let queue = OperationQueue.init();
        queue.addOperation { () -> Void in
            // 模拟验证的过程
            Thread.sleep(forTimeInterval: 2)
            OperationQueue.main.addOperation({ () -> Void in
                self.title = myTitle;
                sender.isEnabled = true
                if self.nameField.text == name && self.psdField.text == psd {
                    let userDef = UserDefaults.standard
                    userDef.set(self.nameField.text!, forKey: "name");
                    let sb = UIStoryboard.init(name:"Main",bundle:Bundle.main)
                    let viewCro = sb.instantiateViewController(withIdentifier: "InfoViewController")
                    self.navigationController!.pushViewController(viewCro, animated: true)
                } else {
                    let alert = UIAlertView.init(title:"",message:"登录失败",delegate:nil,cancelButtonTitle:"确定")
                    alert.accessibilityIdentifier = "loginAlert"
                    alert.accessibilityLabel = "loginAlert"
                    alert.show()
                }
            })
        }
    }

    @IBAction func clearBtnTouch(sender: UIButton) {
        self.nameField.text = nil;
        self.psdField.text = nil;
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
    }
    
    override func viewDidAppear(_ animated: Bool) {
		
    }
}

extension HomeViewController: UIAlertViewDelegate {
    
}
