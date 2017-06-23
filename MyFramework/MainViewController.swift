//
//  MainViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
    }

}

extension MainViewController{
    fileprivate func SetupUI(){
        self.SetupMapView()
        self.SetupBottomBar()
    }
    
    private func SetupMapView(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScrennHeight - kMainBottomTabBarHeight))
        view.backgroundColor = .brown
        self.view.addSubview((view))
        
        SetupLayerButton(pView : view)
        SetupAddEventButton(pView : view)
    }
    
    private func SetupLayerButton(pView : UIView){
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 120, width: 40, height: 40))
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        pView.addSubview(btn)
    }
    
    private func SetupAddEventButton(pView : UIView){
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 180, width: 40, height: 40))
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        pView.addSubview(btn)
    }
    
    private func SetupBottomBar(){
        let frame = CGRect(x: 0, y: kScrennHeight - kMainBottomTabBarHeight, width: kScreenWidth, height: kMainBottomTabBarHeight)
        
        let titles = ["任务","案件","我的"]
        let images = ["btnImgTest"]
        let jumps : Array<(()->())?>  = [ jumpToTask , jumpToEvent , jumpToHome  ]
        
        let customTBV = CustomTabbarView(frame: frame, titles: titles , images : images ,jumps : jumps)
        self.view.addSubview(customTBV)
    }
}

extension MainViewController{
    fileprivate func jumpToTask(){
        self.present(TaskNaviTestViewController(), animated: true, completion: nil)
    }
    fileprivate func jumpToHome(){
        self.present(HomeViewController(), animated: true, completion: nil)
    }
    fileprivate func jumpToEvent(){
        self.present(EventViewController(), animated: true, completion: nil)
    }
}
