//
//  YLDropListView.swift
//  gamefi-ios
//
//  Created by ym on 2024/1/4.
//

import UIKit

class YLDropListView: UIView {
    let target = Delegate<[String: Any], Void>()
    
    private var isShow: Bool = false
    
    var tableList: [[String: Any]] = [] {
        didSet {
            let title = tableList.first?.stringForKey("name") ?? "全部"
            filterButton.setTitleOfNormal(title)
            tableView.reloadData()
            if (isShow) {
                dismiss()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(filterButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        filterButton.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    private func showMenu() {
        guard let view = self.superview else { return }
        let rect = self.convert(CGRect(x: self.width - 28, y: height, width: 12, height: 12), to: view)
        arrowImageView.frame = rect
        
        let rect2 = self.convert(CGRect(x: 0, y: height + 6, width: width, height: 0), to: view)
        tableView.frame = rect2
        
        view.addSubview(maskOverlyView)
        maskOverlyView.addSubViews([tableView, arrowImageView])
        
        UIView.animate(withDuration: 0.2, animations: {[self] in
            let maxCount = min(5, tableList.count)
            var frame = tableView.frame
            frame.size.height = CGFloat(maxCount * 40)
            tableView.frame = frame
        }) {[self] _ in
            isShow = true
        }
    }
    
    func dismiss() {
        if (maskOverlyView.superview != nil) {
            UIView.animate(withDuration: 0.2, animations: {[self] in
                var frame = tableView.frame
                frame.size.height = 0
                tableView.frame = frame
            }) {[self] _ in
                isShow = false
                maskOverlyView.subviews.forEach { $0.removeFromSuperview() }
                maskOverlyView.removeFromSuperview()
            }
        }
    }
    
    lazy var filterButton: UIButton = {
        let button = UIButton.button(title: "", font: kHarmonyOSFont(12))
        button.setBackgroundColor(GreyColor)
        button.setImageOfNormal("arrown_code")
        button.setCornerRadius(4)
        button.setActionTouchUpInside {[weak self] sender in
            if (self?.isShow == true) {
                self?.dismiss()
            } else {
                self?.showMenu()
            }
        }
        button.setRightImageAndTextPadding(2, labelWidth: 65)
        return button
    }()
    
    lazy var maskOverlyView: UIButton = {
        let maskV = UIButton(frame: UIScreen.main.bounds)
        maskV.setActionTouchUpInside {[weak self] sender in
            self?.dismiss()
        }
        return maskV
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: YLImageNamed("drop_arrow"))
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorColor = .white.withAlphaComponent(0.3)
        tableView.backgroundColor = YLHEXColor("#36394A")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setCornerRadius(4)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
}

extension YLDropListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        var textLabel = cell.contentView.viewWithTag(100) as? UILabel
        if (textLabel == nil) {
            textLabel = UILabel.label(font: kHarmonyOSFont(13), textColor: White6Color)
            textLabel!.tag = 100
            cell.contentView.addSubview(textLabel!)
            textLabel!.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        if (indexPath.row == tableList.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: YLScreenWidth)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        textLabel?.text = tableList[indexPath.row].stringForKey("name")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tableList[indexPath.row]
        filterButton.setTitleOfNormal(item.stringForKey("name"))
        target.call(item)
        dismiss()
    }
}
