//
//  CommonFile.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/25.
//

import Foundation
import SwiftUI


//-------------------------------------------------------------------------------------
//アプリ内配色の定数を作成する
struct InAppColor{
    static let backColor = Color("BackGroundColor")
    static let buttonColor = Color("ButtonColor")
    static let buttonColorRvs = Color("ButtonColorReverse")
    static let buttonColor2 = Color("ButtonColor2")
    static let strColor = Color("StringColor")
    static let strColorRvs = Color("StringColorReverse")
    static let textFieldColor = Color("StringFieldColor")
}


//-------------------------------------------------------------------------------------
//特定の画面へ一気に戻りたい場合に使用
//NavigationLinkで遷移する際にこのフラグに紐付ける
final class ReturnViewFrags{

    //ログイン画面に戻るときのフラグ
    static var returnToLoginView: Binding<Bool> = Binding<Bool>.constant(false)
    //トップ画面に戻るときのフラグ
    static var returnToTopView: Binding<Bool> = Binding<Bool>.constant(false)
}
