//
//  MapViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import Alamofire
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    //위치
    var locationManger = CLLocationManager()
    var lat_now = 0.0
    var lng_now = 0.0
    
//    var latitude : Double = 37.576568
//    var longitude : Double = 127.029148
    
//    var allCircle = [MTMapCircle]()
    
    var userList: [UserObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        setMap()
        createPin(itemName: "갱", getla: 37.45452977974912, getlo: 127.1277079253931, markerType: .redPin)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
    
    //현재 위치
    private func setLocation() {
        // 델리게이트 설정
        locationManger.delegate = self
        // 거리 정확도 설정
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    //MARK: - GET PointMap
    private func getPointMap() {
        AF.request(DailingURL.getPointMapURL, method: .get, headers: nil)
            .validate()
            .responseDecodable(of: pointMapResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        print(DailingLog.debug("getPointMap-success"))
                    
                        self.userList = response.data
                        
                    } else {
                        print(DailingLog.error("getPointMap-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(DailingLog.error("getPointMap-err"))
                    print("failure: \(error.localizedDescription)")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
}
    
//MARK: - EXTENSION MAP
extension MapViewController: MTMapViewDelegate {
    
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
    
    func createPin(itemName: String, getla: Double, getlo: Double, markerType: MTMapPOIItemMarkerType) -> MTMapPOIItem{
        
        let poiltem = MTMapPOIItem()
        poiltem.itemName = itemName
        poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo))
        poiltem.markerType = markerType
        mapView!.addPOIItems([poiltem])
        
        return poiltem
    }
    
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let index = poiItem.tag
    }
}

//MARK: - EXTENSION LOCTION
extension MapViewController: CLLocationManagerDelegate {
    
    //위치 권한 함수
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
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")

            lat_now = location.coordinate.latitude
            lng_now = location.coordinate.longitude

        }
    }

    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
