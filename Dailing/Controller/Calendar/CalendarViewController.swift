//
//  CalendarViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var calendarHeight: NSLayoutConstraint!
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
        setCalendar()
        
    }
    
    //캘린더 스와이프 액션
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up {
            calendarView.setScope(.week, animated: true)
        } else if swipe.direction == .down {
            calendarView.setScope(.month, animated: true)
        }
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

        //스와이프 액션
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
}

//MARK:
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    //캘린더 높이 액션
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendarHeight.constant = bounds.height
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
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
