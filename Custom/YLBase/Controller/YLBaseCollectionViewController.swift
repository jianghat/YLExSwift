//
//  YLBaseCollectionViewController.swift
//  gamefi-ios
//
//  Created by ym on 2023/12/12.
//

import UIKit
import EmptyDataSet_Swift

class YLBaseCollectionViewController: YLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    override func reloadEmptyDataSet() {
        collectionView.reloadEmptyDataSet()
    }
    
    public func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func collectionViewLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumLineSpacing = 16
        return flowLayout
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        view.addSubview(collectionView)
        return collectionView
    }()
}

extension YLBaseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
