//
//  TestList.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/19.
//  Copyright © 2019 alfredking. All rights reserved.
//p34

import UIKit

class TestList: NSObject {
    
    func test()
    {
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
        
    }

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
    //dummy表示虚拟节点
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

//快慢指针相遇就有环
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
