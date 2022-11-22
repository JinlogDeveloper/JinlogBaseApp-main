//
//  PlayerRow.swift
//  JinlogBase
//
//  Created by Ken Oonishi on 2022/09/03.
//

import SwiftUI

struct PlayerRow: View {
    
    var username :String
    
    var body: some View {
        
        HStack{
            ZStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 40)
                    .padding(.all, 15.0)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.secondary, lineWidth: 3))
                
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .background()
//                    .foregroundColor(.secondary)
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//                    .offset(x: 27, y: 30)
            }
            .padding(.all, 5)
            
            VStack(alignment: .leading){
                
                Text(username)
                    .font(.system(size: 22))
                    .offset(y:10)
                Divider()
                Text("紹介メッセージ")
                    .font(.system(size: 15))
            }
            .offset(y:-5)
        }
        //.padding(.all, 10)
        //.frame(width: UIScreen.main.bounds.width - 40)
        //.background(InAppColor.textFieldColor)
        //.cornerRadius(20)
        //.shadow(radius: 3)
        
        
    }
}

struct PlayerRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerRow(username: "Ken")
    }
}
