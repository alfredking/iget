//
//  search.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/1/1.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit


class testsearch : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
var matrix = [["a","d","d","f","w"],["f","h","j","u","i"],["i","d","j","d","s"],["h","k","s","w","i"],["o","r","u","a","z"]]
    print(matrix[0].count)
var xOffset = CGFloat(0)
var yOffset = CGFloat(0)
let cellWidth = UIScreen.main.bounds.size.width/CGFloat(matrix[0].count)
let cellHeight = UIScreen.main.bounds.size.height/CGFloat(matrix[0].count)

for i in 0...matrix.count
{
    for j in 0...matrix.count
    {
        let label = UILabel(frame: CGRect(x:xOffset,y:yOffset,width:cellWidth,height:cellHeight))
        label.text = String(matrix[i][j])
        view.addSubview(label)
        labels.append(label)
        xOffset+=cellWidth
        
    }
    xOffset=0
    yOffset+=cellHeight
}
}
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
    var wordContent = [Character]("crowd")
    
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
    
    visited[i][j]=false
    return false
}

func findWords(_ board:[[Character]],_ dict:Set<String>)->[String]
{
    var  res = [String]()
    let (m,n) = (board.count,board[0].count)
    
    let trie=_converseSetToTrie(dict)
    var visited = Array(repeating: Array(repeating: false, count: n), count: m)
    
    for i in 0..<m
    {
        for j in 0..<n
        {
            _dfs(board, m, n, i, j, visited, &res, trie,"")
        }
    }
    return res
    
}

private func _dfs(_ board:[[Character]],_ m:Int,_ n : Int,_ i : Int,_ j : Int, visited : inout [[Bool]], res : inout [String],_ trie : Trie ,_ str : String)
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
    
    var str = str+"\(board[i][j])"
    guard trie.prefixWith(str)
    else
    {
        return
    }
    
    // 确认当前字母组合是否为单词
    if trie.isWord(str) && !res.contains(str)
    {
        res.append(str)
    }
    
    //继续搜索上下左右四个方位
    visited[i][j]=true
    _dfs(board, m, n, i + 1, j, &visited, &res, trie, str)
    _dfs(board, m, n, i - 1, j, &visited, &res, trie, str)
    _dfs(board, m, n, i, j + 1, &visited, &res, trie, str)
    _dfs(board, m, n, i, j - 1, &visited, &res, trie, str)
    visited[i][j] = true
    
    
}
