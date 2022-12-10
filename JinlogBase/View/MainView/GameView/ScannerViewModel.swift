//
//  ScannerViewModel.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/11/24.
//

import Foundation

class ScannerViewModel: ObservableObject {

    /// QRコードを読み取る時間間隔
    // ★（参考：変更しなくてOK！）
    // ★scanIntervalSec のように、単位をいれる方法もあります！
    let scanInterval: Double = 1.0
    // ★（参考：変更しなくてOK！）
    // ★lastScanedQrCode のように、より精度の高い文言にする考え方もあります！
    @Published var lastQrCode: String = "QRコード"
    @Published var isShowing: Bool = false

    /// QRコード読み取り時に実行される。
    /// 引数のアンダースコア　引数ラベルの省略
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        // ★（参考：変更しなくてOK！）
        // ★呼び元がこのViewを非表示にすべきという考え方もあります！
        // ★「誰が主導権を持っているか」という考え方です！
        isShowing = false
    }
}
