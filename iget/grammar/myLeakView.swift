//
//  myLeakView.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/4.
//  Copyright © 2019 alfredking. All rights reserved.
//

import Foundation
import UIKit

typealias Action = () -> Void

class MyView: UIView {
    
    var action: Action?
    
    init(action: @escaping Action) {
        self.action = action
//        super.init(frame: CGRect.zero)
        super.init(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
