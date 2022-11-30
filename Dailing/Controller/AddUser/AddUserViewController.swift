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
    var testimage: [String] = ["common (1)", "common (2)"]
    var testname: [String] = ["test1", "test2"]
    
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
    }
    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        
        let lastindex = self.userCollectionView.lastIndexpath().row // 마지막 인덱스 찾기
        if indexPath.row == lastindex {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.userImage.image = UIImage(systemName: "plus")
            cell.userName.text = ""
        } else {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
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
            let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
            let homeNav = storyBoard.instantiateViewController(identifier: "TabBarVC")
            self.changeRootViewController(homeNav)
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
