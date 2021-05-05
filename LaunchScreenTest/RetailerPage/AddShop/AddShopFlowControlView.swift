//
//  AddShopFlowControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/21.
//

import SwiftUI

struct AddShopFlowControlView: View {
    
    @State var allData : [Data] = []
    @State var isShowAddBankView = false
    @State var isShowAddAddressView = false
    
    @Binding var dismiss: Bool
    @Binding var flow:RetailerPageFlow
    let nextPage: RetailerPageFlow
    var body: some View {
        
        ZStack{
            AddShopBasicView(isShowAddShopBasic: self.$dismiss, isShowNextView: self.$isShowAddBankView, allData: self.$allData)
            
            if isShowAddBankView {
                AddShopDetailView(isShowBankDetail: self.$isShowAddBankView, isShowNextView: self.$isShowAddAddressView, allData: self.$allData)
            }
            if isShowAddAddressView {
                AddShopDetailAddressView(isShowAddressDetail: self.$isShowAddAddressView, isShowAddShopView: self.$dismiss, allData: self.$allData, flow: self.$flow)
            }
        }.ignoresSafeArea()
        
    }
}

struct AddShopFlowControlView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopFlowControlView(dismiss: .constant(false), flow: .constant(RetailerPageFlow.shop), nextPage: .shop)
    }
}
