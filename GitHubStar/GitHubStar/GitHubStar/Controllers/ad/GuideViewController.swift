//
//  GuideViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/18.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    var collectionView: UICollectionView?
    let cellIdentifier = "GuideCell"
    var pageController = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width, height: 20))
    
    //导航视图
    var imageNames = ["guide_40_1", "guide_40_2", "guide_40_3"]
    
    //跳入正常视图
    
    
    
    let nextButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 100) * 0.5, y: UIScreen.main.bounds.height - 110, width: 100, height: 33))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1)
        
        self.initView()
        self.buildPageController()
        self.buildNextButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 初始化视图 -
    private func initView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.view.addSubview(collectionView!)
        collectionView?.backgroundColor = UIColor.blue
    }
    
    //分页控制器
    private func buildPageController() {
        pageController.numberOfPages = self.imageNames.count
        pageController.currentPage = 0
        self.view.addSubview(pageController)
    }
    
    //进入下一个的按钮
    private func buildNextButton(){
        nextButton.setBackgroundImage(UIImage(named: "icon_next"), for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: UIControlEvents.touchUpInside)
        nextButton.isHidden = true
        self.view.addSubview(nextButton)
    }
    
    //进入程序页
    func nextButtonClick(){
        let delegate = UIApplication.shared.delegate
        delegate?.window!!.rootViewController = RootViewController()
        
        GuideViewController.setAppOk()
    }
    
    //MARK: - 简单的判断和设置 -
    static func isFristOpen() -> Bool {
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        
        if isFristOpen == nil {
            return true
        }
        
        return false
    }
    
    static func setAppOk(){
        UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
    }
    
    static func setAppFail(){
        UserDefaults.standard.removeObject(forKey: "isFristOpenApp")
    }
    
}


extension GuideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        let newImage = UIImage(named: imageNames[indexPath.row])
        
        imageView.image = newImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        cell.contentView.addSubview(imageView)
        
        if indexPath.row != imageNames.count - 1 {
            nextButton.isHidden = true
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        if scrollView.contentOffset.x == UIScreen.main.bounds.width * CGFloat(imageNames.count - 1) {
            nextButton.isHidden = false
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != UIScreen.main.bounds.width * CGFloat(imageNames.count - 1)
            && scrollView.contentOffset.x > UIScreen.main.bounds.width  * CGFloat(imageNames.count - 2) {
             nextButton.isHidden = true
        }
        
        pageController.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width  + 0.5)
    }
    
}
