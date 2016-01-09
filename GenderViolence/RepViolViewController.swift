//
//  RepViolViewController.swift
//  GenderViolence
//
//  Created by Mauricio Oliveira on 1/3/16.
//  Copyright (c) 2016 Mauricio Oliveira. All rights reserved.
//

import UIKit

class RepViolViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var violenceTypeSegControl: UISegmentedControl!
    
    @IBOutlet weak var isVictimSegControl: UISegmentedControl!
    
    @IBOutlet weak var isDomesticViolenceSegControl: UISegmentedControl!
    
    @IBOutlet weak var pickerViolenceType: UIPickerView!
    
    @IBOutlet weak var pickerViolenceFrequency: UIPickerView!
    
    var pickerViolenceTypeData: [String] = [String]()
    var pickerFrequencyData: [String] = [String]()
    
    var reportViolence = ReportViolence()
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Creating PickerView options
        pickerViolenceTypeData = ["Man", "Woman", "Transgender"]
        pickerFrequencyData = ["First time", "2 to 4 times a week", "5 or more times a week"]
        
        //Doing something with PickerView
        self.pickerViolenceType.delegate = self
        self.pickerViolenceType.dataSource = self
        self.pickerViolenceFrequency.delegate = self
        self.pickerViolenceFrequency.dataSource = self
        
        createDatabaseAndTable()
        
    }
    
    func createDatabaseAndTable(){
        //Creating database file and table
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("reports.sqlite")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            let reportsDB = FMDatabase(path: databasePath as String)
            if reportsDB == nil {
                print("Error: \(reportsDB.lastErrorMessage())")
            }
            if reportsDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS REPORTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ZIPCODE TEXT, STATE TEXT, CITY TEXT, STREET TEXT, VIOLENCE_TYPE TEXT, IS_VICTIM TEXT, IS_DOMESTIC_VIOLENCE TEXT, GENDER_VICTIM TEXT, VIOLENCE_FREQUENCY TEXT)"
                if !reportsDB.executeStatements(sql_stmt) {
                    print("Error: \(reportsDB.lastErrorMessage())")
                }
                reportsDB.close()
            } else {
                print("Error: \(reportsDB.lastErrorMessage())")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            pickerFrequencyData.count
        }
        return pickerViolenceTypeData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return pickerFrequencyData[row]
        }
        return pickerViolenceTypeData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    
    @IBAction func reportClicked(sender: AnyObject) {
        
        reportViolence.zipCode = self.zipCodeTextField.text!
        reportViolence.state = self.stateTextField.text!
        reportViolence.city = self.cityTextField.text!
        reportViolence.street = self.streetTextField.text!
        reportViolence.violenceType = violenceTypeSegControl.titleForSegmentAtIndex(violenceTypeSegControl.selectedSegmentIndex)!
        reportViolence.isVictim = isVictimSegControl.titleForSegmentAtIndex(isVictimSegControl.selectedSegmentIndex)!
        reportViolence.isDomesticViolence = isDomesticViolenceSegControl.titleForSegmentAtIndex(isDomesticViolenceSegControl.selectedSegmentIndex)!
        
        let text = pickerViolenceTypeData[pickerViolenceType.selectedRowInComponent(0)]
        
        reportViolence.violenceGender = text
        reportViolence.violenceFrequency = pickerFrequencyData[pickerViolenceFrequency.selectedRowInComponent(0)]
        
        insertIntoTable(reportViolence)
        
        let mainScreen:ViewController = ViewController()
  
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    func insertIntoTable(report: ReportViolence){
        let reportsDB = FMDatabase(path: databasePath as String)
        var status = "null"
        
        if reportsDB.open() {
            
            let insertSQL = "INSERT INTO REPORTS (ZIPCODE, STATE, CITY, STREET, VIOLENCE_TYPE, IS_VICTIM, IS_DOMESTIC_VIOLENCE, GENDER_VICTIM, VIOLENCE_FREQUENCY) VALUES ('\(report.zipCode)', '\(report.state)', '\(report.city)', '\(report.street)', '\(report.violenceType)', '\(report.isVictim)', '\(report.isDomesticViolence)', '\(report.violenceGender)', '\(report.violenceFrequency)')"
            
            let result = reportsDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                status = "Failed to add report"
                print("Error: \(reportsDB.lastErrorMessage())")
            } else {
                status = "Violence Reported"
            }
        } else {
            print("Error: \(reportsDB.lastErrorMessage())")
        }
        
        print(status)
    }
    
    
}