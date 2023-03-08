//
//  UserListViewModel.swift
//  MVVM
//
//  Created by Zyko on 2023/3/8.
//

import Foundation

struct UserListViewModel {
    var users: Observable<[UserTableViewCellViewModel]> = Observable([])
}

struct UserTableViewCellViewModel {
    let avatar_url: String
    let login: String
    let site_admin: Bool
}
