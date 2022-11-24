//
//  ScannerViewModel.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/11/24.
//

import Foundation

class ScannerViewModel: ObservableObject {

    /// QRコードを読み取る時間間隔
    let scanInterval: Double = 1.0
    @Published var lastQrCode: String = "QRコード"
    @Published var isShowing: Bool = false

    /// QRコード読み取り時に実行される。
    /// 引数のアンダースコア　引数ラベルの省略
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        isShowing = false
    }
}
