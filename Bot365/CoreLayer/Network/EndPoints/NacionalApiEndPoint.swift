//
//  NacionalApiEndPoint.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation
import Alamofire

enum NacionalApiEndPoint: ApiConfiguration {
    case delete
    case auth(token: String, pushToken: String, countryCode: String)
    case appleAuth(String)
    case countries(ip: String?)
    case setPremium(days: String?)
    case revokeAppleToken(token: String)
    case updatePushToken(pushToken: String, countryCode: String)
    
    var method: HTTPMethod {
        switch self {
        case .auth, .countries, .setPremium, .appleAuth, .revokeAppleToken, .updatePushToken, .delete:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .appleAuth:
            return "/api/appleAuth"
        case .auth:
            return "/api/auth"
        case .delete:
            return "/api/profile/delete"
        case .countries:
            return "/api/getCountry"
        case .setPremium:
            return "/api/profile/premium"
        case .revokeAppleToken:
            return "/api/apauth.php"
        case .updatePushToken:
            return "/api/profile/push"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .revokeAppleToken(let token):
            return [ApiConstants.APIParameterKey.revoke: token]
        case .auth(let token, let pushToken, let countryCode):
            return [ApiConstants.APIParameterKey.appleId: token, ApiConstants.APIParameterKey.pushToken: pushToken,ApiConstants.APIParameterKey.countryCode: countryCode]
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
        case .auth, .countries, .appleAuth, .revokeAppleToken:
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
