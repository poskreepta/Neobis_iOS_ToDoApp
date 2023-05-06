//
//  ViewController.swift
//  TodoApp
//
//  Created by poskreepta on 17.04.23.
//

import UIKit
import SnapKit
import SwipeCellKit

class TodoListViewController: UIViewController {

    
    
    var tasks: [Task] = [] {
        // save todos when new object is created
        didSet {
            loadTasks()
            welcomeLabel.isHidden = true
            print(tasks)
            print(tasks.count)
        }
    }

    
    var editingMode = false
    
    var gesture: UILongPressGestureRecognizer = {
        var gesture = UILongPressGestureRecognizer()
        return gesture
    }()
    
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
        button.addTarget(self, action: #selector(addNewTodoItemTapped), for: .touchUpInside)
        //        let button = UIButton(configuration: configuration, primaryAction: #selector(addNewTodoItem))
        //        button.addTarget(self, action: #selector(addNewTodoItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editTodoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "pencil")
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(editTodoItemTapped), for: .touchUpInside)
        //        let button = UIButton(configuration: configuration, primaryAction: #selector(addNewTodoItem))
        //        button.addTarget(self, action: #selector(addNewTodoItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var finishDragAndDropTodoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "delete.right")
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(finishDragAndDropTodoButtonTapped), for: .touchUpInside)
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
        if !editingMode {
            finishDragAndDropTodoButton.isHidden = true
        }
        
//        if let tasks = tasks {
//            print(tasks.count)
//            if tasks.count == 0 {
//                welcomeLabel.isHidden = false
//            }
//
//        }
       

        //            self.todoItemTitle = UserDefaults.standard.stringArray(forKey: "todoItemsTitle") ?? []
        //            self.todoItemDescription = UserDefaults.standard.stringArray(forKey: "todoItemDescription") ?? []
        
        //        addTodoItemVC.delegate = self
        
    }
    
    
    func setupView() {
        view.addSubview(welcomeLabel)
        view.addSubview(newTodoButton)
        view.addSubview(editTodoButton)
        view.addSubview(finishDragAndDropTodoButton)
        view.addSubview(todoListCollectionView)
        todoListCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    @objc func addNewTodoItemTapped() {
        let addTodoItemVC = AddToDoItemViewController()
        addTodoItemVC.delegate = self
        navigationController?.pushViewController(addTodoItemVC, animated: true)
        //        navigationController?.popViewController(animated: true)
        //        present(addTodoItemVC, animated: true)
        
    }
    
    @objc func editTodoItemTapped() {
        drapAndDropCells()
        editingMode = true
        if editingMode {
            finishDragAndDropTodoButton.isHidden = false
            newTodoButton.isHidden = true
            todoListCollectionView.reloadData()
            print("editButtontapped")
        }
      
        
    }
    
    @objc func finishDragAndDropTodoButtonTapped() {
        todoListCollectionView.removeGestureRecognizer(gesture)
        editingMode = false
        if !editingMode {
            newTodoButton.isHidden = false
            finishDragAndDropTodoButton.isHidden = true
            todoListCollectionView.reloadData()

        }
    }
    
    func setupLayout() {
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-30)
            make.centerX.equalToSuperview()
        }
        
        newTodoButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(view.snp.bottom).inset(60)
            make.width.height.equalTo(50)
        }
        
        editTodoButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(newTodoButton.snp.top).inset(-25)
            make.width.height.equalTo(50)
        }
        
        finishDragAndDropTodoButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(newTodoButton.snp.top).inset(-25)
            make.width.height.equalTo(50)
        }
        
        todoListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(100)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editTodoButton.snp.top).inset(-30)
        }
        
        
        
        
        
    }
    
    //MARK: - Model Manipulation Methods + CRUD (UserDefault)
    func loadTasks() {
        if let encodeData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodeData, forKey: tasksKey)
            todoListCollectionView.reloadData()
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
            tasks.append(todo)
            loadTasks()
    }
    
    func updateTasks(at index: Int, with newTask: Task) {
            tasks[index] = newTask
            loadTasks()
    }
    
    func deleteTask(at index: Int) {
            tasks.remove(at: index)
            loadTasks()
        if tasks.count == 0 {
            welcomeLabel.isHidden = false
        }
    }
    
    func updateCell(at index: Int) {
        todoListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    
}


extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SwipeCollectionViewCellDelegate {
    
    
    
//    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeAction()
//        options.expansionStyle = .destructive
//        return options
//    }
    
        
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addTodoItemVC = AddToDoItemViewController()
        addTodoItemVC.delegate = self
        
        //            addTodoItemVC.selectedTask = tasks?[indexPath.item]
        
        navigationController?.pushViewController(addTodoItemVC, animated: true)
        
        let selectedTask = tasks[indexPath.item]
            addTodoItemVC.selectedTask = selectedTask
            addTodoItemVC.selectedItemIndex = indexPath.item
            //                selectedTask.title = addTodoItemVC.todoItemTitleTextField.text ?? ""
            //                selectedTask.description = addTodoItemVC.descriptionTodoItemTextField.text ?? ""
            //                print(selectedTask.title)
            //                print(selectedTask.description)
            
            
            //            todoListCollectionView.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.cellId, for: indexPath) as? TodoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //        cell.todoItemTitle.text = todoItemTitle[indexPath.row]
        //        cell.todoItemDescription.text = todoItemDescription[indexPath.row]
        //        return cell
        
        
        let taskTodo = tasks[indexPath.item]
            cell.todoItemTitle.text = taskTodo.title
            cell.todoItemDescription.text = taskTodo.description
        
        
        if !editingMode {
            cell.deleteButton.isHidden = true
            print(editingMode)
        } else {
            cell.deleteButton.isHidden = false
            print(editingMode)
        }
        
    
        cell.delegate = self
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        guard let cell = sender.superview as? TodoCollectionViewCell, let indexPath = todoListCollectionView.indexPath(for: cell) else {
            return
        }
        print("delete task")
        tasks.remove(at: indexPath.item)
//        todoListCollectionView.performBatchUpdates({todoListCollectionView.deleteItems(at: [indexPath])}, completion: nil)

//        if let taskTodo = tasks?[indexPath.row] {
//            cell.todoItemTitle.text = taskTodo.title
//            cell.todoItemDescription.text = taskTodo.description
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Swiping functionality for the cells
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print(self.tasks.count)
            DispatchQueue.main.async {
                self.deleteTask(at: indexPath.row)
                self.todoListCollectionView.reloadData()
            }
//            self.tasks.remove(at: indexPath.row)
//            self.deleteTask(at: indexPath.row)
//            self.deleteTask(at: indexPath.item)
            print("удаляемый элемент \(indexPath.item)")
            print("task count after deleting \(self.tasks.count)")

            print(self.tasks)
            action.fulfill(with: .delete)
    //                        self.todoListCollectionView.performBatchUpdates({self.todoListCollectionView.deleteItems(at: [indexPath])}, completion: nil)

        }
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var option = SwipeOptions()
        option.expansionStyle = .destructive
        return option
    }
    
    
    //MARK: - Drag And Drop UICollectionView Functionallity
    func drapAndDropCells() {
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        self.todoListCollectionView.addGestureRecognizer(gesture)
        print("draged")
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
    print("longpressed")
        switch gesture.state {
        case .began:
            guard let targetIndexPath = todoListCollectionView.indexPathForItem(at: gesture.location(in: todoListCollectionView)) else { return }
            todoListCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            
        case .changed:
            todoListCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: todoListCollectionView))
        case.ended:
            todoListCollectionView.endInteractiveMovement()
        default:
            todoListCollectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let dragedTasks = tasks.remove(at: sourceIndexPath.item)
            tasks.insert(dragedTasks, at: destinationIndexPath.item)
        

    }
    
}



extension TodoListViewController: AddTodoItemDelegate {
    func didUpdateTodoItem(at: Int, with: Task) {
        print("dd")
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
            
            self.updateTasks(at: at, with: with)
            print(at)
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




