//
//  AddTodo.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import UIKit

class AddTodoView: UIViewController {
    
    var todoDelegate: TodoSaveDelegate?
    
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
    
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setNavigationComponent()
        setComponents()
    }
    
    func setNavigationComponent() {
        self.navigationItem.title = "Add Todo"
        
        addButton = UIBarButtonItem(systemItem: .add, primaryAction: UIAction{ [weak self] _ in
            guard let title = self?.todoTextField.text else { return }
            let newTodo = Todo(date: Date(), todo: title, todoComplete: false)
            self?.todoDelegate?.saveTodo(newTodo: newTodo)
            self?.navigationController?.popViewController(animated: true)
        })
        addButton.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func setComponents() {
        todoTextField.delegate = self
        todoTextField.removeTarget(nil, action: nil, for: .allEvents)
        todoTextField.addAction(UIAction{ [weak self] _ in
            if let text = self?.todoTextField.text, text.count > 0 {
                self?.addButton.isEnabled = true
            } else {
                self?.addButton.isEnabled = false
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

extension AddTodoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
