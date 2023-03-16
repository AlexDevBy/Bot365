//
//  NetworkService.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 26.11.2022.
//

import Foundation

protocol INetworkService {
    func searchSportObjects(lat: Double, long: Double, categoriesParams: [String], completion: @escaping (Result<[SportObjectListModel], NetworkError>) -> Void)
    func makeAuth(code: String, completion: @escaping(Result<AuthModel, NetworkError>) -> Void)
    func makeAuth(token: String, completion: @escaping(Result<String, NetworkError>) -> Void)
    func sendPushToken(token: String)
    func getCountry(ip: String?, completion: @escaping (Result<AppWayByCountry, NetworkError>) -> Void)
    func addPremium(completion: @escaping (Result<(Bool, String), NetworkError>) -> Void)
    func loadLink(completion: @escaping(Result<String, NetworkError>) -> Void)
    func revokeAppleToken(token: String, completion: @escaping(Result<(Bool, String), NetworkError>) -> Void)
    func deleteProfile(completion: @escaping(Result<(Bool, String), NetworkError>) -> Void)
}

class NetworkService: INetworkService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func searchSportObjects(lat: Double, long: Double, categoriesParams: [String], completion: @escaping (Result<[SportObjectListModel], NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.search(lon: long, lat: lat, categories: categoriesParams), completionHandler: completion)
    }
    func deleteProfile(completion: @escaping(Result<(Bool, String), NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.deleteProfile(), completionHandler: completion)
    }
    func makeAuth(code: String, completion: @escaping(Result<AuthModel, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.auth(code: code), completionHandler: completion)
    }
    func addPremium(completion: @escaping (Result<(Bool, String), NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.setPremium(), completionHandler: completion)
    }
    func makeAuth(token: String, completion: @escaping(Result<String, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.auth(token: token), completionHandler: completion)
    }
    func loadLink(completion: @escaping(Result<String, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.loadLink(), completionHandler: completion)
    }
    func revokeAppleToken(token: String, completion: @escaping(Result<(Bool, String), NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.revokeAppleToken(token: token), completionHandler: completion)
    }
    func getCountry(ip: String?, completion: @escaping (Result<AppWayByCountry, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.getCountris(ip:ip), completionHandler: completion)
    }
    func sendPushToken(token: String) {
        requestSender.send(requestConfig: ConfigFactory.savePushToken(token: token)) { _ in }
    }
}
