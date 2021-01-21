//
//  BingImageCell.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import UIKit
import OpenCombine
import SnapKit
class BingImageCell: UITableViewCell {
    
    var viewModel: BingImageCellViewModel = BingImageCellViewModel()
    var dataCancelable: AnyCancellable?
    var actionCancelable: AnyCancellable?
    var didupdateConstraints = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(bingImageView)
        contentView.addSubview(deleteButton)
        combine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.backgroundColor = .white
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(bingImageView)
        contentView.addSubview(deleteButton)
        combine()
    }

    
    lazy var copyrightLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var bingImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.setTitle("删除", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didDeleteButtonClicked), for: .touchUpInside)
        return button
    }()
    
}

// MARK:-  Action
extension BingImageCell {
    @objc func didDeleteButtonClicked() {
        viewModel.delete()
    }
}

// MARK:-  Override
extension BingImageCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        copyrightLabel.text = nil
        bingImageView.image = nil
    }
    
    override class var requiresConstraintBasedLayout: Bool { true}
    override func updateConstraints() {
        super.updateConstraints()
        if !didupdateConstraints {
            didupdateConstraints = true
            bingImageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(16)
                make.top.equalToSuperview().offset(5)
                make.bottom.equalToSuperview().offset(-5)
                make.width.equalTo(bingImageView.snp.height).dividedBy(27.0/43)
            }
            
            copyrightLabel.snp.makeConstraints { (make) in
                make.left.equalTo(bingImageView.snp.right).offset(10)
                make.top.bottom.equalTo(bingImageView)
                make.right.equalToSuperview().offset(-60)
                
            }
            
            deleteButton.snp.makeConstraints { (make) in
                make.left.equalTo(copyrightLabel.snp.right).offset(5)
                make.centerY.equalTo(bingImageView)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(30)
            }
        }
    }
}

// MARK:- Private
private extension BingImageCell {
    private func combine() {
        dataCancelable = viewModel.dataSubject.sink(receiveValue: { (cellData) in
            self.bingImageView.sd_setImage(with: cellData.imageUrl, completed: nil)
            self.copyrightLabel.text = cellData.copyRight
        })
    }
    
}
