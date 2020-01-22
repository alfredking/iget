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
    
    
    
   
    
    

    
    
    
    
   

}



