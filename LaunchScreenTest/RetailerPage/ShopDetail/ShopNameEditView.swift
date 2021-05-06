//
//  ShopNameEditView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/9.
//

import SwiftUI

struct ShopNameEditView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    @StateObject var keyboardHandler = KeyboardHandler()
    @Binding var isShowEditView:Bool
    //@Binding var shopData:ShopData
    @State var text = ""
    @State var isShowPopup = false
    @State var isEditing = false
    let textField = UITextField()
    var body: some View {
        let context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                BasicNavigationBar(context: context["ShopNameEditView_1"]!, showRingView: false, buttonAction: {withAnimation{isShowEditView = false}})
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                    if isEditing {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .foregroundColor(.red)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                    }
                    ZStack(alignment:.leading){
                        if !textField.hasText{
                            Text(context["ShopNameEditView_2"]!)
                                .foregroundColor(Color(hex: 0x8E8E93))
                                .font(.custom("SFNS", size: 14))
                        }
                        ShopNameTextField( isEditing: self.$isEditing, text: self.$text, completionHandler: completionHandler, textField: textField)
                    }.padding(.horizontal)
                }
                
                .frame(width: 0.9*UIScreen.screenWidth, height: 46)
                
                if(isEditing && textField.hasText){
                    HStack{
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(context["ShopNameEditView_2"]!)
                            .foregroundColor(.red)
                            .font(.custom("SFNS", size: 14))
                        Spacer()
                    }.padding(.horizontal, 30)
                }
                Spacer()
                
                // save button
                
                SaveButton(buttonAction: {
                    text = textField.text!
                    withAnimation{
                        isShowPopup = true
                    }
                }).disabled(text.isEmpty)
                
            }.padding(.vertical, 40)
            .padding(.bottom, keyboardHandler.kbh)
            .animation(.default)
            
            if isShowPopup {
//                Popup(isShowPopupView: self.$isShowPopup, isShowShopNameEditView: self.$isShowEditView,shopdata: $shopData ,text: text)
                Popup(isShowPopupView: self.$isShowPopup, isShowShopNameEditView: self.$isShowEditView,text: text)
                    .animation(Animation.easeInOut(duration: 3.0))
                    .transition(.opacity)
            }
        }.onAppear(){
            print(shopData.currentShopID,shopData.currentShop.detail!.shop_title)
            textField.text = shopData.currentShop.detail!.shop_title
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
            let apiRetuen = makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/checkShopNameIsExistsProcess/",
                                        method: "POST", parameters: "shop_title=\(text)")
            
            if apiRetuen.status != 0{
                
                textField.becomeFirstResponder()
                
            }
        }
    }
}
private struct Popup: View{
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask:InternetTask
    @EnvironmentObject var userStatus:User
    @EnvironmentObject var shopdata:ShopData
    @Binding var isShowPopupView: Bool
    @Binding var isShowShopNameEditView: Bool
    @State var isAlertOn = false
    @State var AlertText = ""
    let text: String
    
    var body: some View{
        let  context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.4)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(hex:0xF6F6F6))
                VStack(spacing: 10){
                    Spacer()
                    Text(context["ShopNameEditViewPopup_1"]!)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(context["ShopNameEditViewPopup_2"]!)
                        .font(.custom("SFNS", size: 14))
                    HStack(spacing:18){
                        Button(action: {
                            withAnimation{
                                isShowPopupView = false
                            }
                        }){
                            ZStack{
                                Capsule()
                                    .stroke(Color.mainTone, style: StrokeStyle(lineWidth:2))
                                Text(context["Cancel"]!)
                                    .font(.custom("SFNS", size: 18))
                                    .foregroundColor(.mainTone)
                            }
                        }
                        Button(action: {
                            isAlertOn = false
                            withAnimation{
                                isShowPopupView = false
                                isShowShopNameEditView = false
                            }
                            DispatchQueue.main.async {
                                
                                //TODO: call update shop name api here
                                if let id = userStatus.id {
                                    if let shopid = shopdata.currentShopID {
                                        let apireturn = makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/\(shopid)/update/", method: "POST", parameters: "shop_title=\(text)")
                                        print("shopid = ", shopid)
                                    print (apireturn.status)
                                        let status = apireturn.status
                                            switch status {
                                            case 0:
                                                isAlertOn = false
                                            case -43:
                                                isAlertOn = true
                                                AlertText = "過去 30 天內已更改過商店名稱!"
                                            case -44:
                                                isAlertOn = true
                                                AlertText = "此商店名稱已存在，請選擇其他名稱!"
                                            default:
                                                isAlertOn = true
                                            }
                                        
                                    }
                                }
                            }
                        }){
                            ZStack{
                                Capsule()
                                    .foregroundColor(.mainTone)
                                    
                                Text(context["Confirm"]!)
                                    .font(.custom("SFNS", size: 18))
                                    .foregroundColor(.white)
                            }
                        }.alert(isPresented: $isAlertOn)  { () -> Alert in
                            Alert(title: Text("錯誤"), message: Text("必填資訊不能為空或0"))
                        }
                    }
                    .frame(height:62)
                    .padding(20)
                }
            }.frame(width: 0.9*UIScreen.screenWidth, height: 210, alignment: .center)
        }

        
    }
}
struct ShopNameEditView_Previews: PreviewProvider {
    static var previews: some View {
        ShopNameEditView(isShowEditView: .constant(true))
            .environmentObject(SystemLanguage())
            .environmentObject(InternetTask())
            .environmentObject(ShopData())
    }
}

