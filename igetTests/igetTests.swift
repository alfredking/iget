//
//  igetTests.swift
//  igetTests
//
//  Created by alfredking on 2018/11/28.
//  Copyright © 2018年 alfredking. All rights reserved.
//

import XCTest
//import grammarTest
@testable import iget

class igetTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testArray()
    {
        let testArray = TestArray()
        testArray.test()
    }
    
    func testStackQueue()
    {
        let testStackQueue = TestStackQueue()
        testStackQueue.test()
    }
    
    func testDictionarySet()
    {
        let testDictionarySet = TestDictionarySet()
        testDictionarySet.test()
    }
    
    func testString()
    {
        let testString = TestString()
        testString.test()
    }
    
    
    //p34
    func testList()
    {
        let testList = TestList()
        testList.test()
    }
    
    //p47
    func testBinaryTree()
    {
        let testBinaryTree = TestBinaryTree()
        testBinaryTree.test()
    }
    
    //p54
    func testSorting()
    {
        let testSorting = TestSorting()
        testSorting.test()
    }
    
    
    //p64
    func testBinSearch()
    {
        let biSearch = binSearch()
        biSearch.test()
    }
    
    //p79动态规划
    func testDynamicPlanning()
    {
        print("**************dp test*********************")
        
        print(wordDistance("test", "dp"))
        print(wordDistance("test", "te"))
        print(wordDistance("test", "testa"))
        
        print("**************many t*********************")
        //首先会计算t到后一个字符串的最大距离是10
        print(wordDistance("test", "testttttttt"))
    }
    
    
    
        //p87
        func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //p87
        test_copy_on_write()
        //p87
        test_property_observer()
        //p89
        testOr()
        //p89
        testCurrying()
        
        
    }
    
    //MARK: - 函数式编程测试方法
    func testFun() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        testFunc()
    }
    
    //p92
    func testCopy() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let father = Father()
        father.testcopy()
        
       
    }
    
    //p95 block与代理的区别
    func testBlock() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let father = Father()
        father.testblock()
        
        
    }
    
    
    
    
    
    func testStatic() {
         testStaticLanguage()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        //测试方法执行时间
        self.measure {
            // Put the code you want to measure the time of here.
            testStaticLanguage()
        }
    }
    
    func loadContent(){
        guard let url = URL(string: "https://app-info.rtf") else {
            fatalError("URL can't be empty")
        }
        let session = URLSession.shared
        let client = HttpClient(session :session)
        
        client.get(url:url){(data,error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data{
                print("data is successfully fetched from server")
            }
        }
        
        
        
    }
    
    var dataLoaded : Data?
    
    //mock http参考https://blog.csdn.net/weixin_34348111/article/details/87958746
    func test_loadContent_shouldReturnData(){
    
    
       
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        let session = MockURLSession()
        var httpClient: HttpClient! = HttpClient(session: session)
        
        //用NSPredicate来过滤条件，只有dataLoaded不为nil才会被记录
        let pred = NSPredicate(format: "dataLoaded != nil")
        let exp = expectation(for : pred ,evaluatedWith: self , handler :nil)
        
        httpClient.get(url: url){[weak self](data, error) in
            self?.dataLoaded = data
            //当异步成功结束时触法expectation
            exp.fulfill()
        }
        //等待expectation被触发，超时时间设定为5s
        wait(for : [exp],timeout: 5.0)
        //判断expectation 出发后dataLoaded是否为nil，否则测试失败
        XCTAssertNotNil(dataLoaded,"no data is received!")
        
        
    }

    
    
    
}
