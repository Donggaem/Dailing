//
//  MapViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    var latitude : Double = 37.576568
    var longitude : Double = 127.029148
    
    var allCircle = [MTMapCircle]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
//            // 현재 위치 트래킹
//            mapView.currentLocationTrackingMode = .onWithoutHeading
//            mapView.showCurrentLocationMarker = true
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.456518177069526, longitude: 126.70531256589555)), zoomLevel: 5, animated: true)
            self.view.addSubview(mapView)
        }
    }
    
    // poiItem 클릭 이벤트
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // 인덱스는 poiItem의 태그로 접근
        let index = poiItem.tag
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // mapView의 모든 poiItem 제거
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
}
    
