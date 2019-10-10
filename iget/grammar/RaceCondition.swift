//
//  RaceCondition.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/9/14.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class RaceCondition: NSObject {
    
    //OC实现
//    _asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    - (NSString *)someString {
//    __block NSString *localSomeString = nil;
//    dispatch_sync(_asyncQueue, ^{
//    localSomeString = _someString;
//    });
//    return localSomeString;
//    }
//
//    - (void)setSomeString:(NSString *)someString {
//    dispatch_barrier_async(_asyncQueue, ^{
//    _someString = someString;
//    });
//    }
    
    
//    var asyncQueue = DispatchQueue.global();
//    var _someString: NSString = ""
//    var someString: NSString {
//        get {
//            // 读数据时使用并行
//            self.asyncQueue.async {
////                localString = self.someString;
//
//              self.someString = self._someString;
//            }
//            return self._someString;
//
//
//        }
//        set {
//            // 写数据时使用串行
//            asyncQueue.sync(flags: .barrier, execute: {
////                self.someString = newValue
//                //self.someString = newValue 死循环
//                self._someString = newValue
//            });
//        }
//    }
    
    let serialQueue = DispatchQueue(label: "dispatch_demo.tsaievan.com")
    let concurrentQueue = DispatchQueue(label: "com.leo.concurrentQueue",
                                        attributes:.concurrent)
    
    
    func test()
    {
        let userDefault = UserDefaults.standard
        
        //自定义对象存储
        let model = UserInfo(name: "航歌", phone: "3525")
        //实例对象转换成Data
        let modelData = NSKeyedArchiver.archivedData(withRootObject: model)
        //存储Data对象
        userDefault.set(modelData, forKey: "myModel")
        
        //自定义对象读取
        let myModelData = userDefault.data(forKey: "myModel")
        let myModel = NSKeyedUnarchiver.unarchiveObject(with: myModelData!) as! UserInfo
        print(myModel.name)
        
    }
//串行队列同步没有问题
    func getUser(id:String) ->User {



        return  serialQueue.sync{
            return  storageGetUser(id: id)
        }
    }

    func setUser(_user:User) {



          serialQueue.sync{
             storageSetUser(_user: _user)
        }
    }

    //串行队列异步
    enum Result<T>
    {
        case value(T)
        
        case error(Error)
    }
    
//    func getUser(id:String ,completion :@escaping (Result<User>) -> Void)->User{
//
//        var user:User!
//
//          serialQueue.async{
//             user =  self.storageGetUser(id: id)
//            completion(.value(user))
//        }
//
//        return user
//    }
//
//    func setUser(_user:User,completion :@escaping (Result<User>) -> Void) {
//
//
//        serialQueue.async{
//            self.storageSetUser(_user: _user)
//            completion(.value(_user))
//
//        }
//    }
    //并行barrier方法
//    func getUser(id:String )->User{
//
//        var user:User!
//
//        concurrentQueue.sync {
//            user =  self.storageGetUser(id: id)
//
//        }
//
//        return user
//    }
//
//    func setUser(_user:User,completion :@escaping (Result<User>) -> Void) {
//
//
//        concurrentQueue.async(flags: .barrier){
//            self.storageSetUser(_user: _user)
//            completion(.value(_user))
//
//        }
//    }
    
    func storageGetUser(id:String)->User!
    {
        let myModelData = UserDefaults.standard.data(forKey:id)
        let myModel = NSKeyedUnarchiver.unarchiveObject(with: myModelData!) as! User
        
        return myModel
    }
    
    func storageSetUser(_user:User)
    {
        //实例对象转换成Data
        let modelData = NSKeyedArchiver.archivedData(withRootObject: _user)
        //存储Data对象
        UserDefaults.standard.set(modelData, forKey: "myModel")
        
        UserDefaults.standard.synchronize()
    }
}

    @objc(_TtCC4iget13RaceCondition4User)class User: NSObject,NSCoding{
   
    
    
    var id: String? = ""
    var name: String? = ""
    
    func encode(with aCoder:NSCoder){
        aCoder.encode(id,forKey:"id")
        aCoder.encode(name,forKey:"name")
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(name, forKey: "name")
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    

    
    
    init(idin:String,namein:String) {
        id = idin
        name = namein
    }
    
    
    
}


//----- 自定义对象类 -----
class UserInfo: NSObject, NSCoding {
    var name:String
    var phone:String
    
    //构造方法
    required init(name:String="", phone:String="") {
        self.name = name
        self.phone = phone
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "Name") as? String ?? ""
        self.phone = decoder.decodeObject(forKey: "Phone") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey:"Name")
        coder.encode(phone, forKey:"Phone")
    }
}
