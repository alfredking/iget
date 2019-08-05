//
//  search.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/1/1.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TrieNode<T : Hashable>
{
    var value: T?
    weak var parent : TrieNode?
    var children : [T: TrieNode]=[:]
    var isTerminating = false
    
    init(value: T? = nil,parent:TrieNode?=nil)
    {
        self.value = value
        self.parent = parent
    }
    
    func  add(child:T)
    {
        guard children[child]==nil
        else
        {
            return
        }
        
        children[child] = TrieNode(value : child,parent : self)
    }
    
}

class Trie
{
    typealias Node = TrieNode<Character>
    fileprivate let root : Node
    init()
    {
        root = Node()
    }
}

extension Trie
{
    func insert(word:String)
    {
        guard !word.isEmpty
        else
        {
            return
        }
        
        //将从根节点开始执行迭代
        var currentNode = root
        let characters = Array(word.lowercased().characters)
        var currentIndex = 0
        
        while currentIndex < characters.count
        {
            let character = characters[currentIndex]
            if let child = currentNode.children[character]
            {
                currentNode = child
            }
            else
            {
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            currentIndex += 1
            
            if currentIndex == characters.count
            {
                currentNode.isTerminating=true
            }
        }
        
    }
    
    
    
    
    func contains(_ word:String)->Bool
    {
        guard !word.isEmpty
        else
        {
            return false
        }
        
        var currentNode = root
        var characters = Array(word.lowercased().characters)
        var currentIndex = 0
        
        while currentIndex < characters.count,let child = currentNode.children[characters[currentIndex]]
        {
            currentIndex += 1
            currentNode = child
        }
        
        if currentIndex == characters.count && currentNode.isTerminating
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func prefixWith(_ prefix:String) -> Bool
    {
        var node = root
        var prefix = [Character](prefix.characters)
        
        for i in 0..<prefix.count
        {
            let c = prefix[i]
            
            if node.children[c] == nil
            {
                return false
            }
            node = node.children[c]!
        }
        
        return true
    }
}


func _convertToTrie(_ words:[String])->Trie
{
    let trie = Trie()
    for str in words
    {
        trie.insert(word: str)
    }
    
    return trie
    
}

func searchWord(_ board: [[Character]])->Bool
{
    guard board.count>0&&board[0].count>0
    else
    {
        return false
    }
    
    let (m,n) = (board.count,board[0].count)
    var visited = Array(repeating: Array(repeating: false, count: n), count: m)
    let wordContent = [Character]("crowd")
    
    for i in 0...m
    {
        for j in 0...n
        {
            if dfs(board,wordContent,m,n,i,j,&visited,0)
            {
             return true
            }
        }
    }
    return false
    
}

func dfs(_ board:[[Character]],_ wordContent : [Character],_ m:Int,_ n :Int,_ i:Int,_ j:Int,_ visited : inout [[Bool]],_ index:Int)->Bool
{
    if index == wordContent.count
    {
        return true
    }
    
    guard i>=0&&i<m&&j>=0&&j<n
    else
    {
        return false
    }
    
    guard !visited[i][j]&&board[i][j]==wordContent[index]
    else
    {
        return false
    }
    
    visited[i][j]=true
    if dfs(board, wordContent, m, n, i+1, j, &visited, index+1)||dfs(board, wordContent, m, n, i-1, j, &visited, index+1)||dfs(board, wordContent, m, n, i, j+1, &visited, index+1)||dfs(board, wordContent, m, n, i, j-1, &visited, index+1)
    
    {
        return true
    }
    
    visited[i][j]=false //下一步查找不到就要回溯
    return false
}

func findWords(_ board:[[Character]],_ dict:[String])->[String]
{
    var  res = [String]()
    let (m,n) = (board.count,board[0].count)
    
    let trie=_convertToTrie(dict)
    var visited = Array(repeating: Array(repeating: false, count: n), count: m)
    
    for i in 0..<m
    {
        for j in 0..<n
        {
            _dfs(board, m, n, i, j, &visited, &res, trie,"")
        }
    }
    return res
    
}

private func _dfs(_ board:[[Character]],_ m:Int,_ n : Int,_ i : Int,_ j : Int,_ visited : inout [[Bool]], _ res : inout [String],_ trie : Trie ,_ str : String)
{
    guard i>=0&&i<m&&j>=0&&j<n
        else
    {
        return
    }
    
    guard !visited[i][j]
    else
    {
        return
    }
    
    let str = str+"\(board[i][j])"
    guard trie.prefixWith(str)
    else
    {
        return
    }
    
    // 确认当前字母组合是否为单词
    if trie.contains(str) && !res.contains(str)
    {
        res.append(str)
    }
    
    //继续搜索上下左右四个方位
    visited[i][j]=true
    _dfs(board, m, n, i + 1, j, &visited, &res, trie, str)
    _dfs(board, m, n, i - 1, j, &visited, &res, trie, str)
    _dfs(board, m, n, i, j + 1, &visited, &res, trie, str)
    _dfs(board, m, n, i, j - 1, &visited, &res, trie, str)
    visited[i][j] = false
    
    
}
