//
//  UploadViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import AVFoundation
import Photos
import Alamofire
import CoreLocation

class UploadViewController: UIViewController {
    
    @IBOutlet var uploadImage: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var photoIcon: UIImageView!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var countLabel: UILabel!
    
    private let textViewPlaceHolder = "내용을 입력하세요(100자이내)"
    private let maxCount = 99
    
    //이미지
    let imagePickerController = UIImagePickerController()
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진 찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    var imageData: Data? = nil
    
    //위치
    var locationManger = CLLocationManager()
    var lat_now = 0.0
    var lng_now = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextView()
        enrollAlertEvent()
        setLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countLabel.text = "0 / 100"
    }
    
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - IBACTION
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let title = self.titleTextField.text ?? ""
        let content = self.contentTextView.text ?? ""
        let lat = self.lat_now
        let lng = self.lng_now
        let image = imageData!
        
        print(lat)
        print(lng)
        
        let params = UploadRequest(userId: userId, title: title, content: content, lat: lat, lng: lng, image: image)
        postUpload(params)
        
    }
    
    //MARK: - INNER FUNC
    private func setUI() {
        
        self.imagePickerController.delegate = self
        
        uploadBtn.layer.cornerRadius = 10
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        uploadImage.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        uploadImage.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    private func setLocation() {
        // 델리게이트 설정
        locationManger.delegate = self
        // 거리 정확도 설정
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManger.requestWhenInUseAuthorization()
        
//        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
//            locationManger.startUpdatingLocation() //위치 정보 받아오기 시작
//            print(locationManger.location?.coordinate)
//        } else {
//            print("위치 서비스 Off 상태")
//        }
    }
    
    //알림창 설정
    private func enrollAlertEvent() {
        let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
            (action) in
            if self.PhotoAuth() {
                self.openAlbum()
            } else {
                self.AuthSettingOpen(AuthString: "앨범")
            }
            
        }
        let cameraAlertAction = UIAlertAction(title: "카메라", style: .default) {(action) in
            if self.CameraAuth() {
                self.openCamera()
            } else {
                self.AuthSettingOpen(AuthString: "카메라")
            }
            
        }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlertAction)
        self.alertController.addAction(cameraAlertAction)
        self.alertController.addAction(cancelAlertAction)
        guard let alertControllerPopoverPresentationController
                = alertController.popoverPresentationController
        else {return}
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    //MARK: - POST IMGUPLOAD
    func postUpload(_ parameters: UploadRequest) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
            let title = self.titleTextField.text ?? ""
            let content = self.contentTextView.text ?? ""
            let lat = self.lat_now
            let lng = self.lng_now
            
            let parameters: [String : Any] = [
                "userId": userId,
                "title": title,
                "content": content,
                "lat": lat,
                "lng": lng
            ]
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if let image = self.imageData {
                multipartFormData.append(image, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
            }
            
            //            if let image = self.uploadImage.image!.jpegData(compressionQuality: 0.5) {
            //                multipartFormData.append(image, withName: "img", fileName: "test.jpeg", mimeType: "image/jpeg")
            //                self.imageData = image
            //            }
            
        }, to: DailingURL.uploadURL, method: .post, headers: headers).responseDecodable(of: UploadResponse.self) { [self] response in
            switch response.result {
            case .success(let response):
                if response.success == true {
                    DailingLog.debug("PostUpload-success")
                    
                    let upload_alert = UIAlertController(title: "성공", message: "업로드가 완료 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        
                        //화면 끄기
                        self.dismiss(animated: true)
                    }
                    upload_alert.addAction(okAction)
                    present(upload_alert, animated: false, completion: nil)
                    
                    
                    
                } else {
                    DailingLog.error("PostUpload-fail")
                    let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    present(fail_alert, animated: false, completion: nil)
                    
                }
            case .failure(let error):
                DailingLog.error("PostUpload-err")
                print(error.localizedDescription)
                let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
                
            }
        }
    }
}

//MARK: Extension UIPopoverPresentation
extension UploadViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
            self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}

//MARK: - Extension UIImagePicker
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //앨범 띄우기
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    //카메라 띄우기
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.imagePickerController.sourceType = .camera
            present(self.imagePickerController, animated: false, completion: nil)
        }
        else {
            print ("Camera's not available as for now.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage.image = image
            imageData = uploadImage.image?.jpegData(compressionQuality: 0.5)
            photoIcon.isHidden = true
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 포토 라이브러리 접근 권한
    func PhotoAuth() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized: return true // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
        case .denied: break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
        case .limited: break // ?
        case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted: break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
        default: break
        }
        
        return false;
    }
    
    //카메라 접근 권한
    func CameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }
    
    //세팅창 오픈
    func AuthSettingOpen(AuthString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(AuthString) 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?"
            let authAlert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            
            let cancle = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
                print("\(String(describing: UIAlertAction.title)) 클릭")
            }
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            authAlert.addAction(cancle)
            authAlert.addAction(confirm)
            
            self.present(authAlert, animated: true, completion: nil)
        }
    }
}
//MARK: - Extension UITextViewDelegate
extension UploadViewController: UITextViewDelegate {
    
    private func setTextView(){
        
        countLabel.text = "0 / 100"
        
        //플레이스홀더 설정
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = .placeholderText
        contentTextView.font = UIFont(name: "Inter-Regular", size: 12)
        
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

extension UploadViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            print("GPS 권한이 설정됨")
            locationManger.startUpdatingLocation() //위치 정보 받아오기 시작
        case .restricted,.notDetermined:
            print("GPS 권한이 설정되지않음")
            self.locationManger.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한이 요청 거부됨")
            self.locationManger.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            
            lat_now = location.coordinate.latitude
            lng_now = location.coordinate.longitude
            
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
