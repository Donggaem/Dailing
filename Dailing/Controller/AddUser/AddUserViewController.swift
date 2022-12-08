//
//  AddUserViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit

class AddUserViewController: UIViewController {
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    //    var userArray: [] = []
    var testimage: [String] = ["신형만", "봉미선", "짱구", "짱아", ""]

//    var testimage: [String] = ["common (1)", "common (2)", "common (3)", "common (4)", ""]
    var testname: [String] = ["신형만", "봉미선", "짱구", "짱아", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        
    }
}

extension AddUserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // CollectionView 셋팅
    func setCollectionView() {
        self.userCollectionView.reloadData()
        self.userCollectionView.delegate = self
        self.userCollectionView.dataSource = self
        self.userCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        
        self.userCollectionView.backgroundColor = .none
    }
    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimage.count;
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        
        let lastindex = self.userCollectionView.lastIndexpath().row // 마지막 인덱스 찾기
        if indexPath.row == lastindex {
            
            cell.userImage.image = UIImage(systemName: "plus")
            cell.userImage.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.userName.text = "계정 추가"
        } else {
            
            cell.userImage.image = UIImage(named: testimage[indexPath.row])
            cell.userName.text = testname[indexPath.row]

        }
       
        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lastindex = self.userCollectionView.lastIndexpath().row // 마지막 인덱스 찾기
        if indexPath.row == lastindex {
 
        } else {
            UserDefaults.standard.set(testname[indexPath.row], forKey: "userId")
            print(UserDefaults.standard.string(forKey: "userId")!)
            
            // 탭바로 이동
            let tabBarStoryboard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
            guard let tabBarVC = tabBarStoryboard.instantiateViewController(identifier: "TabBarVC") as? TabBarVC else {
                return
            }
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true, completion: nil)
            
//            let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
//            let homeNav = storyBoard.instantiateViewController(identifier: "TabBarVC")
//            self.changeRootViewController(homeNav)
        }
        
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width / 2 - 1.0
        
        return CGSize(width: width, height: width)
    }
    
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    

}


extension UICollectionView {
    
    // 마지막 인덱스 값 찾기
    func lastIndexpath() -> IndexPath {
            let section = max(numberOfSections - 1, 0)
            let row = max(numberOfItems(inSection: section) - 1, 0)
            
            return IndexPath(row: row, section: section)
        }
}
