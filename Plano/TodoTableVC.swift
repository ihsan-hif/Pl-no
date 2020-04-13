//
//  TodoTableVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 07/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import AuthenticationServices
import CloudKit
import CoreData
import SwipeCellKit

class TodoTableVC: UITableViewController, NSFetchedResultsControllerDelegate, SwipeTableViewCellDelegate {
    
    var managedObjectContext = AppDelegate.viewContext
    var fetchedResultsController: NSFetchedResultsController<Todo>!
    var indicator: UIActivityIndicatorView!
    let dateFormatter = DateFormatter()
    
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
        
        configureFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
            
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        } catch {
            print("An error occurred")
            
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        }
    }

    
    
    // MARK: - IBAction
//    @objc func checkBoxButtonAction(_ sender: UIButton) {
//        //let buttonTag = sender.tag
//        if todoToDelete?.status == false {
//            managedObjectContext.performAndWait {
//                todoToDelete?.status = true
//                try? managedObjectContext.save()
//            }
//        }
//        else {
//            managedObjectContext.performAndWait {
//                todoToDelete?.status = false
//                try? managedObjectContext.save()
//            }
//        }
//
//    }
    
    
    // MARK: - Functions
    func handleRefresh() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    func notifyDelegate(){
        // reload core data here
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color(forStyle: buttonStyle)
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color(forStyle: buttonStyle)
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    
    
    // MARK: Fetched Results Controller Configuration
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
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = fetchedResultsController.sections {
            return sections.count
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let numberOfObjects = fetchedResultsController.fetchedObjects?[section] {
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_ID")
//            dateFormatter.dateFormat = "MMM d, yyyy" // Date format for todoDate
//            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")
//            let todoDate = dateFormatter.date(from: "\(numberOfObjects.dateAndTime!)")
//            let currentDate = Date()
//            let result = Calendar.current.compare(currentDate, to: todoDate!, toGranularity: .day)
//            let tomorrowDate = currentDate.addingTimeInterval(60 * 60 * 24)
//            let result1 = Calendar.current.compare(tomorrowDate, to: todoDate!, toGranularity: .day)
//
//            if result == ComparisonResult.orderedSame {
//                return "Today"
//            }
//            if result1 == ComparisonResult.orderedSame {
//                return "Tomorrow"
//            }
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "dd MMMM, yyyy"
//
//            return dateFormatter1.string(from: todoDate!)
//        }
//
//        return nil
        
        dateFormatter.locale = Locale(identifier: "en_ID")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")

        guard let sectionInfo = fetchedResultsController?.fetchedObjects?[section] else {
            return nil
        }
        
        print("\(dateFormatter.string(from: sectionInfo.dateAndTime!))")
        return "\(dateFormatter.string(from: sectionInfo.dateAndTime!))"
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if isDarkMode ==  true {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        }
        else {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        cell.delegate = self
        
        let todo = fetchedResultsController.object(at: indexPath)
        dateFormatter.locale = Locale(identifier: "en_ID")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todo.title!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

        // Configure the cell...
        if isDarkMode == true {
            cell.todoCellView.backgroundColor = .systemGray5
        }
        else {
            cell.todoCellView.backgroundColor = .systemGroupedBackground
            cell.todoCellView.shadowColor = .black
            cell.todoCellView.shadowOffset = CGSize(width: 0, height: 0)
            cell.todoCellView.shadowRadius = 2
            cell.todoCellView.shadowOpacity = 0.3
        }
        cell.todoCellView.cornerRadius = 10
        
        //cell.checkboxButtonOutlet.addTarget(self, action: #selector(self.checkBoxButtonAction(_:)), for: .touchUpInside)
        cell.titleLabel.text = todo.title
        if todo.status == false {
            //cell.todoCellView.backgroundColor = .systemGroupedBackground
            cell.checkboxButtonOutlet.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
        else {
            //cell.titleLabel.attributedText = attributeString
            //cell.todoCellView.backgroundColor = .lightGray
            cell.checkboxButtonOutlet.setImage(UIImage(named: "Checked"), for: .normal)
        }
        
        //cell.titleLabel.text = todo.title
        cell.dateAndTimeLabel.text = "\(dateFormatter.string(from: todo.dateAndTime!))"
        if todo.priority == 0 {
            cell.priorityImage.image = UIImage(named: "Low")
        }
        else if todo.priority == 1 {
            cell.priorityImage.image = UIImage(named: "Medium")
        }
        else {
            cell.priorityImage.image = UIImage(named: "High")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            let todo = fetchedResultsController.object(at: indexPath)
//            confirmDeleteForTodo(todo)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            let status = SwipeAction(style: .default, title: nil) { action, indexPath in
                let todo = self.fetchedResultsController.object(at: indexPath)
//                let updatedStatus = todo.status
//                self.todoToUpdate?.status = updatedStatus
                
                self.statusUpdateForTodo(todo)
                
                let cell = tableView.cellForRow(at: indexPath) as! TodoCell
                cell.setStatus(todo.status, animated: true)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todo.title!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

                if todo.status == false {
                    cell.checkboxButtonOutlet.setImage(UIImage(named: "Unchecked"), for: .normal)
                    //cell.titleLabel.text = todo.title
                    //cell.todoCellView.emptyBackgroundTo(point: cell.checkboxButtonOutlet.center, with: .systemGroupedBackground, in: 0.5)
                    //cell.todoCellView.backgroundColor = .systemGroupedBackground
                }
                else {
                    cell.checkboxButtonOutlet.setImage(UIImage(named: "Checked"), for: .normal)
                    //cell.titleLabel.text = todo.title
                    //cell.todoCellView.fillBackgroundFrom(point: cell.checkboxButtonOutlet.center, with: .lightGray, in: 0.5)
                    //cell.todoCellView.backgroundColor = .lightGray
                }
            }
            status.hidesWhenSelected = true
            configure(action: status, with: .done)
            
            return [status]
        }
        else {
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                // Delete the row from the data source
                let todo = self.fetchedResultsController.object(at: indexPath)
                self.confirmDeleteForTodo(todo)
            }
            configure(action: delete, with: .trash)

            return [delete]
        }
    }
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = orientation == .left ? .selection : .destructive
//        options.transitionStyle = .border
//
//        switch buttonStyle {
//        case .backgroundColor:
//            options.buttonSpacing = 4
//        case .circular:
//            options.buttonSpacing = 4
//        #if canImport(Combine)
//            if #available(iOS 13.0, *) {
//                options.backgroundColor = UIColor.systemGray6
//            } else {
//                options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
//            }
//        #else
//            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
//        #endif
//        }
//
//        return options
//    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: Delete Confirmation and Handling Plus Status Update
    var todoToUpdate: Todo?
    
    func confirmDeleteForTodo(_ todo: Todo) {
        
        self.todoToUpdate = todo
        
        let alertController = UIAlertController(title: "Delete Todo",
                                                message: "Are you sure you want to delete this Todo?",
                                                preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            (_) -> Void in
            
            self.managedObjectContext.delete(self.todoToUpdate!)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                self.managedObjectContext.rollback()
                print("Something went wrong: \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func statusUpdateForTodo(_ todo: Todo) {
        self.todoToUpdate = todo

        if todoToUpdate?.status == true {
            todoToUpdate?.status = false
            print(todoToUpdate?.status)
            do {
                try self.managedObjectContext.save()
            } catch {
                self.managedObjectContext.rollback()
                print("Something went wrong: \(error)")
            }
        }
        else {
            todoToUpdate?.status = true
            print(todoToUpdate?.status)
            do {
                try self.managedObjectContext.save()
            } catch {
                self.managedObjectContext.rollback()
                print("Something went wrong: \(error)")
            }
        }
    }
    
    // MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = self.tableView.cellForRow(at: updateIndexPath)
                let updatedTodo = self.fetchedResultsController.object(at: updateIndexPath)
                
                cell?.textLabel?.text = updatedTodo.title
                //cell?.detailTextLabel?.text = updatedBlogIdea.ideaDescription
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
        
        switch type {
        case .insert:
            self.tableView.insertSections(sectionIndexSet, with: .fade)
        case .delete:
            self.tableView.deleteSections(sectionIndexSet, with: .fade)
        default:
            break
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
       guard let subTodoTableVC = segue.destination as? SubTodoTableVC else { return }
        subTodoTableVC.managedObjectContext = self.managedObjectContext

       if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
           let selectedTodo = self.fetchedResultsController.object(at: selectedIndexPath)
           subTodoTableVC.todo = selectedTodo
       }
    }

}
