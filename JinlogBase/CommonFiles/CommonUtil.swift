//
//  CommonUtil.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/06.
//

import Foundation
import UIKit
// Firebaseをimportしない！！

/// print()出力の先頭にファイル名と行数を挿入
public func print(_ items: String...,
                  filePath: String = #file, line: Int = #line,
                  separator: String = " ", terminator: String = "\n") {
    let timeStamp = CommonUtil.birthStr(type: .yyyyMMddHHmmssSSS)
    let fileName = URL(fileURLWithPath: filePath).lastPathComponent

    let header = "\(timeStamp) \(fileName)(\(line))  "
    let content = items.map { "\($0)" }.joined(separator: separator)

    Swift.print(header+content, terminator: terminator)
}


enum DateStrType {
    case yyyyMMddHHmmssSSS
    case yyyyMMdd
    case MMdd
    case yyyyMd
    case Md
}

/// アプリ全体で使える便利機能をまとめたクラス
final class CommonUtil {
    // いずれもインスタンス生成不要で使える(class funcとする)こと！

    /// 指定された日付を指定されたフォーマットの文字列で返す
    /// - Parameter date: 日付
    /// - Parameter type: フォーマット
    /// - Returns: フォーマットされた日付の文字列
    class func birthStr(date: Date = Date(), type: DateStrType) -> String {
        var retStr = ""
        let formatter = DateFormatter()

        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        switch type {
        case .yyyyMMddHHmmssSSS:
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"     // 2022/12/31 23:59:59.999
        case .yyyyMMdd:
            formatter.dateFormat = "yyyy'/'MM'/'dd"     // 2000/01/01
        case .MMdd:
            formatter.dateFormat = "MM'/'dd"            // 01/01
        case .yyyyMd:
            formatter.dateFormat = "yyyy'年'M'月'd'日'" // 2000年1月1日
        case .Md:
            formatter.dateFormat = "M'月'd'日'"         // 1月1日
        }

        retStr = formatter.string(from: date)
        return retStr
    }

}
