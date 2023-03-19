//
//  AuthModel.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

struct AuthModel {
    let refreshToken: String
    let accessToken: String
    let idToken: String
    let expiresIn: String
    let tokenType: String
}
