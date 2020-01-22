//
//  TestBinaryTree.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//p47
import UIKit

class TestBinaryTree: NSObject {
    func test()
    {
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
        print(level)    }

}
