//
//  AddToDoItemViewController.swift
//  TodoApp
//
//  Created by poskreepta on 20.04.23.
//

import UIKit
import SnapKit

protocol AddTodoItemDelegate {
    func didAddTodoItem(with: Task)
    func didUpdateTodoItem(at: Task)

}
class AddToDoItemViewController: UIViewController {
    
    var delegate: AddTodoItemDelegate?
    var selectedItemIndex: Int?
    var selectedTask: Task?

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
        
//        let button = UIButton(configuration: configuration, primaryAction: cancelItemButtonTapped())
        button.addTarget(self, action: #selector(cancelItemButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var todoItemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.placeholder = "Название"
        textField.keyboardType = .default
        textField.textAlignment = .left
        textField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var descriptionTodoItemTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.placeholder = "Название"
        textField.keyboardType = .default
        textField.textAlignment = .left
        textField.attributedPlaceholder = NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//    init(task: Task = Task(title: "", description: "")) {
//        descriptionTodoItemTextField.text = task.description
//        todoItemTitleTextField.text = task.title
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        view.backgroundColor = UIColor(hexString: "#F6F5F7")
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        
        if let task = selectedTask {
            todoItemTitleTextField.text = task.title
            descriptionTodoItemTextField.text = task.description
        }
        
//        if let index = selectedItemIndex {
//            let task = tasks
//        }
    }
    
    
    func setupView() {
        
        view.addSubview(todoItemTitleTextField)
        view.addSubview(descriptionTodoItemTextField)
        view.addSubview(saveItemButton)
        view.addSubview(cancelItemButton)
    }
    
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
        
        
        
        
    }
    
    @objc func saveItemButtonTapped() -> UIAction {
        let action = UIAction { _ in
            guard let title = self.todoItemTitleTextField.text, let description = self.descriptionTodoItemTextField.text else {
                return
            }
            
            if var task = self.selectedTask {
                task.title = title
                task.description = description
                self.selectedTask = task
                print(task.title)
                print(task.description)
                let updatedTask = task
                self.delegate?.didUpdateTodoItem(at: updatedTask)
            } else {
                let newTask = Task(title: title, description: description)
                
                self.delegate?.didAddTodoItem(with: newTask)
                
                
                print("koko")
            }
            
           
        }
        return action
    }
    
    @objc func cancelItemButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}



//func hideKeyboardWhenTappedAround() {
//    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//    tap.cancelsTouchesInView = false
//    view.addGestureRecognizer(tap)
//}
//
//@objc func dismissKeyboard() {
//    view.endEditing(true)
//}
