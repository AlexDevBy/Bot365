//
//  ServiceAssembly.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import Foundation

protocol IServiceAssembly {
    var networkService: INetworkService { get }
    var userInfoService: ISensentiveInfoService { get }
    var purchasesService: IProductService { get }
    var databaseService: IDatabaseService { get }
    var deviceLocationService: IDeviceLocationService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    lazy var deviceLocationService: IDeviceLocationService = DeviceLocationService.shared
    lazy var databaseService: IDatabaseService = DatabaseService(db: coreAssembly.storage, coreDataStack: CoreDataStack.shared)
 
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var networkService: INetworkService = NetworkService(requestSender: coreAssembly.requestSender)
    lazy var purchasesService: IProductService = ProductService(purchases: coreAssembly.purchases)
    lazy var userInfoService: ISensentiveInfoService = AppInfoService(secureStorage: coreAssembly.secureStorage,
                                                                      userInfoStorage: coreAssembly.userDefaultsSettings)
}
