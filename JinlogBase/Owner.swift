//
//  Owner.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/09/15.
//

import Foundation

/// アプリ使用者本人の情報
final class Owner {
    static let sAuth = FirebaseAuth()
    static let sProfile = UserProfile()
    static let sSetting = UserSetting()
}
