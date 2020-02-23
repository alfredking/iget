//
//  iOSButton.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class iOSButton: Button {
    private var title: String?
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func show() {
        print("Showing iOS style button. Title: \(title ?? "Default Title")")
    }
}
