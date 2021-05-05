//
//  SaveButton.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/14.
//

import Foundation
import SwiftUI

struct SaveButton: View {
    
    @EnvironmentObject var language: SystemLanguage
    let buttonAction: () -> Void
    var body: some View{
        
        let context = language.content
        
        Button(action:{
            // dismiss the view
            buttonAction()
        }){
            ZStack{
                Capsule()
                    .frame(width: 0.9*UIScreen.screenWidth, height: 70, alignment: .center)
                    .foregroundColor(.mainTone)
                Text(context["Save"]!)
                    .font(.custom("SFNS", size: 18))
                    .foregroundColor(.white)
                
            }.compositingGroup()
        }
    }
}

struct ContinueButton: View {
    
    @EnvironmentObject var language: SystemLanguage
    let buttonAction: () -> Void
    var body: some View{
        
        let context = language.content
        
        Button(action:{
            // dismiss the view
            buttonAction()
        }){
            ZStack{
                Capsule()
                    .frame(width: 0.9*UIScreen.screenWidth, height: 70, alignment: .center)
                    .foregroundColor(.mainTone)
                Text(context["Continue"]!)
                    .font(.custom("SFNS", size: 18))
                    .foregroundColor(.white)
                
            }.compositingGroup()
        }
    }
}
