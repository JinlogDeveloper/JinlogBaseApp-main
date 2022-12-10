//
//  SecondView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/11/24.
//

import SwiftUI

// ★構造体名・クラス名は、できるだけ意味の分かる名詞にする
struct SecondView: View {
    
    // ★名前が抽象的すぎる！
    @ObservedObject var viewModel : ScannerViewModel
    
    
    var body: some View {
        Text("SecondView")
        
        // ★インデントがずれてる！
       ZStack {
            // QRコード読み取りView
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)//引数に関数
                .interval(delay: self.viewModel.scanInterval)/// QRコードを読み取る時間間隔が引数
            
           VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)
                    
                    Text("QRコード読み取り結果 = [ " + self.viewModel.lastQrCode + " ]")
                        .bold()
                        .lineLimit(5)
                        .padding()
                    
                    Button("Close") {
                        self.viewModel.isShowing = false
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }.padding()
        
       }
    }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(viewModel: ScannerViewModel())
    }
}
