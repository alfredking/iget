//
//  ViewController.swift
//  iget
//
//  Created by alfredking on 2018/11/28.
//  Copyright © 2018年 alfredking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white

       

        //p70用dfs实现单词搜索
        var matrix :[[Character]] = [["a","d","d","f","w"],["f","h","j","u","i"],["i","d","j","d","s"],["h","k","s","w","i"],["o","r","u","a","z"]]
            print(matrix[0].count)
            var xOffset = CGFloat(0)
            var yOffset = CGFloat(0)
            let cellWidth = UIScreen.main.bounds.size.width/CGFloat(matrix[0].count)
            let cellHeight = UIScreen.main.bounds.size.height/CGFloat(matrix.count)

            for i in 0..<matrix.count
            {
            for j in 0..<matrix[0].count
            {
            let label = UILabel(frame: CGRect(x:xOffset,y:yOffset,width:cellWidth,height:cellHeight))
            label.textAlignment = NSTextAlignment.center
            label.text = String(matrix[i][j])
            self.view.addSubview(label)
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

        
        




       

        
        
       
        
        
        
        
        
        
        
        
       
        

        
    }
    
    

    
    
    
    
   
    
//    func testBarrier()
//    {
//        try storage.getUser(id)
//    }
    
    
    
   
    
    

    
    
    
//   p202 bitcode https://www.jianshu.com/p/f42a33f5eb61 LLVM是目前苹果采用的编译器工具链,Bitcode是LLVM编译器的中间代码的一种编码,LLVM的前端可以理解为C/C++/OC/Swift等编程语言,LLVM的后端可以理解为各个芯片平台上的汇编指令或者可执行机器指令数据,那么,BitCode就是位于这两者直接的中间码. LLVM的编译工作原理是前端负责把项目程序源代码翻译成Bitcode中间码,然后再根据不同目标机器芯片平台转换为相应的汇编指令以及翻译为机器码.这样设计就可以让LLVM成为了一个编译器架构,可以轻而易举的在LLVM架构之上发明新的语言(前端),以及在LLVM架构下面支持新的CPU(后端)指令输出,虽然Bitcode仅仅只是一个中间码不能在任何平台上运行,但是它可以转化为任何被支持的CPU架构,包括现在还没被发明的CPU架构,也就是说现在打开Bitcode功能提交一个App到应用商店,以后如果苹果新出了一款手机并CPU也是全新设计的,在苹果后台服务器一样可以从这个App的Bitcode开始编译转化为新CPU上的可执行程序,可供新手机用户下载运行这个App.
    
    
   
   
   

}



