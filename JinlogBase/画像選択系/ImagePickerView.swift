//
//  ImagePickerView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/07/04.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    // UIImagePickerController（写真撮影）が表示されているか
    @Binding var isShowSheet: Bool
    // 撮影した写真
    @Binding var captureImage: UIImage?
    
    // Coordinatorでコントローラのdelegateを管理
    class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate {
        
        // ImagePickerView型の定数を用意
        let parent: ImagePickerView
        
        // イニシャライザ　引数にparent(親)
        //コーディネーターの親がself.parentに格納される。
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        // 撮影が終わったときに呼ばれるdelegateメソッド(imagePickerController)、必ず必要
        // _　はラベルの省略
        //picker: UIImagePickerController カメラ撮影を行う画面を格納
        //info:[UIImagePickerController.InfoKey : Any] 撮影した写真の情報を格納
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
            [UIImagePickerController.InfoKey : Any]) {
                // 撮影した写真をcaptureImageに保存
                if let originalImage =
                    info[UIImagePickerController.InfoKey.originalImage]
                    as?
                    UIImage {
                    parent.captureImage = originalImage
                }
                // sheetを閉じない
                parent.isShowSheet = true
                
                
            }
        
        // キャンセルボタンを選択されたときに呼ばれる
        // delegateメソッド、必ず必要
        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController) {
                // sheetを閉じる
                parent.isShowSheet = false
            }
    } // Coordinatorここまで
    
    // Coordinatorを生成、SwiftUIによって自動的に呼びだし
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスを生成
        Coordinator(self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(
        context:
        UIViewControllerRepresentableContext<ImagePickerView>)
    -> UIImagePickerController {
        // UIImagePickerControllerのインスタンスを生成
        let myImagePickerController = UIImagePickerController()
        // sourceTypeにcameraを設定
        myImagePickerController.sourceType = .camera
        // delegate設定
        myImagePickerController.delegate = context.coordinator
        // UIImagePickerControllerを返す
        return myImagePickerController
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context:UIViewControllerRepresentableContext<ImagePickerView>)
    {
        // 処理なし
    }
} // ImagePickerViewここまで
