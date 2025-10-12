//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 9/10/25.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
}


