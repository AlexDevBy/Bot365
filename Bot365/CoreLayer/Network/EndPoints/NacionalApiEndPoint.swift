//
//  NacionalApiEndPoint.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import Alamofire

enum NacionalApiEndPoint: ApiConfiguration {
    case delete
    case auth(token: String, pushToken: String, countryCode: String)
    case authIfPushDis(token: String)
    case appleAuth(String)
    case countries(ip: String?)
    case setPremium(days: String?)
    case revokeAppleToken(token: String)
    case updatePushToken(pushToken: String, countryCode: String)
    
    var method: HTTPMethod {
        switch self {
        case .auth, .countries, .setPremium, .appleAuth, .revokeAppleToken, .authIfPushDis, .updatePushToken, .delete:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .appleAuth:
            return "/api/appleAuthorization"
        case .authIfPushDis:
            return "/api/authorization"
        case .delete:
            return "/api/profile/deleteAccount"
        case .countries:
            return "/api/country"
        case .setPremium:
            return "/api/profile/setPremium"
        case .revokeAppleToken:
            return "/api/revokeToken"
        case .updatePushToken, .auth:
            return "/api/profile/pushToken"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .revokeAppleToken(let token):
            return [ApiConstants.APIParameterKey.revoke: token]
        case .auth(let token, let pushToken, let countryCode):
            return [ApiConstants.APIParameterKey.appleId: token, ApiConstants.APIParameterKey.pushToken: pushToken,ApiConstants.APIParameterKey.countryCode: countryCode]
        case .authIfPushDis(let token):
            return [ApiConstants.APIParameterKey.appleId: token]
        case .appleAuth(let code):
            return [ApiConstants.APIParameterKey.ident: code]
        case .countries(let ip):
            if let ip = ip {
                return [ApiConstants.APIParameterKey.ip: ip]
            }
            return nil
        case .updatePushToken(let pushToken, let countryCode):
            return [ApiConstants.APIParameterKey.pushToken: pushToken, ApiConstants.APIParameterKey.countryCode: countryCode]
        default:
            return nil
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
        let urlComp = NSURLComponents(string: ApiConstants.URL.mainURL.appending(path).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        var items = [URLQueryItem]()
        // Параметры в урле
        switch self {
        case .auth, .countries, .appleAuth, .authIfPushDis, .revokeAppleToken:
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let value = value as? String {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
        case .updatePushToken:
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let value = value as? String {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
            if let token = SecureStorage.shared.getToken() {
                items.append(URLQueryItem(name: ApiConstants.APIParameterKey.token, value: token))
            }
        default:
            if let token = SecureStorage.shared.getToken() {
                items.append(URLQueryItem(name: ApiConstants.APIParameterKey.token, value: token))
            }
        }
        urlComp.queryItems = items
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
