//
//  RootAssembly.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: serviceAssembly)
    lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
    lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
