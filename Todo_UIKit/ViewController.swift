//
//  ViewController.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import UIKit
import SwiftData
import Combine

class ViewController: UIViewController, TodoSaveDelegate {
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let todoViewModel: TodoViewModel = TodoViewModel()
    var todoList: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setNavigationInfo()
        setTodoTable()
        setTodoData()
    }
    
    func setNavigationInfo() {
        self.navigationItem.title = "Todo List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTodo))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editStart))
    }
    
    @objc func addTodo() {
        let addTodo: AddTodoView = AddTodoView()
        addTodo.todoDelegate = self
        navigationController?.pushViewController(addTodo, animated: true)
    }
    
    var editingMode: Bool = true
    @objc func editStart() {
        tableView.setEditing(editingMode, animated: true)
        editingMode.toggle()
    }
    
    func setTodoTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    var cancellable: Cancellable?
    func setTodoData() {
        cancellable?.cancel()
        cancellable = todoViewModel.fetchData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("fetch finished!")
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("fetch error! > \(error)")
                }
            } receiveValue: { [weak self] todos in
                self?.todoList = todos
            }
    }
    
    // SaveTodoDelegate
    func saveTodo(newTodo: Todo) {
        self.todoViewModel.saveTodo(data: newTodo)
        self.setTodoData()
    }
    
    func reloadTable() {
        self.setTodoData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let todo: Todo = todoList[indexPath.row]
        
        cell.todoCompleteButton.setImage(UIImage(systemName: todo.todoComplete ? "checkmark.circle.fill" : "checkmark.circle"), for: .normal)
        cell.todoCompleteButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.todoCompleteButton.addAction(UIAction{ [weak self] _ in
            self?.todoList[indexPath.row].todoComplete.toggle()
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }, for: .touchUpInside)
        
        cell.todoTitleLabel.textColor = todo.todoComplete ? .lightGray : .label
        cell.todoTitleLabel.text = todo.todo
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        cell.dateLabel.text = formatter.string(from: todo.date)
        cell.dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 todo가 complete가 된 상태면 UITextField 수정 불가로 할까?
        // if !self.todoList[indexPath.row].todoComplete {
            let editTodo = EditTodoView()
            editTodo.editTodoDelegate = self
            editTodo.todo = self.todoList[indexPath.row]
            navigationController?.pushViewController(editTodo, animated: true)
        // }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoViewModel.deleteTodo(data: todoList[indexPath.row])
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

