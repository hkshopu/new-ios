//
//  AddShopMainView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/22.
//

import SwiftUI

struct AddShopMainView: View {
    
    //@Binding var shopData: ShopData
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
            AddShopInfoView()
            
        }
        
    }
}

struct AddShopMainView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopMainView()
    }
}
