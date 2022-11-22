//
//  LoginView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/20.
//

import SwiftUI



extension AnyTransition {
    ///下からスライド表示するアニメーション
    static var bottomUp: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom))
    }
}


struct LoginView: View {
    
    @Binding var moveToTopView: Bool                //アプリトップ画面への遷移条件フラグ
    @State var emailAddress :String = ""            //メールアドレス用、view側のTextFieldと連携
    @State var password :String = ""                //パスワード用、view側のTextFieldと連携
    @State var moveToCreateAccountView = false      //新規アカウント作成画面への遷移条件フラグ
    @State var moveToResetPassView = false          //パスワードリセット画面への遷移条件フラグ

    
    var body: some View {
        NavigationView{
            
            ZStack{
                // 背景色　ダークモード対応のため色はAssetsに登録
                LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topTrailing, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                // 新規アカウント画面への遷移
                NavigationLink(destination: NewAccountView(),
                               isActive: $moveToCreateAccountView){
                    EmptyView()
                }
                
                VStack{
                    Spacer()
                    
                    // タイトル部分
                    Text("JINLOG")
                        .padding()
                        .foregroundColor(InAppColor.strColor)
                        .font(.system(size: 80, weight: .thin))
                    
                    Spacer()
                    
                    VStack(spacing: 15.0){
                        //メール & パスワード入力フォーム
                        TextFieldRow(fieldText: $emailAddress, iconName: "person", iconColor: InAppColor.buttonColor, text: "Email")
                        SecureFieldRow(fieldText: $password, iconName: "lock", iconColor: InAppColor.buttonColor, text: "Password")
                        
                        Spacer().frame(height: 15)
                        
                        //ログインボタン
                        Button(action: {
                            Task {
                                do {
                                    // ログイン
                                    let _ = try await Owner.sAuth.signIn(
                                        email: emailAddress,
                                        password: password
                                    )
                                    print("ログイン成功")

                                    //ログイン成功時にテキストフィールドの値は削除
                                    emailAddress = ""
                                    password = ""
                                    //トップ画面へ遷移させる
                                    ReturnViewFrags.returnToLoginView.wrappedValue.toggle()

                                } catch {
                                    print("ERROR : ログイン失敗")
                                    //TODO: アラート
                                }
                            }
                        }) {
                            ButtonLabel(message: "ログイン", buttonColor: InAppColor.buttonColor)
                        }
                    }
                    
                    //新規アカウント作成ボタン
                    Button(action: {
                        //アカウント登録画面へ移動
                        moveToCreateAccountView = true
                    }) {
                        ButtonLabel(message: "アカウント作成", buttonColor: InAppColor.buttonColor2)
                    }

                    Spacer().frame(height: 5)

                    //パスワード変更時の処理
                    Button(action: {
                        //下からのスライドアニメーションを付与
                        withAnimation(.easeInOut(duration: 0.5)){
                            moveToResetPassView.toggle()
                        }
                    }) {
                        Text("パスワードを忘れた場合")
                            .foregroundColor(InAppColor.strColor)
                            .underline()
                    }
                    
                    Spacer()
                    
                }//VStack
                //キーボードによる画面圧迫を防止
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                //パスワード変更用の画面
                if moveToResetPassView {
                    PasswordResetDetail(showView: $moveToResetPassView)
                        .transition(.bottomUp)
                }
            } //Zstack
            .navigationBarHidden(true)
        } //NavigationView
        .onAppear(){
            //トップ画面遷移のフラグを紐付け
            ReturnViewFrags.returnToLoginView = $moveToTopView

            if Owner.sAuth.isSignIn {
                //トップ画面へ遷移させる
                ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    @State static var moveView = false
    
    static var previews: some View {
        LoginView(moveToTopView: $moveView)
    }
}
