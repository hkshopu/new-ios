//
//  ShopDetailControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/9.
//

import SwiftUI

struct ShopDetailControlView: View {
    @Binding var isShowDetailView :Bool
    //@Binding var shopData: ShopData
    @State var isShowShopNameEditView = false
    @State var isShowDescriptionView = false
    @State var isShowNumberEditView = false
    @State var isShowEmailEditView = false
    @State var isShowSocialSettingView = false
    var body: some View {
        ZStack{
            ShopDetailView(
                isShowShopNameEditView:self.$isShowShopNameEditView,
                    isShowDetailView :  self.$isShowDetailView,
                isShowDescriptionView: self.$isShowDescriptionView,
                isShowNumberEditView: self.$isShowNumberEditView,
                isShowEmailEditView: self.$isShowEmailEditView,
                isShowSocialSettingView: self.$isShowSocialSettingView)
                .zIndex(1.0)
            Group{
                if isShowShopNameEditView {
                    ShopNameEditView(isShowEditView: self.$isShowShopNameEditView)
                        .animation(.easeInOut)
                        .transition(.move(edge: .trailing))
                }
                if isShowDescriptionView {
                    ShopDescriptionEditView(dismiss: self.$isShowDescriptionView)
                        .animation(.easeInOut)
                        .transition(.move(edge: .trailing))
                }
                if isShowNumberEditView {
                    ShopDetailPhoneView(isShowEditView: self.$isShowNumberEditView)
                        .animation(.easeInOut)
                        .transition(.move(edge: .trailing))
                }
                if isShowEmailEditView {
                    ShopDetailMailControlView(isShowEditView: self.$isShowEmailEditView)
                        .animation(.easeInOut)
                        .transition(.move(edge: .trailing))
                }
                if isShowSocialSettingView{
                    ShopDetailSocialSettingView(isShowEditView: self.$isShowSocialSettingView)
                        .animation(.easeInOut)
                        .transition(.move(edge: .trailing))

                }
            }.zIndex(2.0)
        }
        
        
    }
}

struct ShopDetailControlView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailControlView(isShowDetailView: .constant(true))
            .environmentObject(SystemLanguage())
            .environmentObject(InternetTask())
    }
}
