//
//  NacionalJSONEndPoint.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation
import Alamofire

enum NacionalJSONEndPoint: ApiConfiguration {
    case link
    
    var method: HTTPMethod {
        switch self {
        case .link:
            return .get
        }
    }

    var path: String {
        switch self {
        case .link:
            return ""
        }
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders(
                [:]
            )
        }
    }
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: ApiConstants.URL.nacionalLinks)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
