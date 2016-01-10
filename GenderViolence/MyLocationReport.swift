//
//  MyLocationReport.swift
//  GenderViolence
//
//  Created by Mauricio Oliveira on 1/9/16.
//  Copyright © 2016 Mauricio Oliveira. All rights reserved.
//

import UIKit

class MyLacationReport: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var violenceTypeSegControl: UISegmentedControl!
    
    @IBOutlet weak var isVictimSegControl: UISegmentedControl!
    
    @IBOutlet weak var isDomesticViolenceSegControl: UISegmentedControl!
    
    @IBOutlet weak var pickerViolenceGender: UIPickerView!
    
    @IBOutlet weak var pickerViolenceFrequency: UIPickerView!
    
    var pickerViolenceGenderData: [String] = [String]()
    var pickerViolenceFrequencyData: [String] = [String]()
    
    var reportViolence = ReportViolence()
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating PickerView options
        pickerViolenceGenderData = ["Man", "Woman", "Transgender"]
        pickerViolenceFrequencyData = ["First time", "2 to 4 times a week", "5 or more times a week"]
        
        //Doing something with PickerView
        self.pickerViolenceGender.delegate = self
        self.pickerViolenceGender.dataSource = self
        self.pickerViolenceFrequency.delegate = self
        self.pickerViolenceFrequency.dataSource = self
        
        createDatabaseAndTable()
    }
    
    @IBAction func reportClicked(sender: AnyObject) {
        reportViolence.zipCode = "5115010"
        reportViolence.state = "Pernambuco"
        reportViolence.city = "Recife"
        reportViolence.street = "Av. dos Reitores"
        reportViolence.violenceType = violenceTypeSegControl.titleForSegmentAtIndex(violenceTypeSegControl.selectedSegmentIndex)!
        reportViolence.isVictim = isVictimSegControl.titleForSegmentAtIndex(isVictimSegControl.selectedSegmentIndex)!
        reportViolence.isDomesticViolence = isDomesticViolenceSegControl.titleForSegmentAtIndex(isDomesticViolenceSegControl.selectedSegmentIndex)!
        
        let text = pickerViolenceGenderData[pickerViolenceGender.selectedRowInComponent(0)]
        
        reportViolence.violenceGender = text
        reportViolence.violenceFrequency = pickerViolenceFrequencyData[pickerViolenceFrequency.selectedRowInComponent(0)]
        
        insertIntoTable(reportViolence)
        
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            pickerViolenceFrequencyData.count
        }
        return pickerViolenceGenderData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return pickerViolenceFrequencyData[row]
        }
        return pickerViolenceGenderData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
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
    
    func createDatabaseAndTable(){
        //Creating database file and table
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("reports.sqlite")
        
        if filemgr.fileExistsAtPath(databasePath as String) {
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
    
}