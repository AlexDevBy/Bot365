//
//  CoreAssembly.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

protocol ICoreAssembly {
    var storage: IStorageManager { get }
    var requestSender: IRequestSender { get }
    var secureStorage: ISecureStorage { get }
    var userDefaultsSettings: IUserDefaultsSettings { get }
    var purchases: Purchases { get }
}

class CoreAssembly: ICoreAssembly {
    init() {}
    lazy var storage: IStorageManager = DatabaseStorage()
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var secureStorage: ISecureStorage = SecureStorage.shared
    lazy var userDefaultsSettings: IUserDefaultsSettings = UserDefaultsStorage.shared
    lazy var purchases: Purchases = Purchases.default
}
