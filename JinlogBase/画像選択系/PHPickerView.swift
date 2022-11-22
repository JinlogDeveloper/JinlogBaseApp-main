//
//  PHPickerView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/06/28.
//

import SwiftUI

//PHPickerViewControllerを使う為にPhotosUIをインポート

import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    //View　を　UIViewControllerRepresentable プロトコルに変更
    
    //sheetが表示されているか
    @Binding var isShowSheet: Bool
    
    //フォトライブラリーから読み込む写真
    @Binding var captureImage: UIImage?
    
    
    //Coordinator でコントローラの delegate　を管理
    // delegate　とは　処理が完了したときに通知される仕組み
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        // NSObject　はPHPickerViewControllerDelegateを使用する際に必要になるプロトコル
        // PHPickerViewControllerDelegate はPHPickerViewControllerで発生したユーザー操作をdelegateで検知できるようにする。
        
        //PHPickerView型の変数を用意
        var parent: PHPickerView
        
        //イニシャライザ
        init(parent: PHPickerView) {
            self.parent = parent
        }
        
        //フォトライブラリーで写真を選択・キャンセルしたときに実行される
        //delegate メソッド、必ず必要
        func picker( _ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //            picker:フォトライブラリー画面を格納。 アンダースコアはラベル名の省略
            //            results:選択した写真の情報を格納.
            //            didFinishPicking:ラベル名
            
            //　写真は１つだけ選べる設定なので、最初の１件を指定
            if let result = results.first {
                
                // UIImage型の写真のみ非同期で取得
                result.itemProvider.loadObject(ofClass: UIImage.self) {
                    (image, error) in
                    //　写真が取得できたら
                    if let unwrapImage = image as? UIImage {
                        
                        //選択された写真を追加する
                        self.parent.captureImage = unwrapImage
                        
                        
                        
                    } else {
                        print("使用できる写真がないです")
                    }
                }
                
                // sheetを閉じない
                parent.isShowSheet = true
                
            } else {
                print("選択された写真はないです")
                // sheetを閉じない
                parent.isShowSheet = false
                
            }
            
        } //picker　ここまで
        
        
    } //Coordinator ここまで
    
    //Coordinatorを生成、SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        
        //Coordinatorクラスのインスタンスを生成
        Coordinator(parent: self)
        
    }
    
    //Viewを生成するときに実行
    func makeUIViewController(
        context:UIViewControllerRepresentableContext<PHPickerView>) -> PHPickerViewController {
            
            //PHPickerViewControllerのカスタマイズ
            var configuration = PHPickerConfiguration()
            
            //静止画を選択
            configuration.filter = .images
            
            //フォトライブラリーで選択できる枚数を１枚にする
            configuration.selectionLimit = 1
            
            //PHPickerViewControllerのインスタンスを生成
            let picker = PHPickerViewController(configuration: configuration)
            
            //delegate設定
            picker.delegate = context.coordinator
            
            //PHPickerViewControllerを返す
            return picker
            
        }
    
    //Viewが更新されたときに実行
    func updateUIViewController( _ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PHPickerView>){
        //処理無し
    }    
} //PHPickerView　ここまで

