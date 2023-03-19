//
//  RootAssembly.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: serviceAssembly)
    lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
    lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
