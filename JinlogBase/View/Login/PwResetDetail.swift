//
//  PasswordResetDetail.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/10.
//

import SwiftUI

struct PasswordResetDetail: View {
    
    @State var email :String = ""
    @Binding var showView: Bool
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.6),.black.opacity(0.4),.gray.opacity(0.1)]),
                           startPoint: .bottom, endPoint: .top)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing:20){
                Text("指定のメールアドレスにパスワード変更用のリンクを送付します。")
                    .padding()
                    .foregroundColor(InAppColor.strColor)
                
                TextFieldRow(fieldText: $email, iconName: "envelope.fill", iconColor: InAppColor.strColor, text: "メールアドレス")

                Button(action:{
                    //パスワード変更用のURLが入ったメールを送付
                    Task{
                        await Owner.sAuth.passwordReset(email: email)
                    }
                }){
                    ButtonLabel(message: "送信", buttonColor: InAppColor.buttonColor)
                }
                
                Button("キャンセル") {
                    showView.toggle()
                }
                .font(.title3)
                
                Spacer()
                    .frame(height:5)
            }
            .background()
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)

    }
}

struct PasswordResetDetail_Previews: PreviewProvider {

    @State static var showDialog = false

    static var previews: some View {
        PasswordResetDetail(showView: $showDialog)
    }
}
