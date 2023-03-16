//
//  CalendarModel.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

struct SportEvent {
    let identifier: String
    let date: Date
    let sportObject: SportObject
}

struct SportObject {
    let type: SportType
    let name: String
    let address: String
}

enum SportType: String {
    case football
    case basketball
    case volley
    case running
    case yoga
    case gymnastics
    case fitDance
    case swimming
    case pingPong
    case martialsArt
    case athletics
    case ski
    case adds
    
    var smallImage: String {
        switch self {
        case .football:
            return "CFutsal"
        case .basketball:
            return "CBasket"
        case .volley:
            return "Cvolei"
        case .running:
            return "CCorrida"
        case .yoga:
            return "CYoga"
        case .gymnastics:
            return "CGinastica"
        case .fitDance:
            return "CFitDance"
        case .swimming:
            return "CSwimming"
        case .pingPong:
            return "CPingPong"
        case .martialsArt:
            return "CArtesMarciais"
        case .athletics:
            return "CCalistenia"
        case .ski:
            return "CSki"
        case .adds:
            return ""
        }
    }
    
    var bigImage: String {
        switch self {
        case .football:
            return "BigStadium"
        case .basketball:
            return "BigStadium"
        case .volley:
            return "BigStadium"
        case .running:
            return "BigRunning"
        case .yoga:
            return "BigYoga"
        case .gymnastics:
            return "BigYoga"
        case .fitDance:
            return "BigYoga"
        case .swimming:
            return "BigSwimming"
        case .pingPong:
            return "BigTennis"
        case .martialsArt:
            return "BigTennis"
        case .athletics:
            return "BigTennis"
        case .ski:
            return "BigSki"
        case .adds:
            return ""
        }
    }
    
    var longImage: String {
        switch self {
        case .football:
            return "LongFootball"
        case .basketball:
            return "LongBasketball"
        case .volley:
            return "LongVolei"
        case .running:
            return "LongRunning"
        case .yoga:
            return "LongYoga"
        case .gymnastics:
            return "LongGinastica"
        case .fitDance:
            return "LongFitDance"
        case .swimming:
            return "LongSwimming"
        case .pingPong:
            return "LongPingPong"
        case .martialsArt:
            return "LongJudô"
        case .athletics:
            return "LongAthletics"
        case .ski:
            return "LongSki"
        case .adds:
            return "AddLong"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .football, .basketball, .volley:
            return UIColor(netHex: 0x5B9B5D)
        case .running:
            return UIColor(netHex: 0x9B5B5B)
        case .yoga, .fitDance, .gymnastics:
            return UIColor(netHex: 0x9B5B8D)
        case .swimming:
            return UIColor(netHex: 0x5B689B)
        case .pingPong, .martialsArt, .athletics:
            return UIColor(netHex: 0x5B9B97)
        case .ski:
            return UIColor(netHex: 0x929292)
        case .adds:
            return .white
        }
    }
    
    var sportObjectListImage: String {
        switch self {
        case .football, .basketball, .volley:
            return "Stadium"
        case .running:
            return "RunGirl"
        case .yoga, .fitDance, .gymnastics:
            return "SitGirl"
        case .swimming:
            return "SwimMan"
        case .pingPong, .martialsArt, .athletics:
            return "Table"
        case .ski:
            return "SkiObject"
        case .adds:
            return ""
        }
    }
    
    var availableFor: [SportType] {
        switch self {
        case .football, .basketball, .volley:
            return [.football, .volley, .basketball]
        case .running:
            return [.running]
        case .yoga, .gymnastics, .fitDance:
            return [.yoga, .gymnastics, .fitDance]
        case .swimming:
            return [.swimming]
        case .pingPong, .martialsArt, .athletics:
            return [.pingPong, .martialsArt, .athletics]
        case .ski:
            return [.ski]
        case .adds:
            return []
        }
    }
    
    var networkParameter: [String] {
        switch self {
        case .football:
            return ["sport.stadium", "activity.sport_club", "sport.sports_centre"]
        case .basketball:
            return ["sport.stadium", "activity.sport_club", "sport.sports_centre"]
        case .volley:
            return ["sport.stadium", "activity.sport_club", "sport.sports_centre"]
        case .running:
            return ["commercial.outdoor_and_sport", "sport.stadium"]
        case .yoga, .gymnastics, .fitDance:
            return ["sport.fitness", "sport.fitness.fitness_centre", "activity.sport_club", "sport.sports_centre"]
        case .swimming:
            return ["commercial.houseware_and_hardware.swimming_pool", "sport.swimming_pool"]
        case .pingPong, .martialsArt, .athletics:
            return ["activity.sport_club", "sport.sports_centre"]
        case .ski:
            return ["commercial.outdoor_and_sport.ski", "sport.ice_rink"]
        case .adds:
            return [""]
        }
    }
}
