//
//  RepViolViewController.swift
//  GenderViolence
//
//  Created by Mauricio Oliveira on 1/3/16.
//  Copyright (c) 2016 Mauricio Oliveira. All rights reserved.
//

import UIKit

class RepViolViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerViolenceType: UIPickerView!
    
    
    var pickerViolenceTypeData: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.pickerViolenceType.delegate = self
        self.pickerViolenceType.dataSource = self
        
        pickerViolenceTypeData = ["Man", "Woman", "Transgender"]
        
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
        return pickerViolenceTypeData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViolenceTypeData[row]
    }
    
    
}