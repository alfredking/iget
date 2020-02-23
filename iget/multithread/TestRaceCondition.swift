//
//  TestRaceCondition.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//p158 竞态条件

import UIKit

class TestRaceCondition: NSObject {
    func test()
    {
        
        //raceCondition()
        // 竞态条件
        let raceCondition : RaceCondition = RaceCondition.init()
        //raceCondition.someString("test")
        for i in 1...101
        {
            let user = User(idin: String(i) as String,namein: "alfredking")
            raceCondition.setUser(_user: user) {
                print("raceCondition.setUser")
            }
           
            if (i == 101)
            {
                let user = User(idin: "1",namein: "alfredking100")
                raceCondition.setUser(_user: user){
                    print("raceCondition.setUser101")
                }
            }
            
        }
        print("竞态条件")
        raceCondition.getUser(id: "1") { (usr: RaceCondition.Result<User>) in
            
            print("raceCondition.getUser***********************")
            
    
            print(usr)
            print("raceCondition.getUser***********************")
        }
        
        //raceCondition.test()
    }

    
    func raceCondition()
    {
        var num = 0
        DispatchQueue.global().async {
            for _ in 1...10000{
                num += 1
            }
        }
        
        for _ in 1...10000{
            num += 1
        }
        print("raceCondition")
        print(num)
    }
}
