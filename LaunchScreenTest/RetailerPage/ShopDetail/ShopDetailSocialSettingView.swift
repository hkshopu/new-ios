//
//  ShopDetailPhoneView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/14.
//

import SwiftUI

struct ShopDetailSocialSettingView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask: InternetTask

    @Binding var isShowEditView:Bool
    
    @State var isShare2FB = false
    @State var isShare2IG = false
    
    let textField = UITextField()
    var body: some View {
        let context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                BasicNavigationBar(context: context["ShopDetailSocialSettingView_1"]!, showRingView: false, buttonAction: withAnimation{{isShowEditView = false}})
                VStack (spacing: 8){
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        HStack{
                            Image("FB_product")
                            Toggle(isOn: self.$isShare2FB, label: {
                                Text(context["ShopDetailSocialSettingView_2"]!)
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(Color(hex: 0x48484A))
                            })
                        }.padding(.horizontal)
                    }
                    .frame(width: 0.9*UIScreen.screenWidth, height: 55)
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        
                        HStack{
                            Image("IG_product")
                            Toggle(isOn: self.$isShare2FB, label: {
                                Text(context["ShopDetailSocialSettingView_3"]!)
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(Color(hex: 0x48484A))
                            })
                        }.padding(.horizontal)
                    }
                    .frame(width: 0.9*UIScreen.screenWidth, height: 55)
                }
                
                
                Spacer()
                // save button
                
                SaveButton(buttonAction: {
                    isShowEditView = false
                    // TODO: Save changes to backend
                    
                })
                
            }.padding(.vertical, 40)
            .animation(.default)
            
        }
        .ignoresSafeArea(.all)
        
    }

}

struct ShopDetailSocialSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailSocialSettingView( isShowEditView: .constant(true))
            .environmentObject(SystemLanguage())
    }
}
