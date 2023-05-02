//
//  ViewController.swift
//  TodoApp
//
//  Created by poskreepta on 17.04.23.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController {
    
    var tasks: [Task]? = [] {
        // save todos when new object is created
        didSet {
            loadTasks()
            welcomeLabel.isHidden = true
        }
    }
    
        let tasksKey: String = "tasks_list"
//        var todoItemTitle = [String]()
//        var todoItemDescription = [String]()
        let cellId = "todoItemCellId"
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте новую задачу нажав на кнопку плюс."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
        private lazy var newTodoButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.image = UIImage(systemName: "plus")
            configuration.cornerStyle = .capsule
            let button = UIButton(configuration: configuration)
            button.addTarget(self, action: #selector(addNewTodoItem), for: .touchUpInside)
            //        let button = UIButton(configuration: configuration, primaryAction: #selector(addNewTodoItem))
            //        button.addTarget(self, action: #selector(addNewTodoItem), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        //    private let todoItemTitle: UILabel = {
        //        let label = UILabel()
        //        label.text = ""
        //        label.textColor = .black
        //        label.textAlignment = .left
        //        label.font = UIFont.systemFont(ofSize: 70)
        //        label.font = UIFont.boldSystemFont(ofSize: 65)
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        return label
        //    }()
        
        lazy var todoListCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            setupView()
            setupLayout()
            getTasks()
//            self.todoItemTitle = UserDefaults.standard.stringArray(forKey: "todoItemsTitle") ?? []
//            self.todoItemDescription = UserDefaults.standard.stringArray(forKey: "todoItemDescription") ?? []
            
            //        addTodoItemVC.delegate = self
            
        }
        
        
        func setupView() {
            view.addSubview(welcomeLabel)
            view.addSubview(newTodoButton)
            view.addSubview(todoListCollectionView)
            todoListCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
            
        }
        
        @objc func addNewTodoItem() {
            let addTodoItemVC = AddToDoItemViewController()
            addTodoItemVC.delegate = self
            navigationController?.pushViewController(addTodoItemVC, animated: true)
            //        navigationController?.popViewController(animated: true)
            //        present(addTodoItemVC, animated: true)
            
        }
        
        func setupLayout() {
            
            welcomeLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-30)
                make.centerX.equalToSuperview()
            }
            
            newTodoButton.snp.makeConstraints { make in
                make.trailing.equalTo(view.snp.trailing).inset(40)
                make.bottom.equalTo(view.snp.bottom).inset(80)
                make.width.height.equalTo(50)
            }
            
            todoListCollectionView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(newTodoButton.snp.top).inset(-30)
            }
            
           
            
            
            
        }
    
    //MARK: - Model Manipulation Methods + CRUD (UserDefault)
    func loadTasks() {
        if let encodeData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodeData, forKey: tasksKey)
        }
        
    }
    
    func getTasks() {
        //get data from UserDefault
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else {
            return
        }
        //decode the retrieved JSONdata into [Task] type
        guard let savedTasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return
        }
        //assign data to tasks
        self.tasks = savedTasks
    }
    
    //CRUD functions
    func addTask(todo: Task) {
        if var newTask = tasks {
            newTask.append(todo)
            tasks = newTask
            loadTasks()
        }
    }
    
    func updateTasks(at index: Int, with newTask: Task) {
        if var updatedTasks = tasks {
            updatedTasks[index] = newTask
            tasks = updatedTasks
            loadTasks()
        }
    }
    
    func deleteTask(at index: Int) {
        if var updatedTasks = tasks {
            updatedTasks.remove(at: index)
            tasks = updatedTasks
            loadTasks()
        }
    }
    
    func updateCell(at index: Int) {
        todoListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
        
 
    }
    
    
    extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if var selectedTask = tasks?[indexPath.item] {
                let addTodoItemVC = AddToDoItemViewController()
//                addTodoItemVC.todoItemTitleTextField.text = selectedTask.title
//                addTodoItemVC.descriptionTodoItemTextField.text = selectedTask.description
                addTodoItemVC.selectedTask = selectedTask
                addTodoItemVC.delegate = self

//                selectedTask.title = addTodoItemVC.todoItemTitleTextField.text ?? ""
//                selectedTask.description = addTodoItemVC.descriptionTodoItemTextField.text ?? ""
//                print(selectedTask.title)
//                print(selectedTask.description)
               
                updateTasks(at: indexPath.row, with: selectedTask)
                navigationController?.pushViewController(addTodoItemVC, animated: true)
                todoListCollectionView.reloadData()
            } else {
                fatalError("task is nil")
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return tasks?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.cellId, for: indexPath) as? TodoCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            //        cell.todoItemTitle.text = todoItemTitle[indexPath.row]
            //        cell.todoItemDescription.text = todoItemDescription[indexPath.row]
            //        return cell
    
            
            if let taskTodo = tasks?[indexPath.row] {
                cell.todoItemTitle.text = taskTodo.title
                cell.todoItemDescription.text = taskTodo.description
            }
           
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
        
        
    }
    
extension TodoListViewController: AddTodoItemDelegate {
    func didUpdateTodoItem(at: Task) {
        DispatchQueue.main.async {
//            var currentTodoItemTitle = UserDefaults.standard.stringArray(forKey: "todoItemsTitle") ?? []
//            currentTodoItemTitle.append(title)
//            UserDefaults.standard.set(currentTodoItemTitle, forKey: "todoItemsTitle")
//
//            var currentTodoItemDescription = UserDefaults.standard.stringArray(forKey: "TodoItemDescription") ?? []
//            currentTodoItemDescription.append(description)
//            UserDefaults.standard.set(currentTodoItemDescription, forKey: "TodoItemDescription")
            
            
            //            self.todoItemTitle = currentTodoItemTitle
            //            self.todoItemDescription = currentTodoItemDescription
            
            self.updateTasks(at: todoListCollectionView., with: at)
            self.todoListCollectionView.reloadData()
        }
    }
    
    func didAddTodoItem(with: Task) {
        
        DispatchQueue.main.async {
//            var currentTodoItemTitle = UserDefaults.standard.stringArray(forKey: "todoItemsTitle") ?? []
//            currentTodoItemTitle.append(title)
//            UserDefaults.standard.set(currentTodoItemTitle, forKey: "todoItemsTitle")
//
//            var currentTodoItemDescription = UserDefaults.standard.stringArray(forKey: "TodoItemDescription") ?? []
//            currentTodoItemDescription.append(description)
//            UserDefaults.standard.set(currentTodoItemDescription, forKey: "TodoItemDescription")
            
            
            //            self.todoItemTitle = currentTodoItemTitle
            //            self.todoItemDescription = currentTodoItemDescription
            
            self.addTask(todo: with)
            self.todoListCollectionView.reloadData()
        }
    }
        
        
    }



    
