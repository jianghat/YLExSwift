//
//  YLBasePagesViewController.swift
//  gamefi-ios
//
//  Created by ym on 2024/1/20.
//

import UIKit
import JXSegmentedView

class YLBasePagesViewController: YLBaseViewController {
    var viewControllers: [UIViewController] = []
    var segmentedDataSource: JXSegmentedTitleDataSource? {
        didSet {
            segmentedView.dataSource = segmentedDataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = getViewControllers()
        segmentedDataSource = segmentedTitleDataSource()
        setupConstraints()
        
        if let popGesture = self.navigationController?.interactivePopGestureRecognizer {
            self.listContainerView.scrollView.panGestureRecognizer.require(toFail: popGesture)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = segmentedView.selectedIndex == 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
  
    func setupConstraints() {
        segmentedView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        listContainerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        }
    }
    
    func getSegmentedTitles() -> [String] {
        return []
    }
    
    func getViewControllers() -> [UIViewController] {
        return []
    }
    
    func segmentedTitleDataSource() -> JXSegmentedTitleDataSource {
        //配置数据源
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = White8Color
        dataSource.titleSelectedColor = UIColor.white
        dataSource.titleNormalFont = kHarmonyOSFont(14)
        dataSource.titleSelectedFont = kHarmonyOSFont(16)
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.3
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.isSelectedAnimable = true
        dataSource.titles = getSegmentedTitles()
        return dataSource
    }
    
    func segmentedIndexChange(index: Int) {
        
    }

    lazy var segmentedView: JXSegmentedView = {
        let segmentedV = JXSegmentedView()
        segmentedV.delegate = self
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = GreenColor
        indicator.indicatorWidth = 18
        segmentedV.indicators = [indicator]
        
        segmentedV.listContainer = listContainerView
        view.addSubViews([segmentedV, listContainerView])
        return segmentedV
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let listContainerV = JXSegmentedListContainerView(dataSource: self)
        return listContainerV
    }()
}

extension YLBasePagesViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = index == 0
        segmentedIndexChange(index: index)
    }
}

extension YLBasePagesViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return viewControllers.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return viewControllers[index] as! JXSegmentedListContainerViewListDelegate
    }
}
