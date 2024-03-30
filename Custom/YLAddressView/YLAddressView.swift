//
//  YLAddressView.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/18.
//

import UIKit
import SnapKit

class YLAddressView: YLBasePopView {
    private var addressList: [YLAddressModel?]?
    private var dataList: [YLAddressModel?]?
    private var selectedArray: [YLAddressModel] = []
    private var titleLabelsArray: [UILabel] = []
    private var selectedTag: Int = 0  {
        didSet {
            for i in 0..<titleLabelsArray.count {
                let label = titleLabelsArray[i]
                label.textColor = i == selectedTag ? GreenColor :UIColor.white
            }
        }
    }
    let targetDelegatte = Delegate<[YLAddressModel], Void>()
    
    override func createUI() {
        contentView = UIView(frame: .zero)
        contentView.backgroundColor = GreyColor
        contentView.addSubViews([titleLabel, titlesView, lineView, tableView])
    }
    
    override func updateConstraints() {
        contentView.snp.updateConstraints{ (make) in
            make.left.right.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(-YLFullTabbarExtraHeight)
        }
        titleLabel.snp.updateConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        titlesView.snp.updateConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(titlesView.subviews.count * 44)
        }
        lineView.snp.updateConstraints{ (make) in
            make.top.equalTo(titlesView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        tableView.snp.updateConstraints{ (make) in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(352)
        }
        super.updateConstraints()
    }
    
    func setupTitles() {
        for v in titlesView.subviews {
            v.removeFromSuperview()
        }
        titleLabelsArray.removeAll()
        var selectedTitles: [String] = []
        selectedArray.forEach { item in
            if let title = item.value {
                selectedTitles.append(title)
            }
        }
        if selectedTitles.count < 3 {
            selectedTitles.append("请选择")
        }
        var topY: CGFloat = 0
        for i in 0..<selectedTitles.count {
            let titleView = UIView(frame: .zero)
            titleView.tag = i
            titleView.addTapGestureRecognizer {[weak self] _ in
                self?.loadAddressData(index: i)
            }
            
            let dotView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
            dotView.backgroundColor = GreenColor
            dotView.setCornerRadius(5)
            
            let lineView = UIView()
            lineView.backgroundColor = GreenColor
            
            let leftLabel = UILabel.label(font: kHarmonyOSFont(14), textColor: GreenColor)
            leftLabel.textColor = i == selectedTag ? GreenColor : UIColor.white
            leftLabel.text = selectedTitles[i]
            
            let imageView = UIImageView(image: YLImageNamed("mine_arrow_right"))
            titleView.addSubViews([dotView, lineView, leftLabel, imageView])
            titlesView.addSubview(titleView)
            titleLabelsArray.append(leftLabel)
            
            titleView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
                make.top.equalTo(topY)
            }
            dotView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 10, height: 10))
                make.left.equalTo(16)
                make.centerY.equalToSuperview()
            }
            if (i == 0) {
                lineView.snp.makeConstraints { make in
                    make.top.equalTo(dotView.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.centerX.equalTo(dotView)
                    make.width.equalTo(3)
                }
            } else if (i == 2) {
                lineView.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.centerX.bottom.equalTo(dotView)
                    make.width.equalTo(3)
                }
            } else {
                lineView.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.centerX.equalTo(dotView)
                    make.width.equalTo(3)
                }
            }
            leftLabel.snp.makeConstraints { make in
                make.left.equalTo(dotView.snp.right).offset(16)
                make.centerY.equalToSuperview()
            }
            imageView.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalToSuperview()
            }
            topY += 44
        }
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
    
    //    func formatAddressList(addressModel: YLAddressModel) {
    //        if let children = addressModel.children {
    //            for i in 0..<children.count {
    //                let model = children[i]
    //                model.parentCode = addressModel.code
    //                formatAddressList(addressModel: model)
    //            }
    //        }
    //    }
    
    func findAddressModel(name: String, parent: YLAddressModel?) -> YLAddressModel? {
        let list = parent == nil ? addressList : parent?.children
        guard let tempList = list else { return nil }
        var result: YLAddressModel?
        for item in tempList {
            if item?.value == name {
                result = item
                break
            }
        }
        return result
    }
    
    func show(animation: AlertAnimation, defaultTitles: [String]?) {
        guard let path = Bundle.main.path(forScaledResource: "address", ofType: "json") else { return  }
        guard let data = FileManager.default.contents(atPath: path) else { return  }
        guard let jsonArray = data.jsonObject() as? [[String: AnyObject]] else { return  }
        
        addressList = BaseModel.deserializeModelArray(from: jsonArray, modelTypes: [YLAddressModel].self)
        if let titleList = defaultTitles, titleList.count > 0 {
            for i in 0..<titleList.count {
                let str = titleList[i]
                var parent: YLAddressModel?
                let parentIdx = i - 1
                if i > 0 && selectedArray.count > parentIdx  {
                    parent = selectedArray[parentIdx]
                }
                if let addressModel = findAddressModel(name: str, parent: parent) {
                    selectedArray.append(addressModel)
                } else {
                    break
                }
            }
        }
        loadAddressData(index: max(0, selectedArray.count - 1))
        setupTitles()
        super.show(animation: animation)
    }
    
    func loadAddressData(index: Int) {
        self.selectedTag = index
        if index == 0 {
            self.dataList = addressList
        } else {
            let parent = self.selectedArray[index - 1]
            self.dataList = parent.children
        }
        self.tableView.reloadData()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.label(font: kHarmonyOSBoldFont(20), textColor: .white)
        label.text = "请选择所在地区"
        return label
    }()
    
    lazy var titlesView: UIView = {
        let titlesView = UIView()
        return titlesView
    }()
    
    lazy var lineView: UIView = {
        let lineV = UIView()
        lineV.backgroundColor = White4Color
        return lineV
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .plain);
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = 44
        tableView.register(YLAddressTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
}

extension YLAddressView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! YLAddressTableViewCell
        let addressModel = dataList![indexPath.row]
        cell.titleLabel.text = addressModel?.value
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressModel = dataList![indexPath.row]!
        if let children = addressModel.children, children.count > 0 {
            self.dataList = children
            self.tableView.reloadData()
        }
        var tempArray: [YLAddressModel] = []
        for i in 0..<selectedTag {
            if i < selectedArray.count {
                let selectedModel = selectedArray[i]
                tempArray.append(selectedModel)
            }
        }
        tempArray.append(addressModel)
        if tempArray.count == 3 {
            self.contentView.snp.makeConstraints { make in
                make.top.equalTo(YLScreenHeight)
            }
            UIView.animate(withDuration: 0.25) {[self] in
                self.contentView.layoutIfNeeded()
            } completion:{[self] (finished) in
                if (finished) {
                    self.removeFromSuperview()
                }
                self.targetDelegatte.call(tempArray)
            }
            return
        }
        self.selectedArray = tempArray
        self.selectedTag += 1
        self.setupTitles()
    }
}
