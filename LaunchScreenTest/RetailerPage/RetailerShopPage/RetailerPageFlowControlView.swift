//
//  RetailerPageFlowControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/23.
//

import SwiftUI

enum RetailerPageFlow{
    case shopList
    case shop
    case firstAddShop
}
struct RetailerPageFlowControlView: View {
    
    @EnvironmentObject var shopData: ShopData
    @State var flow: RetailerPageFlow = .firstAddShop
    
    
    @State var isShowAddShop = false
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            switch flow{
            
            case .shopList:
                RetailerPageShopSelectView( flow: self.$flow)
                
            case .shop:
                RetailerPageView(flow: self.$flow)
            case .firstAddShop:
                FirstAddShopView(flow: self.$flow)
            }
        }
        
        .onAppear{
            // get shop list
            if !shopData.shop.isEmpty {
                flow = .shopList
            }
        }
    }
}

struct RetailerPageFlowControlView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageFlowControlView()
            .environmentObject(SystemLanguage())
            .environmentObject(InternetTask())
    }
}
