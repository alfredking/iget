//
//  TestFrame.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/19.
//  Copyright © 2019 alfredking. All rights reserved.
//p122 frame bounds

import UIKit		

class TestFrame: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //演示frame和bounds
            let screenWidth = self.view.frame.width;
            let screenHeight = self.view.frame.height;
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/3))
            view1.backgroundColor = UIColor.blue
            print("view1.frame:",view1.frame)
            print("view1.bounds:",view1.bounds)
            self.view.addSubview(view1)
            let view2 = UIView(frame: CGRect(x: 0, y: screenHeight/3, width: screenWidth, height: screenHeight/3))
            view2.backgroundColor = UIColor.red
            print("view2.frame:",view2.frame)
            print("view2.bounds:",view2.bounds)
            self.view.addSubview(view2)
            let view3 = UIView(frame: CGRect(x: 0, y: view2.frame.maxY, width: screenWidth, height: screenHeight/3))
            view3.backgroundColor = UIColor.yellow
            print("view3.frame:",view3.frame)
            print("view3.bounds:",view3.bounds)
            self.view.addSubview(view3)
            let view4 = UIView()
            //view4.frame = CGRect(x: view3.bounds.minX, y: view3.bounds.minY, width: 100, height: 100)
            view4.frame = CGRect(x: view3.frame.minX, y: view3.frame.minY, width: 100, height: 100)
            view4.backgroundColor = UIColor.brown
            view3.addSubview(view4) //如果是frame的话，view4就在屏幕下方了
    
            print("view4.frame:",view4.frame)
            print("view4.bounds:",view4.bounds)
    }

}
