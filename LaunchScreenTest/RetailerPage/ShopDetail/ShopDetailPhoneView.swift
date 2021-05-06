//
//  ShopDetailPhoneView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/14.
//

import SwiftUI

struct ShopDetailPhoneView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    @StateObject var keyboardHandler = KeyboardHandler()
    @Binding var isShowEditView:Bool
    
    @State var text = ""
    @State var isShowPhone = false
    @State var isEditing = false
    
    let textField = UITextField()
    var body: some View {
        let context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                BasicNavigationBar(context: context["ShopDetailPhoneView_1"]!, showRingView: false, buttonAction: {withAnimation{isShowEditView = false}})
                VStack (spacing: 8){
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        
                        ZStack(alignment:.leading){
                            if !textField.hasText{
                                Text(context["ShopDetailPhoneView_2"]!)
                                    .foregroundColor(Color(hex: 0x8E8E93))
                                    .font(.custom("SFNS", size: 14))
                            }
                            NumericTextField( isEditing: self.$isEditing, text: self.$text, completionHandler: completionHandler, textField: textField)
                        }.padding(.horizontal)
                    }
                    .frame(width: 0.9*UIScreen.screenWidth, height: 46)
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        HStack{
                            Toggle(isOn: self.$isShowPhone, label: {
                                Text(context["ShopDetailPhoneView_3"]!)
                                    .font(.custom("SFNS", size: 14))
                            })
                        }.padding(.horizontal)
                    }
                    .frame(width: 0.9*UIScreen.screenWidth, height: 55)
                }
                
                
                Spacer()
                // save button
                
                SaveButton(buttonAction: {
                    text = textField.text!
                    //if let id = userStatus.id {
                        if let shopid = shopData.currentShopID {
                            let apireturn = makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/\(shopid)/update/", method: "POST", parameters: "address_phone=\(text)")
                            print("shopid = ", shopid,"address_phone = ",text)
                        print (apireturn.status)
                        }
                    //}
                    
                }).disabled(text.isEmpty)
                
            }.padding(.vertical, 40)
            .padding(.bottom, keyboardHandler.kbh)
            .animation(.default)
            
        }
        .ignoresSafeArea(.all)
        .onTapGesture {
            if isEditing {
                isEditing = false
                text = textField.text!
                textField.resignFirstResponder()
                if !text.isEmpty{
                    completionHandler()
                }
                
            }
        }
    }
    func completionHandler() -> Void{
        DispatchQueue.main.async { [self] in
            // do something if needed
        }
    }
}

struct ShopDetailPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailPhoneView( isShowEditView: .constant(true))
            .environmentObject(SystemLanguage())
    }
}
