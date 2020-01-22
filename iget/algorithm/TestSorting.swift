//
//  TestSorting.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//p54
import UIKit

class TestSorting: NSObject
{
    func test()
    {
        print("**************sorting test*********************")
        
        let merge = mergeSort([8,4,5,7,1,3,6,2])
        print(merge)
        
        let quick = quicksort([8,4,5,7,1,3,6,2])
        print("**************quick begin*********************")
        print(quick)
        print("**************quick end*********************")
        var  meetings = [MeetingTime(1,3),MeetingTime(2,4),MeetingTime(5,7),MeetingTime(13,17),MeetingTime(9,10),MeetingTime(6,7),MeetingTime(6,8)]
        let conf = mergeTime(&meetings)
        print(conf)
        
        
        print(binarySearchInt([1,4,5,6,7,88,56],6))
        print(binarySearchInt([1,4,5,6,7,88,56],12))
        
        print(search([7,8,9,1,2,3,4,5,6],4))
    }

}
