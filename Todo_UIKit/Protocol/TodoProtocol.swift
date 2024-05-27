//
//  TodoProtocol.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import Foundation

protocol TodoSaveDelegate {
    func saveTodo(newTodo: Todo)
    func reloadTable()
}
