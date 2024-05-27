//
//  Todo.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import Foundation
import SwiftData

@Model
class Todo {
    @Attribute(.unique) var id: UUID
    var date: Date
    var todo: String
    var todoComplete: Bool
    
    init(date: Date, todo: String, todoComplete: Bool) {
        self.id = UUID()
        self.date = date
        self.todo = todo
        self.todoComplete = todoComplete
    }
}
