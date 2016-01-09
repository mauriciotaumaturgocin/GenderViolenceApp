//
//  ReportViolence.swift
//  GenderViolence
//
//  Created by Mauricio Oliveira on 1/8/16.
//  Copyright (c) 2016 Mauricio Oliveira. All rights reserved.
//

import Foundation

class ReportViolence {
    
    private var _zipCode = "null"
    var _state = "null"
    var _city = "null"
    var _street = "null"
    var _violenceType = "null"
    var _isVictim = "null"
    var _isDomesticViolence = "null"
    var _violenceGender = "null"
    var _violenceFrequency = "null"
    
    func ReportViolence(){
        
    }
    
    var zipCode:String {
        get {
            return _zipCode
        }
        set(zipCode){
            _zipCode = zipCode
        }
    }
    
    var state:String {
        get{
            return _state
        }
        set (state){
            _state = state
        }
    }
    
    var city:String {
        get{
            return _city
        }
        set (city){
            _city = city
        }
    }

    var street:String {
        get{
            return _street
        }
        set (street){
            _street = street
        }
    }
    
    var violenceType:String {
        get{
            return _violenceType
        }
        set (violenceType){
            _violenceType = violenceType
        }
    }
    
    var isVictim:String {
        get{
            return _isVictim
        }
        set (isVictim){
            _isVictim = isVictim
        }
    }
    
    var isDomesticViolence:String {
        get{
            return _isDomesticViolence
        }
        set (isDomesticViolence){
            _isDomesticViolence = isDomesticViolence
        }
    }
    
    var violenceGender:String {
        get{
            return _violenceGender
        }
        set (violenceGender){
            _violenceGender = violenceGender
        }
    }
    
    var violenceFrequency:String {
        get{
            return _violenceFrequency
        }
        set (violenceFrequency){
            _violenceFrequency = violenceFrequency
        }
    }
    
    
    
}