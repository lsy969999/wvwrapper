//
//  WVDelegate.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import Foundation

/**
 webview <-> viewmodel delegate Protocol
 */
protocol WVDelegate {
    func greeting(param1: String) -> String
}
