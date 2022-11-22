//
//  CentralDataSampleApp.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/24.
//

import SwiftUI

@main
struct JinlogBaseApp: App {

    init() {
        JinlogFirebase.firebaseInit()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
