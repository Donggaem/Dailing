//
//  MapViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import Alamofire

class MapViewController: UIViewController {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    private var selectedDate = ""
    private var selectedList: [UserObject] = []
    
    var testOneList: [PostObject] = []
    var testTwoList: [PostObject] = []
    var testThreeList: [PostObject] = []
    var testFourList: [PostObject] = []
    
    var postList: [PostObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setMap()
        setUI()
        postAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
    
    private func setUI() {
        //오늘날짜
        let date = NSDate()
        let toDayformatter = DateFormatter()
        toDayformatter.dateFormat = "yyyy-MM-dd"
        selectedDate = toDayformatter.string(from: date as Date)

        
        
    }
    
    private func postAPI() {
        let today = selectedDate
        let param = SelectedDateRequest(date: today)
        
        postSelectedDate(param)
    }
    
    
    //MARK: - POST SELECTEDDATE
    private func postSelectedDate(_ parameters: SelectedDateRequest){
        AF.request(DailingURL.selectedDateURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SelectedDateResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        
                        DailingLog.debug("postSelectedDate(Map) - Success")
                        selectedList.removeAll()
                        testOneList.removeAll()
                        testTwoList.removeAll()
                        testThreeList.removeAll()
                        testFourList.removeAll()
                        
                        selectedList = response.data
                        
                        for index in 0..<selectedList.endIndex {
                            
                            if selectedList[index].userId == "신형만" {
                                testOneList = selectedList[index].post
                                
                            } else if selectedList[index].userId == "봉미선" {
                                testTwoList = selectedList[index].post
                                
                            }else if selectedList[index].userId == "짱구" {
                                testThreeList = selectedList[index].post
                                
                            }else if selectedList[index].userId == "짱아" {
                                testFourList = selectedList[index].post
                                
                            }
                        }
                        
                        setPin()
                        
                    } else {
                        DailingLog.error("postSelectedDate(Map) - fail")
                        let loginFail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        loginFail_alert.addAction(okAction)
                        present(loginFail_alert, animated: false, completion: nil)
                        
                    }
                case .failure(let error):
                    DailingLog.error("postSelectedDate(Map) - err")
                    print(error.localizedDescription)
                    let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    loginFail_alert.addAction(okAction)
                    present(loginFail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

//MARK: - EXTENSION MAP
extension MapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        
        let modalStoryboard = UIStoryboard.init(name: "Map", bundle: nil)
        let modalVC = modalStoryboard.instantiateViewController(identifier: "ModalViewController") as? ModalViewController
        modalVC?.modalPresentationStyle = .pageSheet
        
        if let sheet = modalVC?.sheetPresentationController {
            
            //지원할 크기 지정
            sheet.detents = [.medium()]
            
        }
        
        modalVC?.paramtitle = postList[poiItem.tag].title
        modalVC?.paramcontent = postList[poiItem.tag].content
        modalVC?.paramimage = postList[poiItem.tag].image
        
        present(modalVC ?? UIViewController(), animated: true, completion: nil)
        
        return false
    }
    
    func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            
            // 현재 위치 트래킹
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
            self.view.addSubview(mapView)
        }
    }
    
    func setPin() {
        var cnt = 0
        postList.removeAll()
        for index in 0..<selectedList.endIndex {
            if selectedList[index].userId == "신형만" {
                for item in testOneList{
                    let poiltem = MTMapPOIItem()
                    poiltem.itemName = "신형만"
                    poiltem.markerType = .customImage
                    poiltem.customImageName = "pin1"
                    poiltem.markerSelectedType = .customImage
                    poiltem.customSelectedImageName = "pin1_1"
                    poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.lat, longitude: item.lng))
                    poiltem.tag = cnt
                    mapView!.addPOIItems([poiltem])
                    postList.append(item)
                    cnt += 1
                }
                
            } else if selectedList[index].userId == "봉미선" {
                for item in testTwoList{
                    let poiltem = MTMapPOIItem()
                    poiltem.itemName = "봉미선"
                    poiltem.markerType = .customImage
                    poiltem.customImageName = "pin2"
                    poiltem.markerSelectedType = .customImage
                    poiltem.customSelectedImageName = "pin2_2"
                    poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.lat, longitude: item.lng))
                    poiltem.tag = cnt
                    mapView!.addPOIItems([poiltem])
                    postList.append(item)
                    cnt += 1
                }
            }else if selectedList[index].userId == "짱구" {
                for item in testThreeList{
                    let poiltem = MTMapPOIItem()
                    poiltem.itemName = "짱구"
                    poiltem.markerType = .customImage
                    poiltem.customImageName = "pin3"
                    poiltem.markerSelectedType = .customImage
                    poiltem.customSelectedImageName = "pin3_3"
                    poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.lat, longitude: item.lng))
                    poiltem.tag = cnt
                    mapView!.addPOIItems([poiltem])
                    postList.append(item)
                    cnt += 1
                }
            }else if selectedList[index].userId == "짱아" {
                for item in testOneList{
                    let poiltem = MTMapPOIItem()
                    poiltem.itemName = "짱아"
                    poiltem.markerType = .customImage
                    poiltem.customImageName = "pin4"
                    poiltem.markerSelectedType = .customImage
                    poiltem.customSelectedImageName = "pin4_4"
                    poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.lat, longitude: item.lng))
                    poiltem.tag = cnt
                    mapView!.addPOIItems([poiltem])
                    postList.append(item)
                    cnt += 1
                }
            }
        }
    }
    
}
