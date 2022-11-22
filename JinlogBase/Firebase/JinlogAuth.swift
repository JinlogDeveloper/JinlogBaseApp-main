//
//  JinlogAuth.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/07/09.
//

import Foundation
import Firebase
import CoreAudioTypes

final class FirebaseAuth {

    private let auth: Auth

    private(set) var uid: String
    private(set) var isSignIn: Bool

    init() {
        print("FirebaseAuth init()")

        auth = Auth.auth()

        if auth.currentUser == nil {
            print("init : isSignIn = false")
            uid = ""
            isSignIn = false
        } else {
            print("init : isSignIn = true")
            uid = auth.currentUser!.uid
            isSignIn = true
        }

        auth.addStateDidChangeListener({ (authen, user) in
            // authの状態が変化する度にコールバックされる
            if user == nil {
                print("FirebaseAuth.isSignIn = false")
                self.uid = ""
                self.isSignIn = false
            } else {
                print("FirebaseAuth.isSignIn = true")
                self.uid = user!.uid
                self.isSignIn = true
            }
        })
        //TODO: どこかでremoveStateDidChangeListener()
    }

    //-------------------------------------------------------------------------------------------
    //サインイン処理
    //　　引数：メールアドレス、パスワード
    //　　返り値：ユーザID
    //　　処理：引数で指定された情報でログインの処理を行う
    func signIn(email: String, password: String) async throws -> String {
        print("サインイン処理を実行\nemail:\(email)\npassword:\(password)")

        guard !(email.isEmpty) else {
            print("Error : email is empty")
            throw JinlogError.argumentEmpty
        }
        guard !(password.isEmpty) else {
            print("Error : password is empty")
            throw JinlogError.argumentEmpty
        }

        do {
            let res = try await auth.signIn(withEmail: email, password: password)
            
            print("login success")
            return res.user.uid

        } catch {
            print("Error : ", error.localizedDescription)

            let errCode = AuthErrorCode.Code(rawValue: error._code)
            switch errCode {
            case .networkError:
                throw JinlogError.networkServer
            //case .〜〜〜:
                //TODO: 複数エラー区別
            default:
                throw JinlogError.unexpected
            }
        }
    }


    //-------------------------------------------------------------------------------------------
    //サインアウト処理
    //　　引数：なし
    //　　処理：サインアウトの処理を行う
    func signOut() throws {
        print("サインアウト処理を実行")        

        isSignIn = false
        uid = ""
        
        do {
            try auth.signOut()
        } catch {
            print("Error : ", error.localizedDescription)

            let errCode = AuthErrorCode.Code(rawValue: error._code)
            switch errCode {
            case .networkError:
                throw JinlogError.networkServer
            //case .〜〜〜:
                //TODO: 複数エラー区別
            default:
                throw JinlogError.unexpected
            }
        }
    }

    //-------------------------------------------------------------------------------------------
    //新しいアカウントの登録
    //　　引数：メールアドレス、パスワード、アカウント名
    //　　返り値：ユーザID
    //　　処理：引数で指定された情報で新しいアカウントの作成を行う
    func createAccount(email: String, password: String/*, name: String*/) async throws -> String {
        print("アカウント作成処理を実行\nemail:\(email)\npassword:\(password)")
        
        do {
            let result = try await auth.createUser(withEmail: email, password: password)

            /*
            //アカウント情報変更のリクエストを出してユーザー名を登録する
            //createProfileChangeRequest()でアカウント情報の更新ができる
            
            //ちなみにAuthenticationには以下の情報がデフォルトで登録できるようになってる
            //  　email:             /** Emailアドレス **/,
            //  　phoneNumber:       /** 電話番号 **/,
            //  　emailVerified:     /** boolean Emailアドレスの確認の有無 **/,
            //  　password:          /** パスワード **/,
            //  　displayName:       /** ユーザーの表示名 **/,
            //  　photoURL:          /** ユーザーの写真 URL **/,
            //  　disabled:          /** ユーザーが無効かどうか **/
            
            
            let req = result.user.createProfileChangeRequest()
            req.displayName = name  // ユーザー名を変更

            //変更内容を反映する
            let _ = try await req.commitChanges()
            
            //req.commitChanges(completion: { error in
            //    if error == nil {
            //        print("アカウント情報の更新完了")
            //    } else {
            //        print("アカウント情報の更新失敗")
            //    }
            //})
             */

            print("new UID : \(result.user.uid)")
            return result.user.uid
        }
        catch{
            print("アカウント作成に失敗しました")
            print("Error : ", error.localizedDescription)

            let errCode = AuthErrorCode.Code(rawValue: error._code)
            switch errCode {
            case .networkError:
                throw JinlogError.networkServer
            //case .〜〜〜:
                //TODO: 複数エラー区別
            default:
                throw JinlogError.unexpected
            }
        }
    }

    
    //-------------------------------------------------------------------------------------------
    //ユーザー情報が既存出ないか確認
    //　　引数：メールアドレス
    //　　返り値：0　⇢　存在なし／1　→　重複あり／-1　⇢　失敗
    //　　処理：
    
 
    func checkUserExists(email :String ,alert :inout Bool) async -> Int{
        
        print("アカウント情報がすでに存在しないか確認する")
        
        
        //？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
        // 登録済みのアドレスかどうか判断する専用のメソッドがないので、
        // サインイン方法を確認するメソッドを流用する

        //  どっかのタイミングでまた検討する

        //？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？

        do{
            //サインイン方法を確認するメソッドで既に登録があるか確認する
            let result = try await auth.fetchSignInMethods(forEmail: email)
            
            //返り値に何か情報が入っていれば既存のメールアドレス
            if(result != []){
                alert = true
                return 1
            }
            //情報が入ってなければ未登録
            else { return 0 }
        }
        catch let error as NSError{
            print("エラー発生: %@" ,error)
            alert = true
            return -1
        }
    }

    
    //-------------------------------------------------------------------------------------------
    //パスワードの再設定処理

    //ユーザー情報が既存出ないか確認
    //　　引数：メールアドレス
    //　　返り値：0　⇢　送信成功／-1　⇢　失敗
    //　　処理：

    func passwordReset(email: String) async {
        print("パスワードの再設定処理\nメール送付先:\(email)")
        
        do{
            try await auth.sendPasswordReset(withEmail: email)
        }
        catch let error as NSError{
            print("エラー発生: %@" ,error)
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------
    //ログイン状態の取得
    //　　引数：なし
    //　　返り値：bool値（ログイン状態ならtrue、それ以外はfalseを返す）
    //　　処理：ログイン状態を確認して状態をBool値で返す
    
 
    func getLoginState() -> Bool{
        print("ログイン状態を確認する")
        
        
        if let _ = auth.currentUser {
            return true
        } else {
            return false
        }
    }
    
    
    //-------------------------------------------------------------------------------------------
    //アカウント情報の取得
    //　　引数：なし
    //　　返り値：なし
    //　　処理：ログインしているアカウントの情報を共通変数へ書き込む
    
 
    func getAccountName() -> String{
        print("アカウント情報を取得する")
        
        guard let userName = auth.currentUser?.displayName else {return ""}
        
        return userName
    }
}

