//
//  AuthModel.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation

struct AuthModel {
    let refreshToken: String
    let accessToken: String
    let idToken: String
    let expiresIn: String
    let tokenType: String
}
