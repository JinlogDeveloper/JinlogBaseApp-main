//
//  UserProfileManager.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/29.
//

import Foundation
import UIKit

/// ***
/// プロフィール定義
// 型定義だけなので構造体とする
struct Profile: Codable {
    var userName: String = ""            /// ユーザ名(プレイヤー名)
    var birthday: Date                   /// 生年月日
    var sex = Sex.unselected             /// 性別
    var area = Areas.unselected          /// 地域
    var belong: String = ""              /// 所属
    var introMessage: String = ""        /// 自己紹介
    var visibleBirthday: Bool = false    /// 生年月日を公開

    init () {
        birthday = Calendar(identifier: .gregorian)
            .date(from: DateComponents(year: 2000, month: 1, day: 1))!
    }
    
    /// プロフィールを標準出力する
    func printProfile() {
        print("userName        : \(userName)")
        print("birthday        : \(birthday)")
        print("sex             : \(sex)")
        print("area            : \(area)")
        print("belong          : \(belong)")
        print("introMessage    : \(introMessage)")
        print("visibleBirthday : \(visibleBirthday)")
    }
    
}

/// ***
/// 特定ユーザのプロフィール
/// 
class UserProfile: ObservableObject {

    private(set) var userId: String = ""
    @Published private(set) var profile = Profile()
    @Published private(set) var image = UIImage()

    let imageSize: CGFloat = 512

    // 本クラスに持たせるか持たせないかは悩みどころ。
    private let profStore = ProfileStore()
    private let profStorage = ProfileStrage()

    /// プロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    ///   - image: 保存するプロフィール画像
    @MainActor
    func saveProfile(uId: String, prof: Profile, img: UIImage) async throws {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }

        try await saveProfile(uId: uId, prof: prof)
        try await saveProfile(uId: uId, img: img)
    }

    /// プロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    @MainActor
    func saveProfile(uId: String, prof: Profile) async throws {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(prof.userName.isEmpty) else {
            print("Error : userName is empty")
            throw JinlogError.argumentEmpty
        }

        try await profStore.storeProfile(uId: uId, prof: prof)

        userId = uId
        profile = prof
    }

    /// プロフィール画像を保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - img: 保存するプロフィール画像
    @MainActor
    func saveProfile(uId: String, img: UIImage) async throws {
        var res: Int

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        let squareImage: UIImage? = img.trimCenterSquare(length: imageSize)
        guard squareImage != nil else {
            throw JinlogError.unexpected
        }

        res = await profStorage.saveProfileImage(uId: uId, image: squareImage!)
        guard res == 0 else {
            print("Error : saveProfileImage()")
            throw JinlogError.unexpected
        }

        userId = uId
        image = squareImage!
    }

    /// プロフィールを読み込む
    @MainActor
    func loadProfile(uId: String) async throws {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        userId = uId
        profile = Profile()
        image = UIImage()

        let bufProfile: Profile = try await profStore.loadProfile(uId: userId)
        profile = bufProfile

        let bufImage: UIImage = try await profStorage.loadProfileImage(uId: userId)
        image = bufImage
    }

} // UserProfile
