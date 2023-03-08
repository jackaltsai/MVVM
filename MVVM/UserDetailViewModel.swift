//
//  UserDetailViewModel.swift
//  MVVM
//
//  Created by Zyko on 2023/3/9.
//

import Foundation

struct UserDetailViewModel {
    var user: Observable<UserClientViewModel> = Observable()
}

struct UserClientViewModel {
    let avatar_url: String
    let name: String?
    let bio: String?
    let login: String
    let site_admin: Bool
    let location: String?
    let blog: String?
}
