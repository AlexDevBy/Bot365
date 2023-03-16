//
//  AppleApiEndPoint.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation
import Alamofire

enum AppleApiEndPoint: ApiConfiguration {
    case revokeAppleToken(clientId: String, clientSecret: String, clientToken: String)
    
    var method: HTTPMethod {
        switch self {
        case .revokeAppleToken:
            return .post
        }
    }

    var path: String {
        switch self {
        case .revokeAppleToken:
            return ""
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .revokeAppleToken(let clientId, clientSecret: let clientSecret, clientToken: let token):
            return [
                ApiConstants.APIParameterKey.clientId: clientId,
                ApiConstants.APIParameterKey.clientSecret: clientSecret,
                ApiConstants.APIParameterKey.token: token
            ]
        }
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
        var urlRequest = URLRequest(url: URL(string: ApiConstants.URL.appleURL)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        if let parameters = parameters {
            let options = JSONSerialization.WritingOptions()
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: options)
        }
        return urlRequest
    }
}
