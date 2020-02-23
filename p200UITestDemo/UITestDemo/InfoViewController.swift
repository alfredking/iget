//
//  InfoViewController.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

let sexKey = "sex"
let agekey = "age"
let feelingKey = "feeling"

class InfoViewController: UIViewController {
    @IBOutlet weak var sexSwitch: UISwitch!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageStep: UIStepper!
    @IBOutlet weak var feelingTxtView: UITextView!
    @IBOutlet weak var modifyBtn: UIButton!
    
    var isChangingInfo = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ageStep.accessibilityIdentifier = "ageStep"
        self.ageStep.minimumValue = 0
        self.ageStep.maximumValue = 100
        self.sexSwitch.isEnabled = false;
        self.ageStep.isEnabled = false;
        self.feelingTxtView.isUserInteractionEnabled = false;
        
        self.title = "读取中.."
        let queue = OperationQueue.init();
        queue.addOperation { () -> Void in
            // 模拟读取数据的过程
            Thread.sleep(forTimeInterval: 2)
            OperationQueue.main.addOperation({ () -> Void in
                self.configInfoView()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configInfoView() {
        let userDef = UserDefaults.standard
        self.title = userDef.string(forKey: "name")
        self.sexSwitch.isOn = userDef.bool(forKey: sexKey)
        let age = userDef.string(forKey: agekey)
        self.ageLabel.text = age;
        if age != nil {
            self.ageStep.value = Double(age!)!
        }
        self.feelingTxtView.text = userDef.string(forKey: feelingKey)
    }
    
    @IBAction func modifyBtnTouch(sender: UIButton) {
        if self.isChangingInfo {
            self.toSaveInfo()
        } else {
            self.toModifyInfo()
        }
    }
    
    func toModifyInfo() {
        self.isChangingInfo = true;
        self.modifyBtn.setTitle("完成", for: [])
        self.sexSwitch.isEnabled = true;
        self.ageStep.isEnabled = true;
        self.feelingTxtView.isUserInteractionEnabled = true;
    }
    
    func toSaveInfo() {
        self.isChangingInfo = false;
        self.feelingTxtView.resignFirstResponder()
        self.modifyBtn.setTitle("修改", for: [])
        self.sexSwitch.isEnabled = false;
        self.ageStep.isEnabled = false;
        self.feelingTxtView.isUserInteractionEnabled = false;
        
        let myTitle = self.title
        self.title = "保存中.."
        self.modifyBtn.isEnabled = false
        
        let queue = OperationQueue.init()
        queue.addOperation { () -> Void in
            // 模拟网络请求过程
            Thread.sleep(forTimeInterval: 2)
            OperationQueue.main.addOperation({ () -> Void in
                self.title = myTitle;
                self.modifyBtn.isEnabled = true
                
                let userDef = UserDefaults.standard
                userDef.set(self.sexSwitch.isOn, forKey: sexKey)
                let age = String(Int(self.ageStep.value))
                userDef.set(age, forKey: agekey)
                let text = self.feelingTxtView.text;
                if text != nil {
                    userDef.set(text, forKey: feelingKey)
                } else {
                    userDef.removeObject(forKey: feelingKey)
                }
            })
        }
    }
    
    @IBAction func ageStepValueChanged(sender: UIStepper) {
        let age = String(Int(self.ageStep.value))
        self.ageLabel.text = age;
    }
    
    @IBAction func clearBtnTouch(sender: AnyObject) {
        self.feelingTxtView.resignFirstResponder()
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.feelingTxtView.resignFirstResponder()
    }
}
