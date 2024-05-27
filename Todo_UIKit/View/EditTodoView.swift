//
//  EditTodoView.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/27.
//

import UIKit

class EditTodoView: UIViewController {
    
    let todoTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "할 일을 입력"
        tf.layer.borderWidth = 1
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        tf.leftViewMode = .always
        tf.returnKeyType = .done
        
        return tf
    }()
    
    var editButton: UIBarButtonItem!
    
    let todoViewModel = TodoViewModel()
    var editTodoDelegate: TodoSaveDelegate?
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        guard let todo = self.todo else { return }
        setTodoText(todo: todo)
        setNavigationComponent(todo: todo)
    }
    
    func setNavigationComponent(todo: Todo) {
        self.navigationItem.title = "Edit Todo"
        
        editButton = UIBarButtonItem(systemItem: .edit, primaryAction: UIAction{ [weak self] _ in
            guard let title = self?.todoTextField.text else { return }
            todo.todo = title
            todo.date = Date()
            self?.editTodoDelegate?.reloadTable()
            self?.navigationController?.popViewController(animated: true)
        })
        editButton.isEnabled = true
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setTodoText(todo: Todo) {
        todoTextField.text = todo.todo
        todoTextField.delegate = self
        todoTextField.removeTarget(nil, action: nil, for: .allEvents)
        todoTextField.addAction(UIAction{ [weak self] _ in
            if let text = self?.todoTextField.text, text.count > 0 {
                self?.editButton.isEnabled = true
            } else {
                self?.editButton.isEnabled = false
            }
        }, for: .editingChanged)
        
        view.addSubview(todoTextField)
        
        NSLayoutConstraint.activate([
            todoTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            todoTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            todoTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
}

extension EditTodoView: UITextFieldDelegate {
    
}
