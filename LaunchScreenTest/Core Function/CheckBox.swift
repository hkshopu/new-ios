//
//  CheckBox.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/26.
//

import SwiftUI

struct CheckBox: View {
    
    @Binding var isChecked: Bool
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 15, height: 15)
                .foregroundColor(isChecked ? Color(hex: 0x34C759) : Color(hex: 0xE5E5EA))
            if ( isChecked) {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 9)
                    .foregroundColor(.white)
            }
        }.onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.1)){
                isChecked.toggle()
            }
            
        }
    }
}
