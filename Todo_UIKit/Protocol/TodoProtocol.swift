//
//  TodoProtocol.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import Foundation

protocol TodoSaveDelegate {
    func saveTodo(newTodo: Todo)
    // John: 함수명을 reloadTodo로 했어도 좋았을꺼같아요.
    // (테이블뷰 관련 메서드와 명칭 혼동가능성 있어보임)
    func reloadTable()
}
