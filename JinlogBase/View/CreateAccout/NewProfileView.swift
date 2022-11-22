//
//  NewProfileView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/15.
//

import SwiftUI


/// 初回ユーザー情報登録画面で使用する列挙型
///
/// 生年月日、性別、地域の項目表示に使用するデータ群
enum EditSelect: String, CaseIterable {
    case birthdayEdit = "生年月日"
    case sexEdit = "性別"
    case areaEdit = "地域"
    
    
    var iconName: String {
        switch self {
        case .birthdayEdit:     return "calendar"
        case .sexEdit:          return "person.2.circle"
        case .areaEdit:         return "globe"
        }
    }
    
    func GetSelectEdit(bufProfile: Binding<Profile>, pages: Binding<EditSelect?>) -> AnyView {
        switch self {
        case .birthdayEdit:
            return AnyView(BirthdayEdit(bufProfile: bufProfile, pages: pages))
        case .sexEdit:
            return AnyView(SexEdit(bufProfile: bufProfile, pages: pages))
        case .areaEdit:
            return AnyView(AreaEdit(bufProfile: bufProfile, pages: pages))
        }
    }
}


extension AnyTransition {
    static var scaleAndDelay: AnyTransition {
        .asymmetric(
            insertion: .scale.animation(Animation.spring().delay(0.2).speed(1.5))
                .combined(with: .offset(x: 0, y: -100))
                .combined(with: .opacity),
            removal: AnyTransition.scale.combined(with: .opacity))
    }
}



struct NewProfileView: View {
    
    /*-----------------------------------
     新規アカウント登録の２画面目
     ・FireStore、Storageに必要な内容を登録する
     ・アカウント画像もここで登録する
     -----------------------------------*/
    
    @Binding var moveToTopView :Bool            //Top画面への遷移フラグ(前画面から引き継ぎ)
    @State var bufProfile = Profile()            //入力するプロフィール情報の格納(前画面から引き継ぎ)
    @State var alertFlag = false                //アラート画面の表示条件
    @State var showLoading = false              //ローディングアイコンの表示条件
    @State var pages: EditSelect? = nil         //編集中の項目の記憶、必要情報の取り出しに使用する列挙型
    
    //dismissは現在の画面を閉じるときに使用する
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            //背景色
            LinearGradient(gradient: Gradient(colors: [.gray, .white]),
                           startPoint: pages == nil ? .topTrailing : .topLeading,
                           endPoint: pages == nil ? .bottomLeading : .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
                        
            VStack{
                
                Spacer().frame(height: 10)
                
                //タイトル　＆　メッセージ
                VStack {
                    Text("ユーザー情報")
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(InAppColor.strColor)
//                    Text("あと少しで完了です!")
                    Text("アカウント作成を完了するために\nユーザー情報を入力してください。")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                    
                    Divider().padding(.bottom, 5)
                }
                
                //入力項目の表示部
//                ScrollView {
                    
                    //プレーヤー名だけは TextField になるので独立して記述
                    if pages == nil {
                        TextFieldRow(fieldText: $bufProfile.userName, iconName: "person",
                                     iconColor: InAppColor.strColor, text: "プレーヤー名")
                        .transition(AnyTransition.move(edge: .leading))
                    }
                    
                    //生年月日、性別、地域の項目表示
                    ForEach(EditSelect.allCases, id: \.self) { page in
                        VStack {
                            //項目行自体をボタン化し、選択時に表示切り替え
                            if pages == page || pages == nil {
                                Button {
                                    withAnimation(){
                                        pages = pages != page ? page : nil
                                    }
                                } label: {
                                    ProfileRow(bufProfile: bufProfile,
                                               showEdit: pages == page ? true : false,
                                               page: page)
                                }
                                .transition(AnyTransition.move(edge: .leading))
                                .zIndex(1)
                                
                                //設定画面の表示切り替え
                                if let p = pages {
                                    if p == page {
                                        p.GetSelectEdit(bufProfile: $bufProfile, pages: $pages)
                                            .transition(.scaleAndDelay)
                                    }
                                }
                            }
                        }
                    }
                    
                    if pages == nil {
                        Text("※設定内容はプロフィール編集よりいつでも変更できます")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .frame(width: UIScreen.main.bounds.width - 60, height: 45)
                    
//              }//ScrollView

                Spacer()
                
                Button(action: {
                    //ローディングアイコン表示開始
                    showLoading = true

                    Task {
                        do {
                            try await Owner.sProfile.saveProfile(
                                uId: Owner.sAuth.uid,
                                prof: bufProfile
                            )
                        } catch {
                            print("ERROR : プロフィール登録失敗")
                            //TODO: アラート
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        //ローディングアイコン停止
                        showLoading = false
                        //トップ画面へ一気に遷移する
                        ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
                    }
                }){
                    ButtonLabel(message: "登録", buttonColor: InAppColor.buttonColor)
                        .overlay() {
                            if showLoading {
                                ProgressView()
                                    .offset(x: -35)
                                    .scaleEffect(x: 1.3, y: 1.3, anchor: .center)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                        }
                }
                    }
                else{Spacer()}
                    
                
                Spacer().frame(height: 50)
                
            }//VStack
            //キーボード表示したときの画面圧迫状態を回避
            .ignoresSafeArea(.keyboard, edges: .bottom)
        } //Zstack
        //NavigationViewで画面上部に無駄なスペースができるので削除,Backボタンも非表示
        .navigationBarHidden(true)
        .task {
            //トップ画面遷移のフラグを紐付け
            ReturnViewFrags.returnToLoginView = $moveToTopView

            if Owner.sAuth.isSignIn {

                do {
                    try await Owner.sProfile.loadProfile(
                        uId: Owner.sAuth.uid
                    )
                    print("プロフィール取得成功")
                } catch {
                    switch error {
                    case JinlogError.noProfileInDB:
                        print("ERROR : プロフィール取得失敗(プロフィールなし)")
                    case JinlogError.networkServer:
                        print("ERROR : プロフィール取得失敗(ネットワーク／サーバ)")
                        //TODO: アラート
                    default:
                        print("ERROR : プロフィール取得失敗")
                        //TODO: アラート
                    }
                }

                //トップ画面へ遷移させる
                ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
            }
        }
        
    } //body View
} //View


struct NewProfileView_Previews: PreviewProvider {
    
    @State static var moveToTopView :Bool = false          //Top画面への遷移フラグ
    @State static var bufProfile :Profile = Profile()      //入力するプロフィール情報の格納

    static var previews: some View {
        NewProfileView(moveToTopView: $moveToTopView)
    }
}
