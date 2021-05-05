//
//  ShopDetailPhoneView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/14.
//

import SwiftUI
private enum Flow{
    case check
    case edit
}
struct ShopDetailMailControlView: View{
    
    @State fileprivate var flow = Flow.check
    @Binding var isShowEditView:Bool
    var body: some View{
        switch flow{
        case .check:
            ShopDetailMailCheckView( isShowEditView: self.$isShowEditView, flow: self.$flow)
            
        case .edit:
            ShopDetailMailEditView(isShowEditView: self.$isShowEditView)
        }
    }
}
struct ShopDetailMailCheckView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask: InternetTask
    @StateObject var keyboardHandler = KeyboardHandler()
    @Binding var isShowEditView:Bool
    @Binding fileprivate var flow: Flow
    
    @State var text = ""
    @State var isShowPhone = false
    @State var isEditing = false
    @State var isSecure = true
    @State var isShowForgetPasswordView = false
    
    let textField = UITextField()
    var body: some View {
        let context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                
                BasicNavigationBar(context: context["ShopDetailMailCheckView_1"]!, showRingView: false, buttonAction: {withAnimation{isShowEditView = false}})
                VStack (spacing: 8){
                    HStack {
                        Text(context["ShopDetailMailCheckView_2"]!)
                            .foregroundColor(Color(hex:0x8E8E93))
                            .font(.custom("SFNS", size: 12))
                        Spacer()
                    }.padding(.horizontal, 0.11*UIScreen.screenWidth)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        
                        HStack {
                            ZStack(alignment:.leading){
                                if !textField.hasText{
                                    Text(context["ShopDetailMailCheckView_3"]!)
                                        .foregroundColor(Color(hex: 0x8E8E93))
                                        .font(.custom("SFNS", size: 14))
                                }
                                SecureTextField( isEditing: self.$isEditing, text: self.$text, isSecure: self.$isSecure, completionHandler: completionHandler, textField: textField)
                            }
                            Spacer()
                            Button(action:{isSecure.toggle()}){
                                Image( !isSecure ? "Eye_On" : "Eye_Off")
                            }
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
                .padding(.top)
                
                Spacer()
                // save button
                
                VStack (spacing: 16){
                    ContinueButton(buttonAction: {
                        text = textField.text!
                        //TODO: Call api here
                        flow = .edit
                    }).disabled(text.isEmpty)
                    Button(action: {
                        
                        isShowForgetPasswordView = true
                    }){
                        Text(context["ForgetPassword"]!)
                            .font(.custom("SFNS", size: 14))
                            .underline()
                    }.foregroundColor(.mainTone)
                }
                
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
        .fullScreenCover(isPresented: self.$isShowForgetPasswordView, content: {
            // TODO: connect to forget password view
            SignInControlView(dismiss: self.$isShowForgetPasswordView, step:6)
        })
    }
    func completionHandler() -> Void{
        DispatchQueue.main.async { [self] in
            // do something if needed
        }
    }
}

struct ShopDetailMailEditView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var internetTask: InternetTask
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
                BasicNavigationBar(context: context["ShopDetailMailEditView_1"]!, showRingView: false, buttonAction: {withAnimation{isShowEditView = false}})
                VStack (spacing: 8){
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        
                        ZStack(alignment:.leading){
                            if !textField.hasText{
                                Text(context["ShopDetailMailEditView_2"]!)
                                    .foregroundColor(Color(hex: 0x8E8E93))
                                    .font(.custom("SFNS", size: 14))
                            }
                            ShopNameTextField( isEditing: self.$isEditing, text: self.$text, completionHandler: completionHandler, textField: textField)
                        }.padding(.horizontal)
                    }
                    .frame(width: 0.9*UIScreen.screenWidth, height: 46)
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
                        HStack{
                            Toggle(isOn: self.$isShowPhone, label: {
                                Text(context["ShopDetailMailEditView_3"]!)
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
struct ShopDetailMailView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailMailControlView( isShowEditView: .constant(true))
            .environmentObject(SystemLanguage())
    }
}
