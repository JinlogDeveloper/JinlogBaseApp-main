//
//  UserInfoView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/08.
//

import SwiftUI

struct UserInfoView: View {
    
    
    @State var bufProfile: Profile
    
    var body: some View {
        
        HStack{
            ZStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 50, height: 50)
                    .padding(.all, 15.0)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.secondary, lineWidth: 3))
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background()
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .offset(x: 27, y: 30)
            }
            .padding(.all, 5)
            
            VStack(alignment: .leading){
                
                TextField("ユーザー名",text: $bufProfile.userName)
                    .font(.system(size: 22))
                Divider()
                TextField("紹介メッセージ",text: $bufProfile.introMessage)
                    .font(.system(size: 15))

            }
        }
        .padding(.all, 10)
        .background(InAppColor.textFieldColor)
        .cornerRadius(20)
        .frame(width: UIScreen.main.bounds.width - 40)
        //.shadow(radius: 3)

    }
}

struct UserInfoView_Previews: PreviewProvider {
    
    @State static var bufProfile = Profile()
    
    static var previews: some View {
        UserInfoView(bufProfile: bufProfile)
    }
}
