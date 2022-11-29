//
//  CalendarViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet var caledarBackgroundView: UIView!
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    private var selectedDate = ""
    
    //날짜 포맷
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    private func setUI() {
        
        self.view.bringSubviewToFront(calendarView)
        
        //오늘날짜
        let date = NSDate()
        let toDayformatter = DateFormatter()
        toDayformatter.dateFormat = "yyyy-MM-dd"
        selectedDate = toDayformatter.string(from: date as Date)
        
        let dayfotmatter = DateFormatter()
        dayfotmatter.locale = Locale(identifier: "ko_KR")
        dayfotmatter.dateFormat = "dd.EE"
        dayLabel.text = dayfotmatter.string(from: date as Date)
        
        //CalendarView
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        setCalendar()
        
        //CAGradientLayer 생성
        let layerCB = CAGradientLayer()
        layerCB.bounds = caledarBackgroundView.bounds.insetBy(dx: -0.5*caledarBackgroundView.bounds.size.width, dy: -0.5*caledarBackgroundView.bounds.size.height)
        layerCB.position = caledarBackgroundView.center
        //색상설정
        let colors: [CGColor] = [
          UIColor(red: 1, green: 0.628, blue: 0.56, alpha: 0.56).cgColor,
          UIColor(red: 1, green: 0.501, blue: 0.485, alpha: 0.75).cgColor
        ]
        layerCB.colors = colors

        layerCB.locations = [0, 1] //정지위치
        layerCB.startPoint = CGPoint(x: 0.25, y: 0.5) //시작점
        layerCB.endPoint = CGPoint(x: 0.75, y: 0.5) //끝점
        layerCB.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0)) //모양
        
//        caledarBackgroundView.layer.addSublayer(layerCB) //적용
    }
    
}

//MARK:
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    private func setCalendar() {
        
        calendarView.placeholderType = .none // 전,다음달 날짜 숨기기
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.titleDefaultColor = .white // 평일 날짜 색깔
        calendarView.appearance.titleWeekendColor = .white // 주말 날짜 색깔
        calendarView.appearance.weekdayTextColor = .white // 요일 날짜 색깔
        calendarView.appearance.weekdayFont = UIFont(name: "Inter-Regular", size: 15) // 요일 폰트
        calendarView.appearance.titleFont = UIFont(name: "Inter-SemiBold", size: 14) // 날짜 폰트
        
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.calendarHeaderView.isHidden = true // 헤더 숨기기
        calendarView.headerHeight = 0 // 헤더 높이 조정
        
        //이벤트 닷
        calendarView.appearance.eventDefaultColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        calendarView.appearance.eventSelectionColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        
        //오늘, 선택한 날짝 색
        calendarView.appearance.todayColor = UIColor.init(red: 0.176, green: 0.831, blue: 0.749, alpha: 1)
        calendarView.appearance.selectionColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        
        //yearLabel설정
        monthLabel.text = dateFormatter.string(from: calendarView.currentPage)
        monthLabel.sizeToFit()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthLabel.text = self.dateFormatter.string(from: calendarView.currentPage)
    }
    
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //        selectedDate = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateformatter.string(from: date)
        print(selectedDate)
        
        let dayfotmatter = DateFormatter()
        dayfotmatter.locale = Locale(identifier: "ko_KR")
        dayfotmatter.dateFormat = "dd.EE"
        dayLabel.text = dayfotmatter.string(from: date)

        
//        todoTableView.reloadData()
//        //        calendarView.reloadData()
//        getTodo()
//        print(selectedList)
    }
    
    private func setEvents(){
//        events.removeAll()
//
//        for index in 0..<todoList.endIndex {
//            let arr = todoList[index].date.components(separatedBy: "T00:00:00.000Z")
//            events.append(arr[0])
//        }
    }
    
//    //이벤트 닷 표시갯수
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        setEvents()
//        let eventformatter = DateFormatter()
//        eventformatter.dateFormat = "yyyy-MM-dd"
//        let eventDate = eventformatter.string(from: date)
//
//        if events.contains(eventDate) {
//            return 1
//        } else {
//            return 0
//        }
//    }
}
