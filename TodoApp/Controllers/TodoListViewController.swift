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
        didSet {
            loadTasks()
        }
    }

    var editingMode = false
    
    var gesture: UILongPressGestureRecognizer = {
        var gesture = UILongPressGestureRecognizer()
        return gesture
    }()
    
    let tasksKey: String = "tasks_list"
    let cellId = "todoItemCellId"
    
    
    // MARK: Creating UI Elements Programmatically
    
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
    
    private lazy var newTaskButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "plus")
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .systemGreen
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editTaskButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "pencil")
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(editTaskTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var finishDragAndDropTaskButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "multiply")
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(finishDragAndDropTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Creating TodoListCollectionView Vertical CollectionView
    
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
            finishDragAndDropTaskButton.isHidden = true
        }
    }
    
    // MARK: Setup Views
    func setupView() {
        view.addSubview(welcomeLabel)
        view.addSubview(newTaskButton)
        view.addSubview(editTaskButton)
        view.addSubview(finishDragAndDropTaskButton)
        view.addSubview(todoListCollectionView)
        todoListCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    // MARK: Add and Edit Button Functionallity Methods
    @objc func addNewTaskTapped() {
        let addTodoItemVC = AddToDoItemViewController()
        addTodoItemVC.delegate = self
        navigationController?.pushViewController(addTodoItemVC, animated: true)
    }
    
    @objc func editTaskTapped() {
        drapAndDropCells()
        editingMode = true
        if editingMode {
            finishDragAndDropTaskButton.isHidden = false
            newTaskButton.isHidden = true
            todoListCollectionView.reloadData()
        }
    }
    
    @objc func finishDragAndDropTaskButtonTapped() {
        todoListCollectionView.removeGestureRecognizer(gesture)
        editingMode = false
        if !editingMode {
            newTaskButton.isHidden = false
            finishDragAndDropTaskButton.isHidden = true
        }
    }
    
    
    // MARK: Setup Contstraints
    func setupLayout() {
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.centerX.equalToSuperview()
        }
        
        newTaskButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(view.snp.bottom).inset(60)
            make.width.height.equalTo(50)
        }
        
        editTaskButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(newTaskButton.snp.top).inset(-25)
            make.width.height.equalTo(50)
        }
        
        finishDragAndDropTaskButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(40)
            make.bottom.equalTo(newTaskButton.snp.top).inset(-25)
            make.width.height.equalTo(50)
        }
        
        todoListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(100)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editTaskButton.snp.top).inset(-30)
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
    }
    
    func updateTasks(at index: Int, with newTask: Task) {
        tasks[index] = newTask
    }
    
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
    }
}



//MARK: - AddTodoItemDelegate
extension TodoListViewController: AddTodoItemDelegate {
    func didUpdateTask(at indexPath: Int, with task: Task) {
        DispatchQueue.main.async {
            self.updateTasks(at: indexPath, with: task)
            self.todoListCollectionView.reloadData()
        }
    }
    
    
    func didAddTask(task: Task) {
        DispatchQueue.main.async {
            self.addTask(todo: task)
            self.todoListCollectionView.reloadData()
        }
    }
    
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tasks.count == 0 {
            welcomeLabel.isHidden = false
            todoListCollectionView.isHidden = true
        } else {
            welcomeLabel.isHidden = true
            todoListCollectionView.isHidden = false
        }
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TodoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let taskTodo = tasks[indexPath.item]
        cell.taskTitle.text = taskTodo.title
        cell.taskDescription.text = taskTodo.description
        if !editingMode {
            cell.deleteButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = false
        }
        cell.delegate = self
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addTodoItemVC = AddToDoItemViewController()
        addTodoItemVC.delegate = self
        navigationController?.pushViewController(addTodoItemVC, animated: true)
        let selectedTask = tasks[indexPath.item]
        addTodoItemVC.selectedTask = selectedTask
        addTodoItemVC.selectedTaskIndex = indexPath.item
    }
    
    
    @objc func deleteButtonTapped(sender: UIButton) {
        guard let cell = sender.superview as? TodoCollectionViewCell, let indexPath = todoListCollectionView.indexPath(for: cell) else {
            return
        }
        tasks.remove(at: indexPath.item)
    }
 
    
    
    //MARK: - Drag And Drop UICollectionView Functionallity With the LongPressGesture
    func drapAndDropCells() {
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        self.todoListCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
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

//MARK: - Swiping functionality for the cells
extension TodoListViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            DispatchQueue.main.async {
                self.deleteTask(at: indexPath.row)
            }
            action.fulfill(with: .delete)
        }
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var option = SwipeOptions()
        option.expansionStyle = .destructive
        return option
    }
}







