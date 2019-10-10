//
//  ViewController.swift
//  iget
//
//  Created by alfredking on 2018/11/28.
//  Copyright © 2018年 alfredking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   let  myLeakVC: myLeakViewController = myLeakViewController.init()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //演示frame和bounds
//        let screenWidth = self.view.frame.width;
//        let screenHeight = self.view.frame.height;
//        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/3))
//        view1.backgroundColor = UIColor.blue
//        print("view1.frame:",view1.frame)
//        print("view1.bounds:",view1.bounds)
//        self.view.addSubview(view1)
//        let view2 = UIView(frame: CGRect(x: 0, y: screenHeight/3, width: screenWidth, height: screenHeight/3))
//        view2.backgroundColor = UIColor.red
//        print("view2.frame:",view2.frame)
//        print("view2.bounds:",view2.bounds)
//        self.view.addSubview(view2)
//        let view3 = UIView(frame: CGRect(x: 0, y: view2.frame.maxY, width: screenWidth, height: screenHeight/3))
//        view3.backgroundColor = UIColor.yellow
//        print("view3.frame:",view3.frame)
//        print("view3.bounds:",view3.bounds)
//        self.view.addSubview(view3)
//        let view4 = UIView()
//        //view4.frame = CGRect(x: view3.bounds.minX, y: view3.bounds.minY, width: 100, height: 100)
//        view4.frame = CGRect(x: view3.frame.minX, y: view3.frame.minY, width: 100, height: 100)
//        view4.backgroundColor = UIColor.brown
//        view3.addSubview(view4) //如果是frame的话，view4就在屏幕下方了
//
//        print("view4.frame:",view4.frame)
//        print("view4.bounds:",view4.bounds)
        // Do any additional setup after loading the view, typically from a nib.
        //在 Arrays.swift 中,主要定义了 Array, ContiguousArray 和ArraySlice 三种public 类型,它们具有相同的接口,而且结构和行为也很类似
        
//        self.view.backgroundColor = UIColor.blue
//
//        let mainlabel: UILabel! = UILabel(frame:CGRect(x:10, y:20, width:300, height:100))
//        mainlabel.backgroundColor = UIColor.white //原来不设置颜色就是透明的
//
//        self.view.addSubview(mainlabel)
//
//
//
//        myLeakVC.testMethod()
//
//        //myLeakVC.view.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
//
//        let tapGestrue:UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tapBack))
//
//        self.view.addGestureRecognizer(tapGestrue)
       

        
//        var matrix :[[Character]] = [["a","d","d","f","w"],["f","h","j","u","i"],["i","d","j","d","s"],["h","k","s","w","i"],["o","r","u","a","z"]]
//            print(matrix[0].count)
//            var xOffset = CGFloat(0)
//            var yOffset = CGFloat(0)
//            let cellWidth = UIScreen.main.bounds.size.width/CGFloat(matrix[0].count)
//            let cellHeight = UIScreen.main.bounds.size.height/CGFloat(matrix[0].count)
//
//            for i in 0..<matrix.count
//            {
//            for j in 0..<matrix.count
//            {
//            let label = UILabel(frame: CGRect(x:xOffset,y:yOffset,width:cellWidth,height:cellHeight))
//            label.textAlignment = NSTextAlignment.center
//            label.text = String(matrix[i][j])
//            view.addSubview(label)
//            //labels.append(label)
//            xOffset+=cellWidth
//
//            }
//            xOffset=0
//            yOffset+=cellHeight
//            }
//        print("**************trie findwords*********************")
//        let wordDict=["hdjds","test","hkru","dksu"]
//        let   resWords = findWords(matrix,wordDict)
//        print(resWords)
//
//        print("**************dp test*********************")
//
//        print(wordDistance("test", "dp"))
//        print(wordDistance("test", "te"))
//        print(wordDistance("test", "testa"))
//
//
//
//        var arr=[0,0,0]
//        var newArr = arr
//        arr[0]=1
//        print(arr)
//        print(newArr)
        //https://blog.csdn.net/super_niuxinhuai/article/details/81361958
        changedMap { (source) in
            print("逃逸闭包拿到的结果是\(source)")
        }

        
  //编码解码
