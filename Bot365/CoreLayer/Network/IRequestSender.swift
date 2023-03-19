//
//  IRequestSender.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import Alamofire

struct ApiRequestConfig<Parser> where Parser: IParser {
    let endPoint: ApiConfiguration
    let parser: Parser
}

protocol IRequestSender {
    @discardableResult
    func send<Parser>(requestConfig: ApiRequestConfig<Parser>,
                      completionHandler: @escaping (Swift.Result<Parser.Model, NetworkError>) -> Void) -> DataRequest where Parser : IParser
}
