//
//  JinlogError.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/08/26.
//

import Foundation

enum JinlogError: LocalizedError {
    // 一般的なエラー
    case unexpected
    case argument
    case argumentRange
    case argumentEmpty
    case networkServer
    // Jinlogなエラー
    case noProfileInDB

    var errorDescription: String? {
        switch self {
        case .unexpected:
            return "予期せぬエラーが発生しました"
        case .argument:
            return "引数が異常です"
        case .argumentRange:
            return "引数の範囲が異常です"
        case .argumentEmpty:
            return "引数の内容が空です"
        case .networkServer:
            return "ネットワークまたはサーバが異常です"
        case .noProfileInDB:
            return "データベースにプロフィールがありません"
        }
    }

    var failureReason: String? {
        return ""
    }

    var recoverySuggestion: String? {
        return ""
    }

    var helpAnchor: String? {
        return ""
    }

}
