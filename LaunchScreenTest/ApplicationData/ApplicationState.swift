//
//  ApplicationState.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/15.
//

import Foundation

class ApplicationState: ObservableObject{
    // default state while launching
    @Published var menuBarButtonTapped = false
    @Published var menuBarItem = -1
    @Published var mainViewID = 0
}
