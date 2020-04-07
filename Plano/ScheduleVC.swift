//import UIKit
//import KVKCalendar
//
//class ScheduleVC: UIViewController {
//    var events = [Event]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let calendar = CalendarView(frame: CGRect.init())
//        calendar.dataSource = self
//        view.addSubview(calendar)
//        
//        createEvents { (events) in
//            self.events = events
////            self.calendarView.reloadData()
//        }
//    }
//}
//
//extension ScheduleVC {
//    func createEvents(completion: ([Event]) -> Void) {
//        let models = // Get events from storage / API
//        var events = [Event]()
//        
//        for model in models {
//            var event = Event()
//            event.id = model.id
//            event.start = model.startDate // start date event
//            event.end = model.endDate // end date event
//            event.color = model.color
//            event.isAllDay = model.allDay
//            event.isContainsFile = !model.files.isEmpty
//        
//            // Add text event (title, info, location, time)
//            if model.allDay {
//                event.text = "\(model.title)"
//            } else {
//                event.text = "\(startTime) - \(endTime)\n\(model.title)"
//            }
//            events.append(event)
//        }
//        completion(events)
//    }
//}
//
//extension ScheduleVC: CalendarDataSource {
//    func eventsForCalendar() -> [Event] {
//        return events
//    }
//}
