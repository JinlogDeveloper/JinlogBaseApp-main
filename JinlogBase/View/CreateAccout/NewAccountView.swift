//
//  NewAccountView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/05.
//

import SwiftUI


/// 新規アカウント登録の１画面目
///  - Note: メールアドレス、パスワードを入力
struct NewAccountView: View {
    
    @State var emailAddress :String = ""            //メールアドレス
    @State var password :String = ""                //パスワード用
    @State var alertFlag = false                    //アラート画面の表示条件
    @State var errMessage = "エラー"                      //エラーメッセージ表示用
    

    //dismissは現在の画面を閉じるときに使用する
    @Environment (\.dismiss) var dismiss
    
    
    //画面の本体部分
    var body: some View {
        
        ZStack {
            //背景
            LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer().frame(height: 20)
                
                //タイトル部分
//                Text("JINLOG")
//                    //.padding()
//                    .foregroundColor(InAppColor.strColor)
//                    .font(.system(size: 40, weight: .thin))
                VStack {
                    Text("アカウント作成")
                        .padding(30)
                        .font(.system(size: 30).bold())
                        .foregroundColor(InAppColor.strColor)
                    
                    Text("JINLOGへようこそ!\n新規登録して利用を開始しましょう。")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                    
                    Divider()
                }
                
                Spacer()

                Text(errMessage)
                    .foregroundColor(.red.opacity(0.7))
                    .hidden()

                //入力フォーム部分
                VStack(spacing: 15.0){
                    TextFieldRow(fieldText: $emailAddress, iconName: "envelope",
                                 iconColor: InAppColor.buttonColor, text: "メールアドレス")

                    SecureFieldRow(fieldText: $password, iconName: "lock",
                                   iconColor: InAppColor.buttonColor, text: "パスワード")
                    
                    Text("※パスワードは半角英数字で6文字以上入力してください")
                        .padding(.horizontal, 30)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 400)
                }
                
                Spacer()
                
                Button(action: {
                    CheckInputInfomation()
                }){
                    ButtonLabel(message: "アカウント登録", buttonColor: InAppColor.buttonColor)
                }
                .alert("いづれかのエラー\n未記入項目あり\nメールが登録済み\nエラー発生", isPresented: $alertFlag, actions: {})
                
                Button(action: {
                    dismiss()       // 1つ前の画面へ戻る
                }){
                    Text("戻る")
                        .padding()
                        .font(.title3)
                }
                
                Spacer().frame(height: 20)
            }//VStack
            //キーボード表示したときのツメツメ状態を回避
            .ignoresSafeArea(.keyboard, edges: .bottom)

        } //Zstack
        //NavigationViewで画面上部に無駄なスペースができるので削除,Backボタンも非表示
        .navigationBarHidden(true)
    }
    
    
    
    /// FirebaseAuthを検索して入力情報と重複がないか確認
    private func CheckInputInfomation() {

        if emailAddress.isEmpty {
            //メールアドレスの未入力エラー
            errMessage = "メールアドレスを入力してください。"
            alertFlag = true
            return
        }
        
        if password.count < 6 {
            //パスワードの入力エラー
            alertFlag = true
            return
        }

        Task {
            do {
                // アカウント登録
                let _ = try await Owner.sAuth.createAccount(
                    email: emailAddress,
                    password: password
                )
                print("アカウント登録成功")

                do {
                    // ログイン
                    let _ = try await Owner.sAuth.signIn(
                        email: emailAddress,
                        password: password
                    )
                    print("ログイン成功")

                } catch {
                    print("ERROR : ログイン失敗")
                    //TODO: アラート
                    errMessage = "ログイン失敗"
                    alertFlag = true

                    try! Owner.sAuth.signOut()
                }

                //トップ画面へ一気に遷移する
                ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
                
            } catch {
                print("ERROR : アカウント登録失敗")
                //TODO: アラート
                errMessage = "アカウント登録失敗"
                alertFlag = true
            }
        }
    }
} //View


struct NewAccountView_Previews: PreviewProvider {
    
    @State var emailAddress :String = ""
    @State var password :String = ""
    
    static var previews: some View {
        NewAccountView()
    }
}
