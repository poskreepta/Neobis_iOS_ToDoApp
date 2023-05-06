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
    
    static let cellId = "todoItemCellId"
    
    var isCompleted = false {
        didSet {
            completeButton.isSelected = isCompleted
        }
    }
    
    lazy var todoItemTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todoItemDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        let emptyCircleImage = UIImage(systemName: "circle")!
              button.setImage(emptyCircleImage, for: .normal)
              let filledCircleImage = UIImage(systemName: "checkmark.circle.fill")!
              button.setImage(filledCircleImage, for: .selected)
//              button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func completeButtonTapped() {
        isCompleted.toggle()
    }
    

//    private let checkmarkImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "stopwatch")
//        imageView.tintColor = .black
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
//        button.addTarget(self, action: #selector(deleteItemButtonTapped), for: .touchUpInside)
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
    
    func setupView() {
        addSubview(todoItemTitle)
        addSubview(todoItemDescription)
        addSubview(deleteButton)
        addSubview(completeButton)
        
    }
    
    func setupConstraints() {
        
        todoItemTitle.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.equalTo(completeButton.snp.leading).offset(35)
//            make.trailing.equalTo(snp.trailing)
//            make.bottom.equalTo(snp.bottom)
        }
        
        todoItemDescription.snp.makeConstraints { make in
            make.top.equalTo(todoItemTitle).inset(27)
            make.leading.equalTo(completeButton.snp.leading).offset(35)
//            make.trailing.equalTo(snp.trailing)
//            make.bottom.equalTo(snp.bottom)
        }
        
        completeButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(deleteButton).offset(30)
        }
        
        deleteButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
//        paddingView.snp.makeConstraints { make in
//            make.top.equalTo(todoItemTitle.snp.bottom).offset(16)
//        }
        
        
    }
    
}
