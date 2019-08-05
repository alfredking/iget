//
//  ViewController.swift
//  iget
//
//  Created by alfredking on 2018/11/28.
//  Copyright © 2018年 alfredking. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //在 Arrays.swift 中,主要定义了 Array, ContiguousArray 和ArraySlice 三种public 类型,它们具有相同的接口,而且结构和行为也很类似
        
        let  myLeakVC: myLeakViewController = myLeakViewController();
        [self.navigationController?, pushViewController(myLeakVC, animated: YES)];
        let say="hello swift"
        print(say)
        let nums=[1,2,3]
        print(nums)
        let nums1=[Int](repeating:0,count:5)
        print(nums1)
        var nums2=[3,1,2,4,6,7,1,2,8,9]
        print(nums2)
        nums2.append(4)
        print(nums2)
        
        nums2.sort()
        print(nums2)
        
        nums2.sort(by: >)
        print(nums2)
        
        let anotherNums=Array(nums2[0..<nums2.count-1])
        print(anotherNums)
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
        
        
        var matrix :[[Character]] = [["a","d","d","f","w"],["f","h","j","u","i"],["i","d","j","d","s"],["h","k","s","w","i"],["o","r","u","a","z"]]
            print(matrix[0].count)
            var xOffset = CGFloat(0)
            var yOffset = CGFloat(0)
            let cellWidth = UIScreen.main.bounds.size.width/CGFloat(matrix[0].count)
            let cellHeight = UIScreen.main.bounds.size.height/CGFloat(matrix[0].count)
            
            for i in 0..<matrix.count
            {
            for j in 0..<matrix.count
            {
            let label = UILabel(frame: CGRect(x:xOffset,y:yOffset,width:cellWidth,height:cellHeight))
            label.textAlignment = NSTextAlignment.center
            label.text = String(matrix[i][j])
            view.addSubview(label)
            //labels.append(label)
            xOffset+=cellWidth
            
            }
            xOffset=0
            yOffset+=cellHeight
            }
        print("**************trie findwords*********************")
        let wordDict=["hdjds","test","hkru","dksu"]
        let   resWords = findWords(matrix,wordDict)
        print(resWords)
        
        print("**************dp test*********************")
        
        print(wordDistance("test", "dp"))
        print(wordDistance("test", "te"))
        print(wordDistance("test", "testa"))
        
        
        
        var arr=[0,0,0]
        var newArr = arr
        arr[0]=1
        print(arr)
        print(newArr)
        
        
    }


}

