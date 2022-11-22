//
//  JinlogStorage.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/07/06.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

// Storageルート配下のフォルダ名
enum rootReference: String {
    case profiles = "profiles"
}

/// プロフィール用のStorageに直接アクセスする処理を集めたクラス
final class ProfileStrage {
    
    private let sMaxDataSize: Int64 = 10 * 1024 * 1024
    private let storage: StorageReference

    init() {
        storage = Storage.storage().reference(withPath: rootReference.profiles.rawValue)
    }

    /// ストレージにプロフィール画像を保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィール画像のユーザID
    ///   - image: 保存するプロフィール画像
    /// - Returns: 成功0／失敗-1
    func saveProfileImage(uId: String, image: UIImage) async -> Int {
        var ret: Int = -1
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }
        guard let pngData = image.pngData() else {
            print("Error : could not convert to PNG")
            return ret
        }
        let ref: StorageReference = storage.child("\(uId).png")

        do {
            try await ref.putDataAsync(pngData, metadata: metaData)
        } catch {
            print("Error : ", error.localizedDescription)
            //TODO:
            return ret
        }
        
        ret = 0
        return ret
    }

    /// ストレージからプロフィール画像を読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID
    /// - Returns: UIImage: プロフィール画像
    func loadProfileImage(uId: String) async throws -> UIImage {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }
        let ref: StorageReference = storage.child("\(uId).png")
        
        do {
            let res = try await ref.data(maxSize: sMaxDataSize)
            guard let retImage = UIImage(data: res) else {
                print("Error : UIImage()")
                throw JinlogError.unexpected
            }
            print("imageDataSize   : \(res.count)[byte]")
            return retImage
        } catch {
            print("Error : ", error.localizedDescription)
            let errCode = StorageErrorCode(rawValue: error._code)
            switch errCode {
            //case .〜〜〜
                //TODO: 画像がない時のエラーを検出させる
                //print("Error : Image  not found")
                //throw JinlogError.networkServer
            //case .〜〜〜
                //TODO: ネットワークエラーを検出させる
                //print("Error : network or server error")
                //throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }

}
