//
//  ConfigFactory.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

struct ConfigFactory {
    // Поиск обЪектов
    static func search(lon: Double, lat: Double, categories: [String]) -> ApiRequestConfig<SportObjectListParser> {
        let categoriesParams: String = categories.joined(separator: ",")
        return ApiRequestConfig(endPoint: GeoApiEndPoint.search(lat: lat, long: lon, categories: categoriesParams),
                                parser: SportObjectListParser())
    }
    
    static func getCountris(ip: String?) -> ApiRequestConfig<CountryParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.countries(ip: ip), parser: CountryParser())
    }
    static func setPremium() -> ApiRequestConfig<SucceedParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.setPremium(days: nil), parser: SucceedParser())
    }
    static func revokeAppleToken(token: String, secret: String, clientId: String) -> ApiRequestConfig<AppleRevokeTokenParser> {
        return ApiRequestConfig(endPoint: AppleApiEndPoint.revokeAppleToken(clientId: clientId, clientSecret: secret, clientToken: token), parser: AppleRevokeTokenParser())
    }
    static func loadLink() -> ApiRequestConfig<LinkParser> {
        return ApiRequestConfig(endPoint: NacionalJSONEndPoint.link, parser: LinkParser())
    }
    static func revokeAppleToken(token: String) -> ApiRequestConfig<SucceedParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.revokeAppleToken(token: token), parser: SucceedParser())
    }
    static func deleteProfile() -> ApiRequestConfig<SucceedParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.delete, parser: SucceedParser())
    }
    static func auth(code: String) -> ApiRequestConfig<AppleAuthParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.appleAuth(code), parser: AppleAuthParser())
    }
    static func auth(token: String) -> ApiRequestConfig<AuthParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.auth(token), parser: AuthParser())
    }
    static func savePushToken(token: String) -> ApiRequestConfig<SucceedParser> {
        return ApiRequestConfig(endPoint: NacionalApiEndPoint.updatePushToken(pushToken: token), parser: SucceedParser())
    }
}
