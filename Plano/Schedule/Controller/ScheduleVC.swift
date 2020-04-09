//
//  ScheduleVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 06/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import KVKCalendar

final class ScheduleVC: UIViewController {
    
    @IBOutlet weak var taskTable: UITableView!
    private var events = [Event]()
    
    private var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = Date()
//        return date
        return formatter.date(from: "14.12.2018") ?? Date()
    }()
    
    private lazy var todayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(today))
        button.tintColor = .red
        return button
    }()
    
    private lazy var style: Style = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.month.isHiddenSeporator = true
            style.timeline.widthTime = 40
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
        } else {
            style.timeline.widthEventViewer = 500
        }
        style.timeline.startFromFirstEvent = false
        style.followInSystemTheme = true
        style.timeline.offsetTimeY = 80
        style.timeline.offsetEvent = 3
        style.timeline.currentLineHourWidth = 40
        style.allDay.isPinned = true
        style.startWeekDay = .sunday
        style.timeHourSystem = .twelveHour
        style.event.isEnableMoveEvent = true
        return style
    }()
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
//    private lazy var segmentedControl: UISegmentedControl = {
//        let array: [CalendarType]
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            array = CalendarType.allCases
//        } else {
//            array = CalendarType.allCases.filter({ $0 != .year })
//        }
//        let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
//        control.tintColor = .red
//        control.selectedSegmentIndex = 2
//        control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
//        return control
//    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let array = ["Personal","Team"]
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            array = CalendarType.allCases
//        } else {
//            array = CalendarType.allCases.filter({ $0 != .year })
//        }
        let control = UISegmentedControl(items: array)
        
        control.tintColor = .red
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
        return control
    }()
    
    private lazy var eventViewer: EventViewer = {
        let view = EventViewer(frame: CGRect(x: 0, y: 0, width: 500, height: calendarView.frame.height))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(calendarView)
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = todayButton
        
        calendarView.addEventViewToDay(view: eventViewer)
        calendarView.set(type: CalendarType.month, date: selectDate)
        
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.frame
        frame.origin.y = 50
        frame.size.height = 500
        calendarView.reloadFrame(frame)
    }
    
    @objc func today(sender: UIBarButtonItem) {
        calendarView.scrollTo(Date())
    }
    
    @objc func switchCalendar(sender: UISegmentedControl) {
        let type = CalendarType.month
        calendarView.set(type: CalendarType.month, date: selectDate)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }
    }
}

extension ScheduleVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
        cell?.textLabel!.text="tes123"
        return cell!
    }
    
    
}


extension ScheduleVC: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        var eventTemp = event
        guard let startTemp = start, let endTemp = end else { return }
        
        let startTime = timeFormatter(date: startTemp)
        let endTime = timeFormatter(date: endTemp)
        eventTemp.start = startTemp
        eventTemp.end = endTemp
        eventTemp.text = "\(startTime) - \(endTime)\n new time"
        
        if let idx = events.firstIndex(where: { $0.compare(eventTemp) }) {
            events.remove(at: idx)
            events.append(eventTemp)
            calendarView.reloadData()
        }
    }
    
    func didAddEvent(_ date: Date?) {
        print(date)
    }
    
    func didSelectDate(_ date: Date?, type: CalendarType, frame: CGRect?) {
        selectDate = date ?? Date()
        calendarView.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        switch type {
        case .day:
            eventViewer.text = event.text
        default:
            break
        }
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func eventViewerFrame(_ frame: CGRect) {
        eventViewer.reloadFrame(frame: frame)
    }
}

extension ScheduleVC: CalendarDataSource {
    func eventsForCalendar() -> [Event] {
        return events
    }
}

extension ScheduleVC {
    func loadEvents(completion: ([Event]) -> Void) {
        var events = [Event]()
        let decoder = JSONDecoder()
                
        guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let result = try? decoder.decode(ItemData.self, from: data) else { return }

        for (idx, item) in result.data.enumerated() {
            let startDate = self.formatter(date: item.start)
            let endDate = self.formatter(date: item.end)
            let startTime = self.timeFormatter(date: startDate)
            let endTime = self.timeFormatter(date: endDate)

            var event = Event()
            event.id = idx
            event.start = startDate
            event.end = endDate
            event.color = EventColor(item.color)
            event.isAllDay = item.allDay
            event.isContainsFile = !item.files.isEmpty
            event.textForMonth = item.title

            if item.allDay {
                event.text = "\(item.title)"
            } else {
                event.text = "\(startTime) - \(endTime)\n\(item.title)"
            }
            events.append(event)
            
        }
        print(events[0])
        completion(events)
    }
    
    func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.timeHourSystem == .twelveHour ? "h:mm a" : "HH:mm"
        return formatter.string(from: date)
    }
    
    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
}

extension ScheduleVC: UIPopoverPresentationControllerDelegate {
    
}

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}
struct Item: Decodable {
    let id: String
    let title: String
    let start: String
    let end: String
    let color: UIColor
    let colorText: UIColor
    let files: [String]
    let allDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case start
        case end
        case color
        case colorText = "text_color"
        case files
        case allDay = "all_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        start = try container.decode(String.self, forKey: CodingKeys.start)
        end = try container.decode(String.self, forKey: CodingKeys.end)
        allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
        files = try container.decode([String].self, forKey: CodingKeys.files)
        let strColor = try container.decode(String.self, forKey: CodingKeys.color)
        color = UIColor.hexStringToColor(hex: strColor)
        let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
        colorText = UIColor.hexStringToColor(hex: strColorText)
    }
}

extension UIColor {
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
        )
    }
}
