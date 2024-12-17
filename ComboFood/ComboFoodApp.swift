//
//  ComboFoodApp.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/15.
//

import SwiftUI

@main
struct ComboFoodApp: App {
    @AppStorage("useCount") private var useCount = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    useCount += 1
                }
        }
    }
}
