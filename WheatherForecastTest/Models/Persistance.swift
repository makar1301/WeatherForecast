//
//  Persistance.swift
//  WheatherForecastTest
//
//  Created by mac on 16.05.2021.
//

import Foundation

class Persistance {
    static let shared = Persistance()
    private let kIconKey = "Persistance.kIconKey"
    private let kCityKey = "Persistance.kCityKey"
    private let kCityIdKey = "Persistance.kCityIdKey"
    private let kTempKey = "Persistance.kTempKey"
    private let kCommentKey = "Persistance.kCommentKey"
    private let kDescriptionKey = "Persistance.kDescriptionKey"
    
    var icon: String? {
        set { UserDefaults.standard.set(newValue, forKey: kIconKey) }
        get { return UserDefaults.standard.string(forKey: kIconKey)}
    }
    
    var city: String? {
        set { UserDefaults.standard.set(newValue, forKey: kCityKey) }
        get { return UserDefaults.standard.string(forKey: kCityKey)}
    }
    
    var cityId: Int? {
        set { UserDefaults.standard.set(newValue, forKey: kCityIdKey) }
        get { return UserDefaults.standard.integer(forKey: kCityIdKey)}
    }
    
    var temp: Int? {
        set { UserDefaults.standard.set(newValue, forKey: kTempKey) }
        get { return UserDefaults.standard.integer(forKey: kTempKey)}
    }
    
    var comment: String? {
        set { UserDefaults.standard.set(newValue, forKey: kCommentKey) }
        get { return UserDefaults.standard.string(forKey: kCommentKey)}
    }
    
    var description: String? {
        set { UserDefaults.standard.set(newValue, forKey: kDescriptionKey) }
        get { return UserDefaults.standard.string(forKey: kDescriptionKey)}
    }
}
