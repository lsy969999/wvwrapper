//
//  ContentView.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wvViewModel: WVViewModel = WVViewModel()
    var body: some View {
        VStack {
            WVView(wvViewModel: wvViewModel)
        }
    }
}

#Preview {
    ContentView()
}
