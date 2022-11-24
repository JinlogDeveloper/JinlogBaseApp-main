//
//  QrCodeScannerView.swift
//  JinlogBase
//
//  Created by 矢竹昭博 on 2022/11/24.
//


import SwiftUI
import AVFoundation

struct QrCodeScannerView: UIViewRepresentable {
    
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    //typealias でCameraPreviewという型名を、UIViewTypeという別名をつけている。
    typealias UIViewType = CameraPreview
    
    private let session = AVCaptureSession()
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    func interval(delay: Double) -> QrCodeScannerView {
        print("interval")
                    delegate.scanInterval = delay
        return self
    }
    //@escaping クロージャをエスケープ（エスケープクロージャ）
    func found(r: @escaping (String) -> Void) -> QrCodeScannerView {
        print("found")
                    delegate.onResult = r
        
        return self
    }
    
    
    
    func setupCamera(_ uiView: CameraPreview) {
        print("setupCamera")
               if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
                   if let input = try? AVCaptureDeviceInput(device: backCamera) {
                       session.sessionPreset = .photo //画質の設定
    
                       if session.canAddInput(input) {
                           session.addInput(input)
                       }
                       if session.canAddOutput(metadataOutput) {
                           session.addOutput(metadataOutput)
    
                           metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                           metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                       }
                       let previewLayer = AVCaptureVideoPreviewLayer(session: session)
    
                       uiView.backgroundColor = UIColor.gray
                       previewLayer.videoGravity = .resizeAspectFill
                       uiView.layer.addSublayer(previewLayer)
                       uiView.previewLayer = previewLayer
    
                       session.startRunning()
                   }
               }
    
           }
    
    
    //表示するViewの初期状態のインスタンスを生成するメソッド
    func makeUIView(context: UIViewRepresentableContext<QrCodeScannerView>) -> QrCodeScannerView.UIViewType {
        print("makeUIView")
                let cameraView = CameraPreview(session: session)
    
                checkCameraAuthorizationStatus(cameraView)
    
                return cameraView
            }
    
    
        static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
            print("dismantleUIView")
                uiView.session.stopRunning()
            }
    
        private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
            print("checkCameraAuthorizationStatus")
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                if cameraAuthorizationStatus == .authorized {
                    setupCamera(uiView)
                } else {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.sync {
                            if granted {
                                self.setupCamera(uiView)
                            }
                        }
                    }
                }
            }
    //表示するビューの状態が更新されるたびに呼び出され更新を反映させる
        func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<QrCodeScannerView>) {
            print("updateUIView")
                uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
                uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            }
    
    
    
}

struct QrCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeScannerView()
    }
}
