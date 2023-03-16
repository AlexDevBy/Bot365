//
//  NetworkError.swift
//  SuperBest
//
//  Created by Дмитрий Терехин on 06.10.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case domainError
    case decodingError
    case explicitlyCancelledError
    case responseError(String)
    case serverError(String)
    case customError(Int, String)
    case AFError(AFError)
    
    var textToDisplay: String {
        switch self {
        case .decodingError:
            return "Something went wrong in decoding files"
        case .responseError(_):
            return "Something went wrong with response"
        case .serverError(_):
            return "Something went wrong..."
        case .domainError:
            return "Domain error"
        case .customError(_, let description):
            return description
        case .AFError(let error):
            switch error {
            case .sessionTaskFailed(error: let thisError), .createUploadableFailed(error: let thisError),  .createURLRequestFailed(error: let thisError), .downloadedFileMoveFailed(error: let thisError, source: _, destination: _), .requestAdaptationFailed(error: let thisError), .requestRetryFailed(retryError: _, originalError: let thisError):
                return thisError.localizedDescription
            case .multipartEncodingFailed(reason: let reason):
                return "Ошибка состовного кодирования: \(reason)"
            case .explicitlyCancelled:
                return "Отменено"
            case .invalidURL(url: _):
                return "Invalid URL"
            case .parameterEncoderFailed(reason: let reason):
                return "Ошибка энкодера: \(reason)"
            case .parameterEncodingFailed(reason: let reason):
                return "Ошибка кодирования: \(reason)"
            case .responseSerializationFailed(reason: let reason):
                return "Ошибка сериализации ответа: \(reason)"
            case .responseValidationFailed(reason: let reason):
                return "Ошибка валидации ответа \(reason)"
            case .serverTrustEvaluationFailed(reason: let reason):
                return "Ошибка доверия сервера: \(reason)"
            case .sessionDeinitialized:
                return "Сессия уничтожена"
            case .urlRequestValidationFailed(reason: let reason):
                return "Ошибка в валидации запроса: \(reason)"
            case .sessionInvalidated(error: let thisError):
                return thisError?.localizedDescription ?? ""
            }
        case .explicitlyCancelledError:
            return ""
        }
    }
}
