//
//  UserDetail.swift
//  MVVM
//
//  Created by Zyko on 2023/3/8.
//

import Foundation

struct UserDetail: Codable {
    let avatar_url: String
    let name: String?
    let bio: String?
    let login: String
    let site_admin: Bool
    let location: String?
    let blog: String?
}
