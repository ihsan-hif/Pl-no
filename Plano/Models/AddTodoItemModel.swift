//
//  AddTodoItemModel.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 09/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import Foundation

class AddTodoItemModel: NSObject {
    var leftTitle = ""
    var rightTitle: String?
    
    override init() {
        super.init()
    }
    
    convenience init(leftTitle: String, rightTitle: String?) {
        self.init()
        
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
    }
}

class AddTodoItemSection: NSObject {
    var items = [AddTodoItemModel]()
    
    override init() {
        super.init()
    }
    
    convenience init(items: [AddTodoItemModel]) {
        self.init()
        
        self.items = items
    }
}
