//
//  UserSettingManager.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/06.
//

import Foundation

struct KnownUser: Codable {
    var userId: String = ""
    var favorite: Bool = false
    var block: Bool = false
}

struct Setting: Codable {
    var allowComment: Bool = false
    var allowMessage: Bool = false
    var knownUsers: [KnownUser] = []
}

class UserSetting: ObservableObject {
    private(set) var userId: String = ""
    @Published private(set) var setting :Setting = Setting()

    ///
    func createSetting(uId: String) async -> Int{
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        userId = uId
        setting = Setting()

        let res = await saveSetting()
        if res != 0 {
            print("Error : saveSetting()")
            userId = ""
            return ret
        }

        ret = 0
        return ret
    }

    ///
    func setAllowComment(allow: Bool) {
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }
        setting.allowComment = allow
    }

    ///
    func setAllowMessage(allow: Bool) {
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }
        setting.allowMessage = allow
    }

    ///
    func getKnownUserIds() -> [String] {
        let userIdArray = setting.knownUsers.map { $0.userId }
        return userIdArray
    }

    ///
    func addKnownUser(uId: String, favorite: Bool = false, block: Bool = false) {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return
        }
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }
        guard uId != userId else {
            print("Error : uId:\(userId) is myself")
            return
        }
        guard (favorite == false || block == false) else {
            print("Error : Both flag:favorite/block are true")
            return
        }

        if setting.knownUsers.contains(where: {$0.userId == uId}) {
            print("Caution : uId:\(userId) already exists")
        } else {
            let user = KnownUser(userId: uId)
            setting.knownUsers.append(user)
        }
        setFavorite(uId: uId, flag: favorite)
        setBlock(uId: uId, flag: block)
    }

    ///
    func removeKnownUser(uId: String) {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return
        }
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }

        setting.knownUsers.removeAll(where: {$0.userId == uId})
    }

    ///
    func setFavorite(uId: String, flag: Bool) {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return
        }
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }
        guard let index = setting.knownUsers.firstIndex(where: {$0.userId == uId}) else {
            print("Error : uId:\(userId) does not exists")
            return
        }

        if(flag == true) {
            setting.knownUsers[index].block = false
        }
        setting.knownUsers[index].favorite = flag
    }

    ///
    func setBlock(uId: String, flag: Bool) {
        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return
        }
        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return
        }
        guard let index = setting.knownUsers.firstIndex(where: {$0.userId == uId}) else {
            print("Error : uId:\(userId) does not exists")
            return
        }

        if(flag == true) {
            setting.knownUsers[index].favorite = false
        }
        setting.knownUsers[index].block = flag
    }

    /// 設定を保存する
    /// - Returns: 成功／失敗
    func saveSetting() async -> Int {
        var ret: Int = -1
        let settingStore = SettingStore()

        guard !(userId.isEmpty) else {
            print("Error : userId is empty")
            return ret
        }

        let res = await settingStore.storeSetting(uId: userId, setting: setting)
        guard res == 0 else {
            print("Error : storeSetting(uId:\(userId))")
            return ret
        }

        ret = 0
        return ret
    }

    /// 設定を読み込む
    @MainActor
    func loadSetting(uId: String) async -> Int {
        var ret: Int = -1
        let settingStore = SettingStore()

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        setting = Setting()

        let res = await settingStore.loadSetting(uId: uId)
        guard res != nil else {
            print("Error : loadSetting(uId:\(uId))")
            return ret
        }
        userId = uId
        setting = res!

        ret = 0
        return ret
    }
}
