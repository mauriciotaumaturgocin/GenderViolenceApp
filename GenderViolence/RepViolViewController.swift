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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.pickerViolenceType.delegate = self
        self.pickerViolenceType.dataSource = self
        
        self.pickerViolenceFrequency.delegate = self
        self.pickerViolenceFrequency.dataSource = self
        
        pickerViolenceTypeData = ["Man", "Woman", "Transgender"]
        pickerFrequencyData = ["First time", "2 to 4 times a week", "5 or more times a week"]
        
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
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(self.zipCodeTextField.text, forKey: "zipCode")
        defaults.setObject(self.cityTextField.text, forKey: "city")
        defaults.setObject(self.stateTextField.text, forKey: "state")
        defaults.setObject(self.streetTextField.text, forKey: "street")
        defaults.setObject(violenceTypeSegControl.titleForSegmentAtIndex(isVictimSegControl.selectedSegmentIndex), forKey: "violenceType")
        defaults.setObject(isVictimSegControl.titleForSegmentAtIndex(isVictimSegControl.selectedSegmentIndex), forKey: "isVictim")
        defaults.setObject(isDomesticViolenceSegControl.titleForSegmentAtIndex(isDomesticViolenceSegControl.selectedSegmentIndex), forKey: "isDomesticViolence")
        
        var text = pickerViolenceTypeData[pickerViolenceType.selectedRowInComponent(0)]
        
        defaults.setObject(text, forKey: "violenceGender")
        defaults.setObject(pickerFrequencyData[pickerViolenceFrequency.selectedRowInComponent(0)], forKey: "violenceFrequency")
        
        
        defaults.synchronize()
        
        print(text)
        print("saved")
    }
    
    
}