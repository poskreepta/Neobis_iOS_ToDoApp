//
//  TodoCollectionViewCell.swift
//  TodoApp
//
//  Created by poskreepta on 18.04.23.
//

import UIKit
import SnapKit

class TodoCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "todoItemCellId"
    
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
    
    
//    var titleTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "write a bussiness"
//        textField.keyboardType = .asciiCapable
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = .white
//        textField.textColor = .black
//        return textField
//    }()
    
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
        
    }
    
    func setupConstraints() {
        
        todoItemTitle.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
        
        todoItemDescription.snp.makeConstraints { make in
            make.top.equalTo(todoItemTitle).inset(40)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
        
        
    }
    
}
