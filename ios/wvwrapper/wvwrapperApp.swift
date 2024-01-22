//
//  wvwrapperApp.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("--didFinishLaunchingWithOptions--")
        return true
    }
}

@main
struct wvwrapperApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
