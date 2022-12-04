//
//  TabBarVC.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/30.
//

import Foundation

class TabBarVC: UITabBarController {
    
    // MARK: - Variable Part
    
    var uploadButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "upload"), for: .normal)
        button.addTarget(self, action: #selector(TabBarVC.buttonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    // MARK: - Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonClicked(sender: uploadButton)
        setTabBar()
        setupStyle()
    }
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
}

// MARK: - Extension

extension TabBarVC {
    
    
    @objc func buttonClicked(sender : UIButton) {
        
        
        //버튼 클릭 시 CameraVC 이동
        let uploadStoryboard = UIStoryboard.init(name: "Upload", bundle: nil)
        guard let uploadVC = uploadStoryboard.instantiateViewController(identifier: "UploadViewController") as? UploadViewController
        else {
            return
        }
        //        uploadVC.modalPresentationStyle = .fullScreen
        present(uploadVC, animated: true, completion: nil)
    }
    
    
    func setTabBar() {
        
        
        //탭바 설정
        let calendarStoryboard = UIStoryboard.init(name: "Calendar", bundle: nil)
        guard let calendarVC = calendarStoryboard.instantiateViewController(identifier: "CalendarViewController") as? CalendarViewController else {
            return
        }
        
        let mapStoryboard = UIStoryboard.init(name: "Map", bundle: nil)
        guard let mapVC = mapStoryboard.instantiateViewController(identifier: "MapViewController") as? MapViewController else {
            return
        }
        
        calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: -20, bottom: -5, right: 0)
        calendarVC.tabBarItem.image = UIImage(named: "cal")
        calendarVC.tabBarItem.selectedImage = UIImage(named: "cals")
        calendarVC.tabBarItem.title = ""
        
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: -20)
        mapVC.tabBarItem.image = UIImage(named: "map")
        mapVC.tabBarItem.selectedImage = UIImage(named: "maps")
        mapVC.tabBarItem.title = ""
        
        
        setViewControllers([calendarVC, mapVC], animated: true)
        
        let width: CGFloat = 70/375 * self.view.frame.width
        let height: CGFloat = 70/375 * self.view.frame.width
        
        let posX: CGFloat = self.view.frame.width/2 - width/2
        let posY: CGFloat = -32
        
        uploadButton.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        tabBar.addSubview(self.uploadButton)
    }
    
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
