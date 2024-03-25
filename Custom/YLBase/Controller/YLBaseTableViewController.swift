//
//  YLBaseTableViewController.swift
//  Driver
//
//  Created by ym on 2020/9/25.
//  Copyright © 2020 edonesoft. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class YLBaseTableViewController: YLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-YLFullTabbarExtraHeight).priority(.high)
        }
    }
    
    override func reloadEmptyDataSet() {
        tableView.reloadEmptyDataSet()
    }
    
    func style() -> UITableView.Style {
        return .plain
    }
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: style())
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.emptyDataSetSource = self
        view.addSubview(tableView)
        return tableView
    }()
}

extension YLBaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
