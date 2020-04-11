//
//  AddTodoTableVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 07/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class AddTodoTableVC: UITableViewController, UITextFieldDelegate {
    var indicator: UIActivityIndicatorView!
    var managedObjectContext = AppDelegate.viewContext
    var todo: Todo!
    var subTodo = SubTodoTableVC()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePickerVisible: Bool = false
    
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
        
        if todo == nil {
            todo = (NSEntityDescription.insertNewObject(forEntityName: Todo.entityName, into: managedObjectContext) as? Todo)
        }
        
        if todo.value(forKey: "title") == nil {
            todo.setValue(titleTextField.text, forKey: "title")
        }
        
        todo.title = titleTextField.text
        todo.board = selectedBoard[0]
        todo.priority = Int64(selectedPriorityInt[0])
        todo.reminder = selectedReminder[0]
        //self.blogIdea.ideaDescription = self.descriptionTextField.text
        
        do {
            try managedObjectContext.save()
            
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            
            _ = self.navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Trouble Saving",
                                          message: "Something went wrong when trying to save the Todo.  Please try again...",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: {(action: UIAlertAction) -> Void in
                                            self.managedObjectContext.rollback()
                                            self.todo = NSEntityDescription.insertNewObject(forEntityName: Todo.entityName, into: self.managedObjectContext) as? Todo
                                            
            })
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dateAndTimeLabel.text = "\(datePicker.date)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        setupView()
//
//        // Update Helper
//        self.newTodo = self.todo == nil
//
//        // Add Observer
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(AddTodoTableVC.textFieldTextDidChange(notification:)), name: UITextField.textDidChangeNotification, object: titleTextField)
        
        datePickerVisible = false
        datePicker.isHidden = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        setUIValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        //titleTextField.text = subTodo.navigationItem.title
        boardLabel.text = selectedBoard[0]
        priorityLabel.text = selectedPriority[0]
        reminderLabel.text = selectedReminder[0]
    }
    
    
    
    // MARK: - Set UI
    func setUIValues() {
        guard let todo = self.todo else { return }
        
        titleTextField.placeholder = todo.title
        boardLabel.text = todo.board
        priorityLabel.text = "\(todo.priority)"
        reminderLabel.text = todo.reminder
        //self.descriptionTextField.text = blogIdea.ideaDescription
    }
    
//    private func setupView() {
//        updateTitleTextField()
//        updateDoneButton()
//        updateActivityIndicator()
//    }
    
    // MARK: - Functions
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    
//    private func updateTitleTextField() {
//        if let title = todo?.object(forKey: "title") as? String {
//            titleTextField.text = title
//        }
//    }
//
//    // MARK: -
//    private func updateDoneButton() {
//        let text = titleTextField.text
//
//        if let title = text {
//            doneButtonOutlet.isEnabled = !title.isEmpty
//        } else {
//            doneButtonOutlet.isEnabled = false
//        }
//    }
//
//    // MARK: -
//    private func updateActivityIndicator() {
//        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
//        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        activityIndicator.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.isHidden = true
//        activityIndicator.center = view.center
//        self.view.addSubview(activityIndicator)
//    }
    
    // MARK: -
    // MARK: Notification Handling
//    @objc func textFieldTextDidChange(notification: NSNotification) {
//        updateDoneButton()
//    }
//
//
//    @IBAction func cancel(sender: AnyObject) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func save(sender: AnyObject) {
//
//
//    }
    
    // MARK: -
    // MARK: Helper Methods
//    private func processResponse(record: CKRecord?, error: Error?) {
//        var message = ""
//
//        if let error = error {
//            print(error)
//            message = "We were not able to save your list."
//
//        } else if record == nil {
//            message = "We were not able to save your list."
//        }
//
//        if !message.isEmpty {
//            // Initialize Alert Controller
//            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//
//            // Present Alert Controller
//            present(alertController, animated: true, completion: nil)
//
//        } else {
//            // Notify Delegate
//            if newTodo {
//                delegate?.controller(controller: self, didAddList: todo!)
//            } else {
//                delegate?.controller(controller: self, didUpdateList: todo!)
//            }
//
//            // Pop View Controller
//            self.navigationController?.popViewController(animated: true)
//        }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else if section == 1 {
            return ""
        }
        else {
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        if section == 0 {
//            return 1
//        }
//        else if section == 1 {
//            return 2
//        }
//        else {
//            return 3
//        }
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "addTodoCell", for: indexPath) as! AddTodoCell
//
//        // Configure the cell...
//        //let currentItem = self.dataSource[indexPath.section].items[indexPath.row]
//
////        if indexPath.section == 1 {
////            if indexPath.row == 0 {
////                cell.leftLabel.text = "Board"
////                cell.rightLabel.text = selectedBoard[indexPath.row]
////            }
////            else if indexPath.row == 1 {
////                cell.leftLabel.text = "Priority"
////            }
////        }
////        else if indexPath.section == 2 {
////            if indexPath.row == 0 {
////                cell.leftLabel.text = "Date & Time"
////            }
////            else if indexPath.row == 1 {
////                cell.leftLabel.text = "Reminder"
////            }
////        }
//
//
//        cell.layoutIfNeeded()
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.rowHeight
        if indexPath.section == 3 && indexPath.row == 2 {
            height = self.datePickerVisible ? 216.0 : 0.0
            return height
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

        if indexPath.section == 3 && indexPath.row == 1 {
            if datePickerVisible {
                hideStatusPickerCell()
            } else {
                showStatusPickerCell()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    
    func showStatusPickerCell() {
        datePickerVisible = true
        tableView.beginUpdates()
        tableView.endUpdates()
        datePicker.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 1.0
        }) { finished in
            self.datePicker.isHidden = false
        }
    }

    func hideStatusPickerCell() {
        datePickerVisible = false
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0.0
        }) { finished in
            self.datePicker.isHidden = true
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        managedObjectContext.rollback()
    }

}
