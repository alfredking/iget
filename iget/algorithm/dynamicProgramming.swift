//
//  dynamicProgramming.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/1/5.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit


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
                dp[i][j]=j
            }
            else if j==0
            {
                dp[i][j]=i
            }
            else if aChars[i-1]==bChars[j-1]
            {
                dp[i][j]=dp[i-1][j-1]
            }
            else
            {
                dp[i][j]=min(dp[i-1][j-1],dp[i-1][j],dp[i][j-1])+1
            }
        }
    }
    
    return dp[aLen][bLen]
    
    
}
