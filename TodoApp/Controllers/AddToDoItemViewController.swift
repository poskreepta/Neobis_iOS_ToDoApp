//
//  AddToDoItemViewController.swift
//  TodoApp
//
//  Created by poskreepta on 20.04.23.
//

import UIKit
import SnapKit

protocol AddTodoItemDelegate {
    
    func didAddTask(task: Task)
    
    func didUpdateTask(at: Int, with: Task)
    
}


class AddToDoItemViewController: UIViewController {
    
    var delegate: AddTodoItemDelegate?
    var selectedTaskIndex: Int?
    var selectedTask: Task?
    
    
    // MARK: Creating UI ELements Programmatically
    
    lazy var saveItemButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Сохранить"
        let button = UIButton(configuration: configuration, primaryAction: saveItemButtonTapped())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(cancelItemButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deleteItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteItemButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var todoItemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .white
        textField.autocapitalizationType = .sentences
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var descriptionTodoItemTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .white
        textField.autocapitalizationType = .sentences
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        view.backgroundColor = UIColor(hexString: "#F6F5F7")
        navigationController?.isNavigationBarHidden = true
        deleteItemButton.isHidden = true
        
        if let task = selectedTask {
            todoItemTitleTextField.text = task.title
            descriptionTodoItemTextField.text = task.description
        }
        
    }
    
    // MARK: Setup Views
    
    func setupView() {
        
        view.addSubview(todoItemTitleTextField)
        view.addSubview(descriptionTodoItemTextField)
        view.addSubview(saveItemButton)
        view.addSubview(cancelItemButton)
        view.addSubview(deleteItemButton)
    }
    
    
    // MARK: Setup Contstraints
    
    func setupConstraints() {
        
        cancelItemButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(-20)
            make.top.equalTo(view.snp.top).inset(50)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        saveItemButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(50)
            make.trailing.equalTo(view.snp.trailing).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        todoItemTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(cancelItemButton.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.leading).inset(30)
            make.trailing.equalTo(view.snp.trailing).inset(30)
            make.height.equalTo(60)
        }
        
        descriptionTodoItemTextField.snp.makeConstraints { make in
            make.top.equalTo(todoItemTitleTextField.snp.bottom).offset(30)
            make.leading.equalTo(view.snp.leading).inset(30)
            make.trailing.equalTo(view.snp.trailing).inset(30)
            make.bottom.equalTo(view.snp.bottom).inset(100)
        }
        
        deleteItemButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    
    // MARK: Setup Methods
    
    @objc func saveItemButtonTapped() -> UIAction {
        let action = UIAction { _ in
            guard let title = self.todoItemTitleTextField.text, let description = self.descriptionTodoItemTextField.text else {
                return
            }
            
            if let indexPath = self.selectedTaskIndex {
                var task = self.selectedTask ?? Task()
                task.title = title
                task.description = description
                self.selectedTask = task
                self.delegate?.didUpdateTask(at: indexPath, with: self.selectedTask!)
            } else {
                let newTask = Task(title: title, description: description)
                self.delegate?.didAddTask(task: newTask)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        return action
    }
    
    @objc func cancelItemButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteItemButtonTapped() {
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}



