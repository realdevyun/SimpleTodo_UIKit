//
//  TodoCell.swift
//  Todo_UIKit
//
//  Created by MadCow on 2024/5/24.
//

import UIKit

class TodoCell: UITableViewCell {
    
    let todoCompleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return button
    }()
    
    let todoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .lightGray
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(todoCompleteButton)
        self.contentView.addSubview(todoTitleLabel)
        self.contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            todoCompleteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            todoCompleteButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            
            todoTitleLabel.leadingAnchor.constraint(equalTo: todoCompleteButton.trailingAnchor, constant: 30),
            todoTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
