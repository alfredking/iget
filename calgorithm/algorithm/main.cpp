//
//  MaxSequence.cpp
//  iget
//
//  Created by alfredking－cmcc on 2020/12/15.
//  Copyright © 2020 alfredking. All rights reserved.
//

#include <stdio.h>
#include<iostream>
#include<vector>
#include<algorithm>
#include<string>
 
using namespace std;
 
string str;
int n, m;
 
int change_alpha(char k)
{
    vector<int> loc;
    for (int i = 0; i < n; ++i)
        if (str[i] == k) loc.push_back(i);
    loc.push_back(n);
    int max_length = loc[m];
    
    for (int i = m + 1; i < loc.size(); ++i) {
        // loc[i]当前k实际索引, loc[i-m-1] i的前面m个数翻转之后，再前面的未翻转k的索引
        // loc[i] - loc[i-m-1] - 1 之间翻转m个k之后，中间字符的长度。
        max_length = max(max_length, loc[i] - loc[i-m-1] - 1);
    }
    return max_length;
}
 
int main()
{
    cin >> n >> m;
    cin >> str;
    
    cout << max(change_alpha('a'), change_alpha('b')) << endl;
}
