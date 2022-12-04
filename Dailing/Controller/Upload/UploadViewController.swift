//
//  UploadViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit

class UploadViewController: UIViewController {

    @IBOutlet var uploadImage: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var countLabel: UILabel!
    private let textViewPlaceHolder = "내용을 입력하세요(100자이내)"
    private let maxCount = 99

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextView()
        
    }

    @IBAction func uploadBrnPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - INNER FUNC
    func setUI() {
        uploadBtn.layer.cornerRadius = 10
    }
}

//MARK: - Extension UITextViewDelegate
extension UploadViewController: UITextViewDelegate {
    
    private func setTextView(){
        
        countLabel.text = "0 / 100"
        
        //플레이스홀더 설정
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = .placeholderText
        contentTextView.font = UIFont(name: "Inter-Medium", size: 12)
        
        contentTextView.sizeToFit()
        textViewDidChange(contentTextView)
        
        contentTextView.delegate = self
        self.contentTextView.textContainerInset =
        UIEdgeInsets(top: 0, left: -contentTextView.textContainer.lineFragmentPadding, bottom: 0, right: -contentTextView.textContainer.lineFragmentPadding) // 텍스트뷰 안쪽 marin없애기
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = maxCount + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount {
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            
            textView.replace(textRange, withText: String(newText))
            
            return false
        }
        return true
    }
    
    //텍스트뷰 열릴시
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if contentTextView.text == textViewPlaceHolder {
            contentTextView.text = nil
            contentTextView.textColor = .black
            countLabel.text = "0 / 100"
            
        }
    }
    
    //텍스트뷰 동작시
    func textViewDidChange(_ textView: UITextView) {
        
        countLabel.text = "\(contentTextView.text.count) / 100" //아래 글자수 표시
        
    }
    
    //텍스트뷰 닫힐시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == textViewPlaceHolder {
            contentTextView.text = textViewPlaceHolder
            contentTextView.textColor = .placeholderText
            contentTextView.font = UIFont(name: "Inter-SemiBold", size: 14.5)
            countLabel.text = "0 / 100"
        }
        
        if textView.text.count > maxCount {
            //글자수 제한에 걸리면 마지막 글자를 삭제함.
            contentTextView.text.removeLast()
            let alert = UIAlertController(title: "알림", message: "100자 이내로 적어주시기 바랍니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
    
    
}
