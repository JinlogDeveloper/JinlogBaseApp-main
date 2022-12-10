//
//  QrCodeCameraDelegate.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/11/24.
//
import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)

    var onResult: (String) -> Void = { _  in }

    // ★なくしてOK！
    var mockData: String?

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }

    // ★なくしてOK！
    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "Simulated QR-code result.")
    }

    func foundBarcode(_ stringValue: String) {
        // ★（疑問）
        // ★この部分の処理は、QRコードが見つかっている間、超連続で呼ばれ続けてて、
        print("foundBarcode()")
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            // ★インターバル以上毎に走る処理は、文字列を反映するこの処理だけ！？
            lastTime = now
            self.onResult(stringValue)
        }
        // ★もしそうであれば、インターバル以上毎に反映するのではなく、
        // ★読み取った文字列が変更される毎に反映するようにした方がよさそう
    }
}
