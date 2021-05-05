//
//  BasicNavigationBar.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/1.
//

import SwiftUI

struct BasicNavigationBar: View {
    
    let context: String
    let showRingView: Bool
    let buttonAction: ()->Void
    var body: some View {
        HStack{
            Button(action:{
                withAnimation {
                    
                    buttonAction()
                    
                }
            })
            {
                //Back Button
                Image(systemName: "arrow.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                    .foregroundColor(Color(hex:0x8E8E93))
            }
            Spacer()
            Text(context)
                .font(.custom("SFNS", size: 18))
                .foregroundColor(Color(hex:0x48484A))
            Spacer()
            if showRingView {
                RingView(notifications: .constant(20))
            }
        }.padding(.horizontal, 30)
        
    }
}

