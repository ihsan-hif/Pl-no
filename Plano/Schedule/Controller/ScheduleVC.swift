//
//  ScheduleVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 06/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//


struct newEvent {
    var all_day : Bool
    var border_color : String
    var color : String
    var end : Date
    var id: Int
    var start : Date
    var text_color : String
    var title : String
    }


import UIKit
import KVKCalendar
import CloudKit
import CoreData
final class ScheduleVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    let dateFormatter = DateFormatter()
    var managedObjectContext = AppDelegate.viewContext
    var fetchedResultsController: NSFetchedResultsController<Todo>!
    
    @IBOutlet weak var taskTable: UITableView!
    private var events = [Event]()
    private var dataCell = [newEvent]()
    var dataTableView : [Todo] = []
    private var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = Date()
        return currentDate
//        return formatter.date(from: "\(currentDate)") ?? Date()
    }()
    
    func configureFetchedResultsController() {
        let todoFetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let primarySortDescriptor = NSSortDescriptor(key: "dateAndTime", ascending: true)
        //let secondarySortDescriptor = NSSortDescriptor(key: "status", ascending: true)
        let tertiarySortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        //let quaternarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        todoFetchRequest.sortDescriptors = [primarySortDescriptor, /*secondarySortDescriptor,*/ tertiarySortDescriptor/*, quaternarySortDescriptor*/]

        self.fetchedResultsController = NSFetchedResultsController<Todo>(
            fetchRequest: todoFetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "dateAndTime",
            cacheName: nil)

        self.fetchedResultsController.delegate = self

    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        return formatter.string(from: date)
    }
    
    
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
//        if let sections = fetchedResultsController.sections {
//            return sections.count
//        }

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let sections = fetchedResultsController.sections {
//            let currentSection = sections[section]
//            return currentSection.numberOfObjects
//        }
//
//        return 0
        dataTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        
        let todo = fetchedResultsController.object(at: indexPath)
        dateFormatter.locale = Locale(identifier: "en_ID")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")
//        print(todo.title)
        cell.textLabel?.text = dataTableView[indexPath.row].title
        cell.detailTextLabel?.text = dateToString(date: dataTableView[indexPath.row].dateAndTime!)
        return cell
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
        dateFormatter.locale = Locale(identifier: "en_ID")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")
        dataTableView.removeAll()
        for i in Todo.fetchAll()
        {
//            var newDate = formatter
            print(i.dateAndTime)
            print(selectDate)
            if i.dateAndTime == selectDate
            {
                dataTableView.append(i.`self`())
            }
        }
//        print(dataTableView)
        taskTable.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
//        print(type, event)
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
        
        configureFetchedResultsController()
        
        
        do {
            try fetchedResultsController.performFetch()
            taskTable.reloadData()
            
        } catch {
            print("An error occurred")
        }
        
        let todo = Todo.fetchAll()
        
//        for i in todo{
//            print(i.title!)
//        }
        
        
        
        
        guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let result = try? decoder.decode(ItemData.self, from: data) else { return }
        dataCell.append(newEvent(all_day: false, border_color: "#FFFFFF", color: "#93c47d", end: formatter(date: "2018-12-10T16:30:00+03:00"), id: 1, start: formatter(date: "2018-12-12T16:00:00+03:00"), text_color: "000000", title: "Event Test 1"))
        
//        print(dataCell.enumerated())
        
        
        for (idx, item) in todo.enumerated() {
            let startDate = item.dateAndTime
            let endDate = item.dateAndTime
//            let startTime = self.timeFormatter(date: startDate)
//            let endTime = self.timeFormatter(date: endDate)
//            let color = UIColor.hexStringToColor(hex: item.color)
            var event = Event()
            event.id = idx
            event.start = startDate!
            event.end = endDate!
            if(item.priority==0)
            {
                event.color = EventColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            }else if(item.priority==1)
            {
                event.color = EventColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
            }else
            {
                event.color = EventColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            }
            event.isAllDay = true
//            event.isContainsFile = !item.files.isEmpty
            event.textForMonth = item.title!
            event.text = "\(item.title)"
//            if item.all_day {
//                event.text = "\(item.title)"
//            } else {
//                event.text = "\(startTime) - \(endTime)\n\(item.title)"
//            }
            events.append(event)
            
        }
//        print(result)
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
