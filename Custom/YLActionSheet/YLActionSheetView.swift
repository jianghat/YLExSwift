//
//  YLActionSheetView.swift
//  Driver
//
//  Created by ym on 2020/9/28.
//

import UIKit

protocol YLActionSheetViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class YLActionSheetViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(self.titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    // Mark Load
    public private (set) lazy var titleLabel: UILabel = {
        let label = UILabel.label(font: 14, textColor: UIColor.black)
        label.textAlignment = .center
        return label
    }()
}

class YLActionSheetView: YLBasePopView {
    var title: String? {
        didSet {
            headerView.titleLabel?.text = title
        }
    }
    var cancelTitle: String? {
        didSet {
            
        }
    }
    var splitHeight: CGFloat = 10.0
    var dataSource: YLActionSheetViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMaskDismiss = false
    }
    
    convenience init(title: String, cancelTitle: String?) {
        self.init(frame: .zero)
        self.title = title
        self.cancelTitle = cancelTitle
    }
    
    open func addAction(_ action: YLAction) {
        self.tableView.tableArray.append(action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: YLScreenWidth, height: 0))
        contentView.addSubview(headerView)
        contentView.addSubview(tableView)
    }
    
    override func updateConstraints() {
        contentView.snp.makeConstraints{ (make) in
            make.width.equalTo(YLScreenWidth)
        }
        
        headerView.snp.updateConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(tableView.tableArray.count * 44)
            make.bottom.lessThanOrEqualTo(-YLFullTabbarExtraHeight)
        }
        super.updateConstraints()
    }
    
    override func show() {
        super.show(animation: .Bottom)
    }
    
    // Mark Lazy load
    private lazy var headerView: YLActionSheetHeaderView = {
        let headerView = YLActionSheetHeaderView(frame: CGRect(x: 0, y: 0, width: YLScreenWidth, height: 44))
        headerView.cancelButton?.setActionTouchUpInside({ [weak self] (sender) in
            self?.dismiss()
        })
        
        headerView.doneButton?.setActionTouchUpInside({ [weak self] (sender) in
            self?.dismiss()
        })
        return headerView
    }()
    
    private lazy var tableView: YLTableView = {
        let tableView = YLTableView(frame: .zero, style: .plain)
        tableView.register(YLActionSheetViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorZeroEnabled = true
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension YLActionSheetView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! YLActionSheetViewCell
        let action = self.tableView.tableArray[indexPath.row] as! YLAction
        cell.titleLabel.text = action.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = self.tableView.tableArray[indexPath.row] as! YLAction
        if action.handler != nil {
            action.handler!(action)
            self.dismiss()
        }
    }
}
