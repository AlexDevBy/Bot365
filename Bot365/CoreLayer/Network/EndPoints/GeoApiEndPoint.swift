//
//  EndPoint.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 26.11.2022.
//

import Foundation
import Alamofire

protocol ApiConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
}

enum GeoApiEndPoint: ApiConfiguration {
    
    private enum Constants {
        static let GeoApifyKey = "67f0ebfa5ad1461ca196f3ecec3c1a2b"
    }
    case search(lat: Double, long: Double, categories: String)
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v2/places"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let lat, let long, let category):
            return [
                "filter": "circle:\(long),\(lat),30000",
                "categories": category
            ]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .search:
            return [HTTPHeader.accept("application/json")]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlComp = NSURLComponents(string: ApiConstants.URL.geoapify.appending(path).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        var items = [URLQueryItem]()
        // Параметры в урле
        switch self {
        case .search:
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let value = value as? String {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
            items.append(URLQueryItem(name: ApiConstants.APIParameterKey.apiKey, value: Constants.GeoApifyKey))
        }
        urlComp.queryItems = items
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
