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
        

    
        
        func twoSumSet(nums: [Int], target: Int) -> [Int]
        {
            var dict = [Int: Int]()
            
            for (i, num) in nums.enumerated()
            {
                if let lastIndex = dict[target - num]
                {
                    return [lastIndex, i]
                }
                else
                {
                    dict[num] = i
                    print([i,num])
                }
            }
            
            fatalError("No valid output!")
        }
        
        func twoSum(nums: [Int], target: Int) -> Bool {
            var set = Set<Int>()
            
            for num in nums {
                if set.contains(target - num) {
                    return true
                }
                
                set.insert(num)
            }
            
            return false
        }
        
        fileprivate func _reverse<T>(_ chars: inout [T],_ start: Int,_ end : Int)
        {
            var start = start,end = end
            while start<end
            {
                _swap(&chars,start,end)
                start+=1
                end-=1
            }
            
        }
        
        fileprivate func _swap<T>(_ chars :inout [T],_ p:Int,_ q:Int)
        {
            (chars[p],chars[q])=(chars[q],chars[p])
        }
        
        func _reverseWords(_ s:String?)->String?
        {
            guard let s=s else
            {
                return nil
            }
            var chars = Array(s),start=0
            _reverse(&chars, 0, chars.count-1)
            print(chars)
            
            for i in 0..<chars.count
            {
                print(i)
                if i==chars.count-1||chars[i+1]==" "
                {
                    _reverse(&chars, start, i)
                    start=i+2
                }
            }
            
            return String(chars)
            
        }
        
        class ListNode
        {
            var val:Int
            var next:ListNode?
            
            init(_ val:Int)
            {
                self.val=val
                self.next=nil
            }
        }
        
        class List
        {
            var head:ListNode?
            var tail:ListNode?
            
            func appendToTail(_ val:Int)
            {
                if tail==nil
                {
                    tail=ListNode(val)
                    head=tail
                }
                else
                {
                    tail!.next=ListNode(val)
                    tail=tail!.next
                }
            }
            
            func appendToHead(_ val:Int)
            {
                if head==nil
                {
                    head=ListNode(val)
                    tail=head
                    
                    
                }
                else
                {
                    let temp=ListNode(val)
                    temp.next=head
                    head=temp
                }
            }
            
        }
        
        func getLeftList(_ head:ListNode?,_ x:Int)->ListNode?
        {
            let dummy=ListNode(0)
            var pre=dummy
            var node = head
            
            while node != nil
            {
                if node!.val<x
                {
                    pre.next=node
                    pre=node!
                }
                node=node!.next
            }
            
            //防止构成环
            //node.next=nil
            pre.next=nil
            return dummy.next
            
        }
        
        func partition(_ head:ListNode?,_ x:Int)->ListNode?
        {
            let preDummy = ListNode(0)
            var prev=preDummy
            let postDummy=ListNode(0)
            var post=postDummy
            var node = head
            
            while node != nil
            {
                if node!.val<x
                {
                    prev.next=node
                    prev=node!
                }
                else
                {
                    post.next=node
                    post=node!
                }
                node=node!.next
            }
            
            post.next=nil
            prev.next=postDummy.next
            return preDummy.next
            
            
        }
        
        func hasCycle(_ head : ListNode?)-> Bool
        {
            var slow = head
            var fast = head
            while fast != nil && fast!.next != nil
            {
                slow=slow!.next
                fast=fast!.next!.next
                
                if slow === fast
                {
                    return true
                }
                
            }
            return false
            
        }
        
        func removeNthFromEnd(_ head:ListNode?,_ n :Int)->ListNode?
        {
            guard let head = head
                else
            {
                return nil
            }
            
            let dummy = ListNode(0)
            dummy.next = head
            var prev :ListNode? = dummy
            var post :ListNode? = dummy
            
            //设置最后一个节点初始位置
            for _ in 0 ..< n
            {
                if post == nil
                {
                    break
                }
                post=post!.next
            }
            
            //同时移动前后节点
            while post != nil && post!.next != nil
            {
                prev=prev!.next
                post=post!.next
            }
            
            //删除节点
            prev!.next=prev!.next!.next
            
            return dummy.next
            
            
            
        }
        
        func printList(_ head : ListNode?)
        {
            var list_head=head
            while list_head != nil
            {
                print((list_head?.val)!)
                list_head=list_head?.next
            }
        }
        
        protocol Stack
        {
            associatedtype Element
            var isEmpty :Bool {get}
            var size:Int {get}
            var peak: Element? {get}
            
            mutating func push(_ newElement: Element)
            mutating func pop()->Element?
            
        }
        
        struct integerStack:Stack
        {
            typealias Element = Int
            var isEmpty: Bool { return stack.isEmpty }
            var size: Int {return stack.count}
            var peak: Element? {return stack.last}
            private var stack = [Element]()
            
            mutating func push(_ newElement: Element)
            {
                stack.append(newElement)
            }
            
            mutating func pop() -> Element?
            {
                return stack.popLast()
            }
            
        }
        
        protocol Queue
        {
            associatedtype Element
            var isEmpty : Bool {get}
            var size : Int {get}
            var peak : Element? {get}
            
            mutating func enqueue(_ newElement :Element)
            mutating func dequeue()->Element?
            
        }
        
        struct integerQueue:Queue
        {
            typealias Element = Int
            
            private var left=[Element]()
            private var right=[Element]()
            
            var isEmpty: Bool {return left.isEmpty&&right.isEmpty}
            var size: Int {return left.count+right.count}
            var  peak:  Element? {return left.isEmpty ? right.first : left.last}
            
            mutating func enqueue(_ newElement: Element)
            {
                right.append(newElement)
            }
            
            mutating func dequeue() -> Element?
            {
                if left.isEmpty
                {
                    left=right.reversed()
                    right.removeAll()
                }
                return left.popLast()
            }
            
            
            
            
            
        }
        
        func simplifyPath(_ path : String)->String
        {
            var pathStack = [String]()
            let paths = path.components(separatedBy: "/")
            
            for path in paths
            {
                guard path != "."
                    else
                {
                    continue
                }
                
                if path == ".."
                {
                    if(pathStack.count>0)
                    {
                        pathStack.removeLast()
                    }
                }
                else if (path != "")
                {
                    pathStack.append(path)
                }
            }
            
            
            print(pathStack)
            
            //难道是闭包编程？
            let res = pathStack.reduce(""){total,dir in "\(total)/\(dir)"}
            
            print(res)
            
            return res.isEmpty ? "/" : res
            
            
        }
        
        
        struct MyQueue
        {
            var stackA : integerStack
            var stackB : integerStack
            
            var isEmpty : Bool
            {
                return stackA.isEmpty && stackB.isEmpty
            }
            
            var peak : Any?
            {
                mutating get
                {
                    shift()
                    return stackB.peak
                }
                
            }
            
            var size : Int
            {
                get
                {
                    return stackA.size+stackB.size
                }
            }
            
            init()
            {
                stackA=integerStack()
                stackB=integerStack()
            }
            
            mutating func enqueue (object : Any)
            {
                stackA.push(object as! integerStack.Element)
            }
            
            mutating func dequeue() -> Any?
            {
                shift()
                return stackB.pop()
            }
            
            fileprivate mutating func shift()
            {
                if stackB.isEmpty
                {
                    while !stackA.isEmpty
                    {
                        stackB.push(stackA.pop()!)
                    }
                }
            }
            
            
        }
        
        struct MyStack
        {
            var queueA : integerQueue
            var queueB : integerQueue
            
            init()
            {
                queueA=integerQueue()
                queueB=integerQueue()
            }
            
            var isEmpty : Bool
            {
                return queueA.isEmpty && queueB.isEmpty
            }
            
            var peak : Any?
            {
                mutating get
                {
                    shift()
                    let peakObj = queueA.peak
                    queueB.enqueue(queueA.dequeue()!)
                    swap()
                    return peakObj
                    
                }
            }
            
            var size :Int
            {
                return queueA.size
            }
            
            mutating func push(object : Any)
            {
                queueA.enqueue(object as! integerQueue.Element)
            }
            
            mutating func pop() -> Any?
            {
                shift()
                let popObject = queueA.dequeue()
                swap()
                return popObject
                
            }
            
            private mutating func shift()
            {
                while queueA.size != 1
                {
                    queueB.enqueue(queueA.dequeue()!)
                }
            }
            
            private mutating func swap()
            {
                (queueA,queueB) = (queueB,queueA) //swift元组
            }
            
        }
        
        func isStrNum(str:String)->Bool
        {
            return Int(str) != nil
        }
        
        
        let result=Dictionary("hello".map { ($0, 2) }, uniquingKeysWith: +)
        print(result)
        
        
        
        let test=twoSum(nums: [3,1,2,4,6,7,1,2,8,9],target:5)
        print(test)
        
        let str="3"
        let num=Int(str)
        let number=3
        let string=String(number)
        print(str,num!,string,number)
        
        let len=str.count
        print(len)
        
        let char=str[str.index(str.startIndex, offsetBy: 0)]
        print(char)
        
        var mstr="123"
        mstr.remove(at:str.index(str.startIndex, offsetBy: 1))
        mstr.append("c")
        mstr+="hello WORLD"
        print(mstr)
        
        
        
        let re=isStrNum(str:mstr)
        print(re)
        
        
        let hello=_reverseWords("hello alfred king")
        print(hello!)
        
        
        let testlist=ListNode(4)
        let test_list=List()
        test_list.head = testlist
        test_list.appendToHead(3)
        test_list.appendToHead(8)
        test_list.appendToHead(12)
        test_list.appendToHead(17)
        test_list.appendToHead(6)
        printList(test_list.head)
        
        let list_result=partition(test_list.head, 5)
        print((list_result?.val)!)
        
        print(removeNthFromEnd(list_result, 2)!)
        
        printList(list_result)
        
        print(simplifyPath("/a/./b/../../home/"))
        print(simplifyPath("/a/./b/c/123/home/"))
        
        print("**************队列栈测试*********************")
        var teststack=MyStack()
        teststack.push(object: 3)
        teststack.push(object: 5)
        teststack.push(object: 7)
        teststack.push(object: 9)
        
        print(teststack)
        print((teststack.peak)!)
        teststack.push(object: 34)
        teststack.push(object: 10)
        print((teststack.pop())!)
        print(teststack)
        print((teststack.peak)!)
        
        
        print("**************binary tree test*********************")
        let  root = TreeNode(5)
        root.left = TreeNode(3)
        root.right=TreeNode(7)
        root.left?.left=TreeNode(13)
        root.left?.right=TreeNode(9)
        root.right?.left=TreeNode(15)
        root.right?.right=TreeNode(25)
        
        let depth=maxDepth(root)
        print(depth)
        
        let pre = preorderTraversal(root)
        print(pre)
        
        let level = levelOrder(root)
        print(level)
        
        
        
        print("**************sorting test*********************")
        
        let merge = mergeSort([8,4,5,7,1,3,6,2])
        print(merge)
        var  meetings = [MeetingTime(1,3),MeetingTime(2,4),MeetingTime(5,7),MeetingTime(13,17),MeetingTime(9,10),MeetingTime(6,7),MeetingTime(6,8)]
        let conf = mergeTime(&meetings)
        print(conf)
        
        print(binarySearch([1,4,5,6,7,88,56],6))
        print(binarySearch([1,4,5,6,7,88,56],12))
        
        print(search([7,8,9,1,2,3,4,5,6],4))
        
        print("**************news test*********************")
        testnews()
        

        
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
