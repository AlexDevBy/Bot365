//
//  CalendarModel.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
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
            return "footballCard"
        case .basketball:
            return "basketballCard"
        case .volley:
            return "volleyCard"
        case .running:
            return "runningCard"
        case .yoga:
            return "yogaCard"
        case .gymnastics:
            return "gymnasticsCard"
        case .fitDance:
            return "fitDanceCard"
        case .swimming:
            return "swimmingCard"
        case .pingPong:
            return "pingpongCard"
        case .martialsArt:
            return "martialCard"
        case .athletics:
            return "athleticsCard"
        case .ski:
            return "skiCard"
        case .adds:
            return ""
        }
    }
    
    var bigImage: String {
        switch self {
        case .football:
            return "footballBig"
        case .basketball:
            return "basketBig"
        case .volley:
            return "volleyBig"
        case .running:
            return "runningBig"
        case .yoga:
            return "yogaBig"
        case .gymnastics:
            return "gymnasticsBig"
        case .fitDance:
            return "fitDanceBig"
        case .swimming:
            return "swimmingBig"
        case .pingPong:
            return "pingpongBig"
        case .martialsArt:
            return "martialBig"
        case .athletics:
            return "athleticsBig"
        case .ski:
            return "skiBig"
        case .adds:
            return ""
        }
    }
    
    var longImage: String {
        switch self {
        case .football:
            return "footballLong"
        case .basketball:
            return "basketLong"
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
            return "addMain"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .football:
            return UIColor(netHex: 0x214929)
        case .basketball:
            return UIColor(netHex: 0x944E1C)
        case .volley:
            return UIColor(netHex: 0xD0AD31)
        case .running:
            return UIColor(netHex: 0xD7423A)
        case .yoga:
            return UIColor(netHex: 0xFF7CA6)
        case .gymnastics:
            return UIColor(netHex: 0x638673)
        case .fitDance:
            return UIColor(netHex: 0xD93F77)
        case .swimming:
            return UIColor(netHex: 0x5B689B)
        case .pingPong:
            return UIColor(netHex: 0x0D276A)
        case .martialsArt:
            return UIColor(netHex: 0x6C2424)
        case .athletics:
            return UIColor(netHex: 0x77672D)
        case .ski:
            return UIColor(netHex: 0x2E2E2E)
        case .adds:
            return .white
        }
    }
    
    var backgroundColor2: UIColor {
        switch self {
        case .football:
            return UIColor(netHex: 0x091F07)
        case .basketball:
            return UIColor(netHex: 0xC36725)
        case .volley:
            return UIColor(netHex: 0xEAC234)
        case .running:
            return UIColor(netHex: 0x932722)
        case .yoga:
            return UIColor(netHex: 0xEC8FC7)
        case .gymnastics:
            return UIColor(netHex: 0x1F1F1F)
        case .fitDance:
            return UIColor(netHex: 0xD85E91)
        case .swimming:
            return UIColor(netHex: 0x45757C)
        case .pingPong:
            return UIColor(netHex: 0x425781)
        case .martialsArt:
            return UIColor(netHex: 0x8F3030)
        case .athletics:
            return UIColor(netHex: 0x1F1F1F)
        case .ski:
            return UIColor(netHex: 0x767676)
        case .adds:
            return .white
        }
    }
    
    var sportObjectListImage: String {
        switch self {
        case .football:
            return "footballArena"
        case .basketball:
            return "basketArena"
        case .volley:
            return "volleyArena"
        case .running:
            return "runningArena"
        case .yoga:
            return "yogaArena"
        case .gymnastics:
            return "gymnasticsArena"
        case .fitDance:
            return "fitDanceArena"
        case .swimming:
            return "swimmingArena"
        case .pingPong:
            return "pingpongArena"
        case .athletics:
            return "athleticsArena"
        case .martialsArt:
            return "martialArena"
        case .ski:
            return "skiArena"
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
    
    var title: String {
        switch self {
        case .football:
            return "Football"
        case .basketball:
            return "Basketball"
        case .volley:
            return "Volley"
        case .running:
            return "Running"
        case .yoga:
            return "Yoga"
        case .gymnastics:
            return "Gymnastics"
        case .fitDance:
            return "Fit Dance"
        case .swimming:
            return "Swimming"
        case .pingPong:
            return "Ping Pong"
        case .martialsArt:
            return "Martial Art"
        case .athletics:
            return "Athletics"
        case .ski:
            return "Ski"
        case .adds:
            return ""
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
