//
//  BinaryTree.swift
//  iget
//
//  Created by alfredking－cmcc on 2018/12/24.
//  Copyright © 2018 alfredking. All rights reserved.
//

import UIKit


public class TreeNode
{
    public var val : Int
    public var left : TreeNode?
    public var right : TreeNode?
    public init(_ val : Int)
    {
        self.val=val
    }
    
}

func maxDepth(_ root : TreeNode?)->Int
{
    guard let root=root
    else
    {
        return 0
    }
    
    return max(maxDepth(root.left), maxDepth(root.right))+1
}

func isvalidBST(_ root : TreeNode?) -> Bool
{
    return _helper(root,nil,nil)
}

private func _helper(_ node : TreeNode? , _ min : Int?,_ max : Int?)->Bool
{
    guard let node = node
    else
    {
        return true //它或者是一棵空树，或者是具有下列性质的二叉树
    }
    
    if let min=min , node.val <= min
    {
        return false
    }
    
    if let max=max , node.val >= max
    {
        return false
    }
    
    return _helper(node.left,min, node.val)&&_helper(node.right, node.val, max)
    
    
}

func preorderTraversal(_ root : TreeNode?)-> [Int]
{
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    
    while !stack.isEmpty || node != nil
    {
        if node != nil
        {
            res.append(node!.val)
            stack.append(node!)
            node = node!.left
        }
        else
        {
            node = stack.removeLast().right
        }
    }
    return res

}

func levelOrder(_ root : TreeNode?)-> [[Int]]
{
    var res = [[Int]]()
    var queue = [TreeNode]()
    
    if let root = root
    {
        queue.append(root)
    }
    
    while queue.count > 0
    {
        let size = queue.count
        var level = [Int]()
        
        for _ in 0 ..< size
        {
            let node = queue.removeFirst()
            
            level.append(node.val)
            if let left = node.left
            {
                queue.append(left)
            }
            
            if let right = node.right
            {
                queue.append(right)
            }
            
        }
        
        res.append(level)
    }
    return res
    
}

//class BinaryTree: NSObject
//{
//    
//   
//}
