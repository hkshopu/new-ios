//
//  KeyboardHandler.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/26.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardHandler: ObservableObject{
    
    @Published private(set) var kbh: CGFloat = 0
    
    private var cancellable : AnyCancellable?
    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap{($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height}
    
    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map{ _ in CGFloat.zero}
    
    init(){
        
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.kbh , on: self)
        
    }
}
