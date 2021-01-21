//
//  ViewController.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import UIKit
#if canImport(Combile)
import Combine
#else
import OpenCombine
#endif
import SDWebImage

class ViewController: UIViewController {
    var viewModel = BingImagesViewModel()
    var reloadCancellable: AnyCancellable?
    var didupdateViewConstraints = false

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.rowHeight = 80
        return tableView
    }()
}

// MARK:- Combine
private extension ViewController {
    func combine() {
        reloadCancellable = viewModel.imagePublisher.sink(receiveValue: { [unowned self] (images) in
            self.tableView.reloadData()
        })
    }
}

// MARK:- override
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(refresh))
        view.addSubview(tableView)
        updateViewConstraints()
        combine()
        viewModel.requestImages()
    }
    
    override func updateViewConstraints() {
        if !didupdateViewConstraints {
            self.tableView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                } else {
                    make.top.equalTo(self.topLayoutGuide.snp.top)
                }
            }
        }
        super.updateViewConstraints()
    }
}

// MARK:- Action
private extension ViewController {
    @objc func refresh() {
        viewModel.requestImages()
    }
}
