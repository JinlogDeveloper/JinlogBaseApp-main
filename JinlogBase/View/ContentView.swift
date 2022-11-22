//
//  ContentView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/04.
//

import SwiftUI


/// ログイン画面の表示部
struct ContentView: View {
    @State var moveToMainView = false                //アプリトップ画面への遷移条件フラグ
    
    var body: some View {
        // Top画面で　NavigationView　の戻りボタン、上部空白部が出るのが嫌なのでフラグで画面切り替えに変更

        //moveToMainViewに対する何かしらの処理をしないと描画が更新されないため
        if moveToMainView {}

        if Owner.sAuth.isSignIn {
            if Owner.sProfile.profile.userName.isEmpty {
                let _ = print("DEBUG : 初期プロフィール登録画面")
                NewProfileView(moveToTopView: $moveToMainView)
            } else { 
                let _ = print("DEBUG : メイン画面")
                TopView()
            }
        } else {
            let _ = print("DEBUG : ログイン画面")
            LoginView(moveToTopView: $moveToMainView)
        }
    }
}


//複数デバイスで開発するためにプレビューに代表的な３代
struct TopContentView_Previews: PreviewProvider {
    static var devices = ["iPhone SE (3nd generation)",
                            "iPhone 13",
                            "iPad Pro (12.9-inch) (5th generation)"]
    
    static var previews: some View {
        
        ContentView()
        
//        Group {
//            ForEach(devices,id: \.self) {deviceName in
//                LoginView()
//                    .previewDevice(PreviewDevice(rawValue: deviceName))
//                    .previewDisplayName(deviceName)
//            }
//        }
    }
}