//        let res = """
//                        {
//                            "x": 12,
//                            "y": 13
//                        }
//                        """
//        let data = res.data(using: .utf8)!
//
//        let decoder = JSONDecoder()
//        let stu = try! decoder.decode(Ponit2D.self, from: data)
//        print(stu)
//        print("decode finish")
//
//
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted //输出格式好看点
//        let result = try! encoder.encode(stu)
//        print(String(data: result, encoding: .utf8)!)
//
//
//        let point = """
//                {
//                    "x" : 1,
//                    "y" : 1,
//                    "z" : 1
//                }
//                """
//        let pointdata = point.data(using: .utf8)!
//        let p2 = try! decoder.decode(Ponit3D.self, from:pointdata)
//        print("p2 type")
//        print(p2)
        
        
        //testSerial()
        //testConcurrent()
        
        //raceCondition()
      
        
        //propertyInversion()
        
        
        // 竞态条件
        let raceCondition : RaceCondition = RaceCondition.init()
        //raceCondition.someString("test")
        for i in 1...101
        {
          let user = User(idin: "1",namein: "alfredking")
          raceCondition.setUser(_user: user)
            if (i == 101)
            {
                let user = User(idin: "1",namein: "alfredking100")
                raceCondition.setUser(_user: user)
            }
            
        }
        print("竞态条件")
        print("\(raceCondition.getUser(id: "myModel").name!)")
        raceCondition.test()
        
        
        testOperation()
        
        //cancel测试
        let operationTest : OperationTest = OperationTest.init()
        operationTest.testCancel()
        
        //swift kvo测试
        let swiftKvo : kvo = kvo.init()
        swiftKvo.test()
        
        //protocol extension
        let pop : POP = POP.init()
        pop.test()
        

    
        
        
        
        
    }
    
    //https://www.jianshu.com/p/745ef335e8cc 比较好的解释
    func testSerial()
    {
        let serialQueue = DispatchQueue(label: "dispatch_demo.tsaievan.com")
        let mainQueue = DispatchQueue.main
        let sAdd = String(format: "%p", serialQueue)
        let mAdd = String(format: "%p", mainQueue)
//        serialQueue.sync {
//            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
//        }
//        print("\(Thread.current)========2")
//        serialQueue.sync {
//            print("\(Thread.current)========3")
//        }
//        print("\(Thread.current)========4")
        
        
        
//        serialQueue.async {
//            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
//        }
//        print("\(Thread.current)========2")
//        serialQueue.async {
//            print("\(Thread.current)========3")
//        }
//        print("\(Thread.current)========4")
//
        
        
//        //串行同步
//        serialQueue.sync{
//            print(1)
//        }
//
//        print(2)
//
//        serialQueue.sync{
//            print(3)
//        }
//        print(4)
        
        
//        //串行异步
        serialQueue.async {
            sleep(3)
            print(1)
        }

        print(2)
        serialQueue.async {
            print(3)
        }
        print(4)
        
        
//        //串行异步中嵌套同步
//        print(1)
//        serialQueue.async {
//            print(2)
//            serialQueue.sync {
//                print(3)
//            }
//            print(4)
//        }
//
//        print(5)
        
        
        //串行同步中嵌套异步
//        print(1)
//        serialQueue.sync {
//            print(2)
//            serialQueue.async {
//                print(3)
//            }
//            print(4)
//        }
//        print(5)
    }
    
    
    func testConcurrent()
    {
        let concurrentQueue = DispatchQueue(label: "com.leo.concurrentQueue",
                                            attributes:.concurrent)
        
        //并行同步
//        concurrentQueue.sync {
//            print(1)
//        }
//        print(2)
//        concurrentQueue.sync {
//            print(3)
//        }
//        print(4)
        
        //并行异步
//        concurrentQueue.async {
//            //增加延时操作可以让3出现在1之前，串行队列中无法实现
//            sleep(3)
//            print(1)
//        }
//        print(2)
//        concurrentQueue.async {
//            print(3)
//
//        }
//        print(4)

        //并行异步中嵌套同步
//        print(1)
//        print("\(Thread.current)========1")
//        concurrentQueue.async {
//            print(2)
//
//             print("\(Thread.current)========2")
//            concurrentQueue.sync {
//                print(3)
//                 print("\(Thread.current)========3")
//            }
//            print(4)
//             print("\(Thread.current)========4")
//        }
//        print(5)
//         print("\(Thread.current)========5")
//        //并行同步中嵌套异步
//        print(1)
//        print("\(Thread.current)========1")
//        concurrentQueue.sync {
//            print(2)
//            print("\(Thread.current)========2")
//            concurrentQueue.async {
//                print(3)
//                print("\(Thread.current)========3")
//            }
//            print(4)
//            print("\(Thread.current)========4")
//        }
//        print(5)
//        print("\(Thread.current)========5")
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
    
    func propertyInversion()
    {
        let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
        let lowPriorityQueue = DispatchQueue.global(qos: .utility)
        
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait() //放在这里可以改变顺序
        lowPriorityQueue.async {
            //semaphore.wait() 放这里不改变顺序
            for i in 0...10{
                print(i)
            }
            semaphore.signal()
        }
        
        highPriorityQueue.async {
            semaphore.wait()
            for i in 11...20{
                print(i)
            }
            semaphore.signal()
        }
        
        
        
    }
    
    func testOperation()
    {
//        let multiTasks = BlockOperation()
//        multiTasks.completionBlock = {
//            print("所有任务完成")
//        }
//
//        multiTasks.addExecutionBlock {
//            print("任务1开始")  ;
//            sleep(1)
//        }
//
//        multiTasks.addExecutionBlock {
//            print("任务2开始")  ;
//            sleep(2)
//        }
//
//        multiTasks.addExecutionBlock {
//            print("任务3开始")  ;
//            sleep(3)
//        }
//
//        multiTasks.start();
//
        
        let multiTaskQueue = OperationQueue()
        multiTaskQueue.addOperation {
            print("任务1开始")  ;
            sleep(1)
            }
        
        multiTaskQueue.addOperation {
            print("任务2开始")  ;
            sleep(2)
        }
        multiTaskQueue.addOperation {
            print("任务3开始")  ;
            sleep(3)
        }
        //阻塞当前线程直到所有操作完成
        multiTaskQueue.waitUntilAllOperationsAreFinished()
    }
    
//    func testBarrier()
//    {
//        try storage.getUser(id)
//    }
    
    //逃逸闭包的例子
    func changedMap(block: @escaping (_ result: Int) ->Swift.Void){
        DispatchQueue.global().async {
            print("逃逸闭包异步的走\(Thread.current)")
            DispatchQueue.main.async {
                print("逃逸闭包主线程的走\(Thread.current)")
                block(99)
            }
        }
        print("逃逸闭包结束了的走")
    }
    
   
    
    

    
    
    @objc func tapBack()
    {
         self.navigationController?.pushViewController(myLeakVC, animated: true)
    }

    
   

}



class Ponit2D: Codable {
    var x = 0.0
    var y = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(Double.self, forKey: .x)
        let y = try container.decode(Double.self, forKey: .y)
        self.x = x
        self.y = y
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    
}

class Ponit3D: Ponit2D {
    var z = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case z
        case point2D
    }
    
    init(x: Double, y: Double, z: Double) {
        super.init(x: x, y: y)
        self.z = z
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let z = try container.decode(Double.self, forKey: .z)
        self.z = z
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 创建一个提供给父类encode的容器来区分父类属性和派生类属性
        try super.encode(to: container.superEncoder())
        try container.encode(z, forKey: .z)
    }
}
