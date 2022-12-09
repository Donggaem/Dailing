//
//  DailingViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/08.
//

import UIKit
import FSPagerView

class DailingViewController: UIViewController {

    @IBOutlet var pageControl: FSPageControl!{
        didSet {
            self.pageControl.numberOfPages = images.count
            self.pageControl.currentPage = 2
        }
    }
    @IBOutlet var pagerView: FSPagerView!{
        didSet {
//            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")

            self.pagerView.register(UINib(nibName:"QuestionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "QuestionViewCell")
            self.pagerView.itemSize = CGSize(width: 273, height: 118)
            self.pagerView.transformer = FSPagerViewTransformer(type: .overlap)
            self.pagerView.layer.cornerRadius = 20
            self.pagerView.clipsToBounds = true
        }
    }
    @IBOutlet var bondingView: UIView!
    @IBOutlet var feelingView: UIView!
    @IBOutlet var fbondingView: UIView!
    
    var images = ["question09", "question10", "question11", "question12"]
    var questiontitle = ["질문. 9", "질문. 10", "질문. 11", "질문. 12"]
    var question = ["가족과 함께 가고싶은 여행지는 어디인가요?", "가족이 가장 뭉클했던 날은 언제인가요?", "오늘 하루 가장 기분 좋은 일은 무엇인가요?", "가족이 가장 든든했더 날은 언제인가요?"]
    var date = ["#December 09. 2022","#December 09. 2022","#December 09. 2022","#December 09. 2022"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    //MARK: - INNERFUNC
    private func setUI() {
        
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
                
        bondingView.layer.cornerRadius = 20
        bondingView.layer.shadowColor = UIColor.gray.cgColor
        bondingView.layer.masksToBounds = false
        bondingView.layer.shadowOffset = CGSize(width: 0, height: 0) // 반경
        bondingView.layer.shadowRadius = 6 // 반경
        bondingView.layer.shadowOpacity = 0.3 // alpha값

        feelingView.layer.cornerRadius = 20
        feelingView.layer.shadowColor = UIColor.gray.cgColor
        feelingView.layer.masksToBounds = false
        feelingView.layer.shadowOffset = CGSize(width: 0, height: 0) // 반경
        feelingView.layer.shadowRadius = 6 // 반경
        feelingView.layer.shadowOpacity = 0.3 // alpha값
        
        fbondingView.layer.cornerRadius = 20
        fbondingView.layer.shadowColor = UIColor.gray.cgColor
        fbondingView.layer.masksToBounds = false
        fbondingView.layer.shadowOffset = CGSize(width: 0, height: 0) // 반경
        fbondingView.layer.shadowRadius = 6 // 반경
        fbondingView.layer.shadowOpacity = 0.3 // alpha값

    }

}

//MARK: - Extension FSPagerView
extension DailingViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //이미지 개수
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.images.count
    }
    
    //각셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "QuestionViewCell", at: index) as! QuestionViewCell
       
        cell.questiontitle.text = questiontitle[index]
        cell.question.text = question[index]
        cell.questiondate.text = date[index]
        
        return cell
    }
}
