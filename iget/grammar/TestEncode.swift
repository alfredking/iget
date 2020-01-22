//
//  TestEncode.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TestEncode: NSObject {
    
    func test()
    {
        //编码解码
                let res = """
                                {
                                    "x": 12,
                                    "y": 13
                                }
                                """
                let data = res.data(using: .utf8)!
        
                let decoder = JSONDecoder()
                let stu = try! decoder.decode(Ponit2D.self, from: data)
                print(stu)
                print("decode finish")
        
        
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted //输出格式好看点
                let result = try! encoder.encode(stu)
                print(String(data: result, encoding: .utf8)!)
        
        
                let point = """
                        {
                            "x" : 1,
                            "y" : 1,
                            "z" : 1
                        }
                        """
                let pointdata = point.data(using: .utf8)!
                let p2 = try! decoder.decode(Ponit3D.self, from:pointdata)
                print("p2 type")
                print(p2)
    }

}


class Ponit2D: Codable {
    var x = 0.0
    var y = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(Double.self, forKey: .x)
        let y = try container.decode(Double.self, forKey: .y)
        self.x = x
        self.y = y
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    
}

class Ponit3D: Ponit2D {
    var z = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case z
        case point2D
    }
    
    init(x: Double, y: Double, z: Double) {
        super.init(x: x, y: y)
        self.z = z
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let z = try container.decode(Double.self, forKey: .z)
        self.z = z
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 创建一个提供给父类encode的容器来区分父类属性和派生类属性
        try super.encode(to: container.superEncoder())
        try container.encode(z, forKey: .z)
    }
    
    
}
