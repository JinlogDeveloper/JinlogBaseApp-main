//
//  TextFieldRow.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/10.
//

import SwiftUI



extension View {
    /// 先頭にアイコン追加と背景を追加するモディファイア
    /// - Parameters:
    ///   - IconName: systemNameのアイコン名称
    ///   - IconColor: アイコンの色指定
    /// - Returns: View
    func FrontIconStyle(IconName: String, IconColor: Color) -> some View {
        self.modifier(Front(IconName: IconName, IconColor: IconColor))
    }
}


struct Front: ViewModifier {
    
    let IconName: String
    let IconColor: Color
    
    
    func body(content: Content) -> some View {
            HStack{
                Image(systemName: IconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(IconColor)
                    .frame(width: 25.0, height: 25.0)
                content
                
            }
            .padding(12.0)
            .frame(maxWidth: 400)
            .background(InAppColor.textFieldColor)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 3)
            .padding(.horizontal, 20.0)
    }
}



/// アプリ内の共用目的で作ったテキストフィールド
///
/// 紐付ける変数とアイコンの名称を指定すると先頭にアイコンが付いたテキストフィールドが作成されます
///
/// - fieldText　入力文字と紐付ける変数
/// - iconName　systemNameのアイコン名称
/// - iconColor　アイコンの色指定
/// - text　未入力時の説明文
///
/// - Note: iconColor と text は省略可能です

struct TextFieldRow: View {
    
    @Binding var fieldText: String
    var iconName: String
    var iconColor: Color = InAppColor.strColor
    var text = "text"
    
    var body: some View {
        TextField(text,text: $fieldText)
            .FrontIconStyle(IconName: iconName, IconColor: iconColor)
    }
}


/// アプリ内の共用目的で作ったセキュリティテキストフィールド
///
/// 紐付ける変数とアイコンの名称を指定すると先頭にアイコンが付いたテキストフィールドが作成されます
///
/// - fieldText　入力文字と紐付ける変数
/// - iconName　systemNameのアイコン名称
/// - iconColor　アイコンの色指定
/// - text　未入力時の説明文
/// - hiddePW　パスワードの表示切替（設定不要）
///
/// - Note: iconColor と text は省略可能です

struct SecureFieldRow: View {

    @Binding var fieldText: String
    var iconName: String
    var iconColor: Color = InAppColor.strColor
    var text = "text"
    
    @State var hiddePW = true       //パスワードの表示の切替えフラグ
    
    
    var body: some View {
        HStack {
            ZStack {
                SecureField(text,text: self.$fieldText)
                    .keyboardType(.alphabet)
                    .opacity(hiddePW ? 1 : 0)
                TextField(text,text: self.$fieldText)
                    .opacity(hiddePW ? 0 : 1)
            }
            HidePasswordButton(hidde: self.$hiddePW)
        }//HStack
        .FrontIconStyle(IconName: iconName, IconColor: iconColor)
    }//body
}



struct HidePasswordButton: View {

    @Binding var hidde: Bool
    
    var body: some View {
        Button {
            hidde.toggle()
        } label: {
            Image(systemName: self.hidde ? "eye.slash" : "eye")
                .foregroundColor( self.hidde ? .gray : .blue)
                .frame(width: 25, height: 25)
        }
    }
}


struct TextFieldRow_Previews: PreviewProvider {
    
    @State static var str = ""
    @State static var hidde = true
    static var color = InAppColor.strColor

    static var previews: some View {
        Group{
            TextFieldRow(fieldText: $str, iconName: "person", iconColor: InAppColor.buttonColor, text: "name")
            SecureFieldRow(fieldText: $str, iconName: "lock", iconColor: InAppColor.buttonColor, text: "password")
            HidePasswordButton(hidde: $hidde)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}

