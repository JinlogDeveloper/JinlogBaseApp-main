//
//  ExtensionUIImage.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/08/12.
//

import Foundation
import SwiftUI

extension UIImage {

    /// 画像の短辺長さの正方形を画像中心から切り出してリサイズする
    /// - Parameter length: リサイズ長 ※0の場合リサイズしない
    /// - Returns: nil／正方形画像
    func trimCenterSquare(length: CGFloat = 0) -> UIImage? {
        var retImage: UIImage? = nil

        guard 0 <= length else {
            print("ERROR : length:\(length)")
            return retImage
        }

        // 切り出す正方形の一辺の長さ
        let squareSize: CGFloat = min(size.width, size.height)
        guard 0 < squareSize else {
            print("ERROR : length:\(squareSize)")
            return retImage
        }

        // リサイズ尺度
        let scale: CGFloat = 0 < length ? (length / squareSize) : 1

        // 描画起点
        let origin: CGPoint = size.width < size.height
            ? CGPoint(x: 0.0, y: (size.width - size.height) * scale / 2)
            : CGPoint(x: (size.height - size.width) * scale / 2, y: 0.0)

        // 目的サイズの正方形画用紙を用意
        UIGraphicsBeginImageContextWithOptions(CGSize(width: squareSize * scale, height: squareSize * scale), false, 1.0)
        // 切り出す正方形部分が、画用紙上に乗るように描画する。
        // つまり、元画像が正方形でない限り、X方向かY方向のどちらかが必ず画用紙の両外に描画される
        draw(in: CGRect(origin: origin, size: CGSize(width: size.width * scale, height: size.height * scale)))
        // 画用紙部分を取り出す
        retImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return retImage!
    }

    func createQRCode(sourceText: String) -> UIImage? {
        guard let data = sourceText.data(using: .utf8) else {
            return nil
        }

        // inputCorrectionLevel(誤り訂正レベル)： 低 ← L, M, Q, H → 高 
        guard let qr = CIFilter(
            name: "CIQRCodeGenerator", 
            parameters: ["inputMessage": data, "inputCorrectionLevel": "H"]
        ) else {
            return nil
        }
        
        let matrixSize = CGAffineTransform(scaleX: 10, y: 10)
        
        guard let ciImage = qr.outputImage?.transformed(by: matrixSize) else {
            return nil
        }
        
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        
        return image
    }
    
}
