//
//  TodoCollectionViewCell.swift
//  TodoApp
//
//  Created by poskreepta on 18.04.23.
//

import UIKit
import SnapKit
import SwipeCellKit

class TodoCollectionViewCell: SwipeCollectionViewCell {
        
    var isCompleted = false {
        didSet {
            completeButton.isSelected = isCompleted
        }
    }
    
    // MARK: Creating UI ELements Programmatically
    lazy var taskTitle: UILabel = {
        let label = UILabel()
        label.configure()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var taskDescription: UILabel = {
        let label = UILabel()
        label.configure()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    private let imageTaskDetails: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .systemTeal
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageTaskDetailsAllow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        let emptyCircleImage = UIImage(systemName: "circle")!
        button.setImage(emptyCircleImage, for: .normal)
        let filledCircleImage = UIImage(systemName: "checkmark.circle.fill")!
        button.setImage(filledCircleImage, for: .selected)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func completeButtonTapped() {
        isCompleted.toggle()
    }
    

    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup Views
    func setupView() {
        addSubview(taskTitle)
        addSubview(taskDescription)
        addSubview(deleteButton)
        addSubview(completeButton)
        addSubview(imageTaskDetails)
        addSubview(imageTaskDetailsAllow)
        
    }
    
    
    // MARK: Setup Contstraints
    func setupConstraints() {
        
        taskTitle.snp.makeConstraints { make in
            make.top.equalTo(snp.top).inset(4)
            make.leading.equalTo(completeButton.snp.leading).offset(40)
            make.trailing.equalTo(imageTaskDetails.snp.leading).inset(-7)
        }
        
        taskDescription.snp.makeConstraints { make in
            make.top.equalTo(taskTitle).inset(26)
            make.leading.equalTo(completeButton.snp.leading).offset(40)
            make.trailing.equalTo(imageTaskDetails.snp.leading).inset(-7)

        }
        
        completeButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(deleteButton).offset(30)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        imageTaskDetails.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(imageTaskDetailsAllow).inset(20)
        }
        
        imageTaskDetailsAllow.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
        
        
    }
    
}
