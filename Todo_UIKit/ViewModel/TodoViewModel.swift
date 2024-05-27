//
//  TodoViewModel.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import Foundation
import SwiftData
import Combine

class TodoViewModel {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            self.container = try ModelContainer(for: Todo.self)
            if let container = self.container {
                self.context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchData() -> AnyPublisher<[Todo], Error> {
        Future<[Todo], Error> { promise in
            let descriptor = FetchDescriptor<Todo>(sortBy: [SortDescriptor<Todo>(\.date/* John: 여기에 이거 써주시면 날짜빠른순으로 정렬돼요 , order: .reverse*/)])
            guard let ctx = self.context else {
                print("context nil error")
                return
            }
            
            do {
                let data = try ctx.fetch(descriptor)
                promise(.success(data))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveTodo(data: Todo) {
        guard let ctx = context else { return }
        ctx.insert(data)
    }
    
    func deleteTodo(data: Todo) {
        guard let ctx = context else { return }
        ctx.delete(data)
    }
}

