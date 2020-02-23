//
//  UITestDemo_UI_Tests.swift
//  UITestDemo UI Tests
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//p200 ui测试

import Foundation
import XCTest

class UITestDemo_UI_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
		//testLoginView()
       
        
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.textFields["nameField"]/*[[".otherElements[\"myView\"].textFields[\"nameField\"]",".textFields[\"nameField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let psdfieldSecureTextField = app/*@START_MENU_TOKEN@*/.secureTextFields["psdField"]/*[[".otherElements[\"myView\"].secureTextFields[\"psdField\"]",".secureTextFields[\"psdField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        psdfieldSecureTextField.tap()
        psdfieldSecureTextField.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"myView\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
       
        
        //test()
    }
    
        func test()
    {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.textFields["nameField"]/*[[".otherElements[\"myView\"].textFields[\"nameField\"]",".textFields[\"nameField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let psdfieldSecureTextField = app/*@START_MENU_TOKEN@*/.secureTextFields["psdField"]/*[[".otherElements[\"myView\"].secureTextFields[\"psdField\"]",".secureTextFields[\"psdField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        psdfieldSecureTextField.tap()
        psdfieldSecureTextField.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"myView\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts.buttons["确定"].tap()    }
    // 参考地址https://blog.csdn.net/zhao18933/article/details/46621999
    func testLoginView() {
        let app = XCUIApplication()
        
        // 由于UITextField的id有问题，所以只能通过label的方式遍历元素来读取
                //XCUIApplication()/*@START_MENU_TOKEN@*/.textFields["nameField"]/*[[".otherElements[\"myView\"].textFields[\"nameField\"]",".textFields[\"nameField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                let nameField = app/*@START_MENU_TOKEN@*/.textFields["nameField"]/*[[".otherElements[\"myView\"].textFields[\"nameField\"]",".textFields[\"nameField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        if self.canOperateElement(element: nameField) {
            nameField.tap()
            nameField.typeText("sun")
        }
        
        let psdField = app/*@START_MENU_TOKEN@*/.secureTextFields["psdField"]/*[[".otherElements[\"myView\"].secureTextFields[\"psdField\"]",".secureTextFields[\"psdField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        if self.canOperateElement(element: psdField) {
            psdField.tap()
            psdField.typeText("111111")
        }
        
        // 通过UIButton的预设id来读取对应的按钮
        let loginBtn = app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"myView\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        if self.canOperateElement(element: loginBtn) {
            loginBtn.tap()
        }
        
        // 开始一段延时，由于真实的登录是联网请求，所以不能直接获得结果，demo通过延时的方式来模拟联网请求
        let window = app.windows.element(at: 0)
        if self.canOperateElement(element: window) {
            // 延时3秒, 3秒后如果登录成功，则自动进入信息页面，如果登录失败，则弹出警告窗
            window.press(forDuration: 3)
        }
        
        // alert的id和labe都用不了，估计还是bug，所以只能通过数量判断
        if app.alerts.count > 0 {
            // 登录失败
            app.alerts.collectionViews.buttons["确定"].tap()
            
            let clear = app.buttons["Clear"]
            if self.canOperateElement(element: clear) {
                clear.tap()
                
                if self.canOperateElement(element: nameField) {
                    nameField.tap()
                    nameField.typeText("sun")
                }
                
                if self.canOperateElement(element: psdField) {
                    psdField.tap()
                    psdField.typeText("111111")
                }
                
                if self.canOperateElement(element: loginBtn) {
                    loginBtn.tap()
                }
                if self.canOperateElement(element: window) {
                    // 延时3秒, 3秒后如果登录成功，则自动进入信息页面，如果登录失败，则弹出警告窗
                    window.press(forDuration: 3)
                }
                self.loginSuccess()
            }
        } else {
            // 登录成功
            self.loginSuccess()
        }
    }
    
    func loginSuccess() {
        let app = XCUIApplication()
        let window = app.windows.element(at: 0)
        if self.canOperateElement(element: window) {
            // 延时1秒, push view需要时间
            window.press(forDuration: 1)
        }
        self.testInfo()
    }
    
    func testInfo() {
        let app = XCUIApplication()
        let window = app.windows.element(at: 0)
        if self.canOperateElement(element: window) {
            // 延时2秒, 加载数据需要时间
            window.press(forDuration: 2)
        }
        
        let modifyBtn = app.buttons["modify"];
        modifyBtn.tap()
        
        let sexSwitch = app.switches["sex"]
        sexSwitch.tap()
        
        let incrementButton = app.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        app.buttons["Decrement"].tap()
        
        let textView = app.textViews["feeling"]
        textView.tap()
        app.keys["Delete"].tap()
        app.keys["Delete"].tap()
        textView.typeText(" abc ")
        
        // 点击空白区域
        let clearBtn = app.buttons["clearBtn"]
        clearBtn.tap()
		
        // 保存数据
        modifyBtn.tap()
        window.press(forDuration: 2)
        
        let messageBtn = app.buttons["message"]
        messageBtn.tap();
        
        // 延时1秒, push view需要时间
        window.press(forDuration: 1)
        
        self.testMessage()
    }
    
    func testMessage() {
        let app = XCUIApplication()
        let window = app.windows.element(at: 0)
        if self.canOperateElement(element: window) {
            // 延时2秒, 加载数据需要时间
            window.press(forDuration: 2)
        }
        
        let table = app.tables
        table.children(matching: .cell).element(at: 8).tap()
        table.children(matching: .cell).element(at: 1).tap()
        
    }
    
    func getFieldWithLbl(label:String) -> XCUIElement? {
        var result:XCUIElement? = nil
        return self.getElementWithLbl(label: label, type: XCUIElement.ElementType.textField)
    }
    
    func getElementWithLbl(label:String, type:XCUIElement.ElementType) -> XCUIElement? {
        let app = XCUIApplication()
        let query = app.descendants(matching: type)
        var result:XCUIElement? = nil
        for  i in 0...query.count{
            let element:XCUIElement = query.element(at: i)
            let subLabel:String? = element.label;
            if subLabel != nil {
                if subLabel == label {
                    result = element
                }
            }
        }
        return result
    }
	
    func canOperateElement(element:XCUIElement?) -> Bool {
        if element != nil {
            if element!.exists {
                return true
            }
        }
        return false
    }
}
