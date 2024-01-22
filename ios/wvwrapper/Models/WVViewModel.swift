//
//  WVViewModel.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import Foundation
class WVViewModel: NSObject, ObservableObject, WVDelegate {
    func greeting(param1: String) -> String {
        return "greeting + \(param1)"
    }
}
