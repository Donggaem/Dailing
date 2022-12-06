//
//  CalendarViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import FSCalendar
import Alamofire

class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var todoTableView: UITableView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var calendarHeight: NSLayoutConstraint!
    private var selectedDate = ""
    
    private var allTodo: [DotObject] = []
    private var events: [String] = []
    
    private let sections: [String] = ["test1", "test2"]
    var testList: [String] = ["test1", "test1", "test1"]
    var tableSwitch = true
    
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
        
        getAllTodo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        todoTableView.reloadData()
        calendarView.reloadData()
    }
    
    //캘린더 스와이프 액션
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up {
            calendarView.setScope(.week, animated: true)
            
            self.tableSwitch = false
            self.todoTableView.reloadData()
            
        } else if swipe.direction == .down {
            calendarView.setScope(.month, animated: true)
            
            self.tableSwitch = true
            self.todoTableView.reloadData()
            
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
        
        //TableView
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        self.todoTableView.register(UINib(nibName: "TodoImgTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoImgTableViewCell")
        
        todoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기
        todoTableView.sectionHeaderTopPadding = 0
        todoTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNonzeroMagnitude))
        self.todoTableView.reloadData()
        
        //스와이프 액션
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    //MARK: - GET AllTodo
    private func getAllTodo() {
        AF.request(DailingURL.getAlltodoURL, method: .get, headers: nil)
            .validate()
            .responseDecodable(of: GetAllTodoResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        print(DailingLog.debug("getAllTodo-success"))
                        
                        self.allTodo.removeAll()
                        
                        self.allTodo = response.data
                        
                        self.setEvents()
                        self.calendarView.reloadData()
                        self.todoTableView.reloadData()
                        
                    } else {
                        print(DailingLog.error("getAllTodo-fail"))
                        let fail_alert = UIAlertController(title: "실패", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        fail_alert.addAction(okAction)
                        self.present(fail_alert, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print(DailingLog.error("getAllTodo-err"))
                    print("failure: \(error.localizedDescription)")
                    let fail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    fail_alert.addAction(okAction)
                    self.present(fail_alert, animated: false, completion: nil)
                }
            }
    }
    
}

//MARK: 테이블뷰
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate{
    
    //몇개의 섹션을 반환할지 Return하는 메소드
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 섹션의 타이틀을 리턴
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // 몇개의 Cell을 반환할지 Return하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableSwitch == true {
            let downcell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
            
            downcell.dot.layer.cornerRadius = downcell.dot.frame.height/2
            downcell.dot.clipsToBounds = true
            downcell.todoTitle.text = testList[indexPath.row]
            
            return downcell
        }else {
            let upcell = tableView.dequeueReusableCell(withIdentifier: "TodoImgTableViewCell", for: indexPath) as! TodoImgTableViewCell
            
            upcell.dot.layer.cornerRadius = upcell.dot.frame.height/2
            upcell.dot.clipsToBounds = true
            upcell.todoTitle.text = testList[indexPath.row]
            
            return upcell
        }
        
        
        
        
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //셀 밀어서 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //    //투두 삭제
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //            let tbDelete_alert = UIAlertController(title: "삭제", message: "투두를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
    //
    //            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
    //
    //                let uuid = self.selectedList[indexPath.row].id
    //                let param = DeleteTodoRequest(id: uuid )
    //                self.postDelete(param)
    //
    //            }
    //
    //            let noAction = UIAlertAction(title: "아니요", style: .default)
    //            tbDelete_alert.addAction(okAction)
    //            tbDelete_alert.addAction(noAction)
    //
    //            present(tbDelete_alert, animated: false, completion: nil)
    //
    //        }
    //    }
}

//MARK: 캘린더
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
//        calendarView.appearance.eventDefaultColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
//        calendarView.appearance.eventSelectionColor = UIColor.init(red: 0.231, green: 0.51, blue: 0.965, alpha: 1)
        
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
        events.removeAll()
        
        for index in 0..<allTodo.endIndex {
            let arr = allTodo[index].date
            
            events.append(arr)
        }
    }
    
    //이벤트 닷 표시갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        setEvents()
        let eventformatter = DateFormatter()
        eventformatter.dateFormat = "yyyy-MM-dd"
        let eventDate = eventformatter.string(from: date)
        
        var dotcount = 0
        
        if events.contains(eventDate) {
            for index in 0..<allTodo.endIndex {
                if allTodo[index].date == eventDate {
                    dotcount = allTodo[index].userList.count
                }
            }
            return dotcount
        } else {
            return 0
        }
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
//
//    }
}
