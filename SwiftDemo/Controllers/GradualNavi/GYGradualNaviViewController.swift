//
//  GYGradualNaviViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/8.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import SnapKit

class GYGradualNaviViewController: UIViewController,UIScrollViewDelegate {
    
    /// headView高度
    var headHeight:CGFloat = 200.0
    /// sectionHeader高度
    let sectionHeaderHeight:CGFloat = 44.0
    let cellID = "cell"
    
    var tableView: UITableView!
    var headView: UIView!
    var sectionHeader: UIView!
    var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setCustomVeiw()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    func setNavigation() {
        // 设置导航栏的背景
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        // 取消掉底部的那根线
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        //设置标题
        let titleLabel = UILabel.init()
        titleLabel.text = "渐变导航"
        titleLabel.sizeToFit()
        // 开始的时候看不见，所以alpha值为0
        titleLabel.textColor = UIColor.init(white: 0, alpha: 0)
        navigationItem.titleView = titleLabel
    }
    func setCustomVeiw(){
        tableView = UITableView.init()
        let height = headHeight+sectionHeaderHeight
        tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint.init(x: 0, y: -headHeight-sectionHeaderHeight), animated:false)
        // 2.设置数据源代理
        tableView.dataSource = self
        tableView.delegate = self
        // 4.注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        headView = UIView.init()
        headView.backgroundColor = UIColor.lightGray
        headView.autoresizesSubviews = true
        view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(headHeight)
            make.width.equalTo(GYScreenWidth)
        }
        bgImageView = UIImageView.init()
        bgImageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber:0)
        bgImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        headView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.top).offset(0)
            make.left.equalTo(headView.snp.left).offset(0)
            make.right.equalTo(headView.snp.right).offset(0)
            make.bottom.equalTo(headView.snp.bottom).offset(0)
        }
        sectionHeader = UIView.init()
        sectionHeader.backgroundColor = UIColor.gray
        sectionHeader.autoresizingMask = UIView.AutoresizingMask.flexibleTopMargin
        view.addSubview(sectionHeader)
        sectionHeader.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(sectionHeaderHeight)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + (headHeight + sectionHeaderHeight)
        var imgH = headHeight - offset

        if (imgH < statusBarH) {
            imgH = statusBarH
        }
        //print(scrollView.contentOffset.y)
        
        let w = imgH*GYScreenWidth/headHeight
        
        self.headView.snp.updateConstraints { (make) in
            make.height.equalTo(imgH)
            make.width.equalTo(w<GYScreenWidth ? GYScreenWidth:w)
        }
        bgImageView.snp.updateConstraints { (make) in
            make.top.equalTo(headView.snp.top).offset(0)
            make.left.equalTo(headView.snp.left).offset(0)
            make.right.equalTo(headView.snp.right).offset(0)
            make.bottom.equalTo(headView.snp.bottom).offset(0)
        }
        sectionHeader.snp.updateConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(0)
        }
        
        //根据透明度来生成图片
        //找最大值
        var alpha  = offset * 1 / 136.0   // (200 - 64) / 136.0f
        if (alpha >= 1) {
            alpha = 0.99
        }else if(alpha<0){
            alpha = 0
        }
        //        print(alpha)
        bgImageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber:Float(alpha))
        
        //拿到标题 标题文字的随着移动高度的变化而变化
        let titleL = navigationItem.titleView as! UILabel
        titleL.textColor = UIColor.init(white: 1, alpha: alpha)
        
        //把颜色生成图片
        //        let alphaColor = UIColor.init(white: 1, alpha: alpha)
        //把颜色生成图片
        //        let alphaImage = UIImage.imageWithColor(color: alphaColor)
        //修改导航条背景图片
        //        navigationController?.navigationBar.setBackgroundImage(alphaImage, for: UIBarMetrics.default)
    }
}

extension GYGradualNaviViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}

extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage {
        let rect  = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 开启上下文
        let ref = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        ref.setFillColor(color.cgColor)
        // 渲染上下文
        ref.fill(rect)
        // 从上下文中获取图片
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return image
    }
}

