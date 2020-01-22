//
//  dynamicPlanning.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/1/5.
//  Copyright © 2019 alfredking. All rights reserved.
//p79求单词距离

import UIKit

//数据量大的情况动态规划容易发生栈溢出和数据溢出
func wordDistance(_ wordA:String,_ wordB:String)->Int
{
    let aChars=[Character](wordA.characters)
    let bChars = [Character](wordB.characters)
    let aLen = aChars.count
    let bLen = bChars.count
    
    var dp = Array(repeating: Array(repeating: 0, count: bLen+1), count: aLen+1)
    
    for i in 0...aLen
    {
        for j in 0...bLen
        {
            if i==0
            {
                //充当长度差别的计数
                dp[i][j]=j
            }
            else if j==0
            {
                dp[i][j]=i
            }
            else if aChars[i-1]==bChars[j-1]
            {
                //测试逻辑
                if(i==4 && j>=5)
                {
                    print("equal characters")
                    print(i)
                    print(j)
                    
                    print(aChars[i-1])
                    print(aChars[i-1])
                    print(dp[i-1][j-1])
                }
                //测试逻辑
                dp[i][j]=dp[i-1][j-1]
                print(dp[i][j])
            }
            else
            {
                dp[i][j]=min(dp[i-1][j-1],dp[i-1][j],dp[i][j-1])+1
            }
        }
    }
    
    return dp[aLen][bLen]
    
    
}
