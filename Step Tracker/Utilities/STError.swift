//
//  STError.swift
//  Step Tracker
//
//  Created by Jeremy Chew on 13/10/25.
//

import Foundation

enum STError: LocalizedError {
    case authNotDetermined
    case sharingDenied(quantityType: String)
    case noData
    case unableToCompleteRequest
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .authNotDetermined:
            "Need access to Health Data"
        case .sharingDenied(_):
            "No write access"
        case .noData:
            "No Data"
        case .unableToCompleteRequest:
            "Unable to complete request"
        case .invalidData:
            "Invalid Value"
        }
    }
    
    var failureReason: String {
        switch self {
        case .authNotDetermined:
            "You have not given access to Health Data. Please go to Settings > Health > Data Access & Devices"
        case .sharingDenied(quantityType: let quantityType):
            "You have denied access to \(quantityType) data. \n\nYou can change this in Settings > Health > Data Access & Devices"
        case .noData:
            "There is no data for your health statistic"
        case .unableToCompleteRequest:
            "We are unable to complete your request access at this time. /n/nPlease try again later or contact support"
        case .invalidData:
            "Must be a numeric value of a maximun of one decimal place"
        }
    }
}
