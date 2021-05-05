//
//  EmailValidationView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/3/4.
//

import SwiftUI

struct EmailValidationView: View {
    
    let isForgetPassword : Bool
    let myColor = Color(hex: 0x1DBCCF)
    @EnvironmentObject var internetTask:InternetTask
    @EnvironmentObject var userData: UserData
    @State var numberPadShouldDismiss = true
    
    @State var number: String = ""
    @State var status: Int = 1
    @State var isResentDisabled = false
    @State var tick = 0
    @State var showProtocolView = false
    //@State var isDisable = false
    
    @Binding var step: Int
    @Binding var dismiss: Bool
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            OnBoardBasicView(dismiss: $dismiss, step: $step, context: "電子郵件驗證")
            VStack {
                
                Spacer()
                    .frame(height:0.2*UIScreen.screenHeight)
                
                Text("請輸入您的驗證碼")
                
                Spacer()
                    .frame(height:16)
                Group{
                    
                    Text("已寄送驗證碼至您登入的電子郵件信箱")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(userData.basicData?.email ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    switch status{
                    case 0:
                        Text("成功")
                            .font(.footnote)
                            .foregroundColor(.red)
                    case -1:
                        Text("電子郵件不存在")
                            .font(.footnote)
                            .foregroundColor(.red)
                    case -2:
                        Text("驗證碼錯誤")
                            .font(.footnote)
                            .foregroundColor(.red)
                    case -3:
                        Text("驗證碼已過期，請重新產生")
                            .font(.footnote)
                            .foregroundColor(.red)
                    default:
                        EmptyView()
                    }

                    
                }
                HStack(alignment:.center, spacing: 0.05*UIScreen.screenWidth){
                    ForEach(0 ..< 4) { digit in
                        NumberElements( digit: digit, number: $number)
                    }.padding(.vertical, 0.07*UIScreen.screenHeight)
                }.onTapGesture {
                    if numberPadShouldDismiss{
                        numberPadShouldDismiss = false
                    }
                    if(!number.isEmpty){
                        number = ""
                    }
                }
                
                VStack (alignment:.center, spacing: 8){
                    Text("我沒收到驗證碼")
                        .foregroundColor(.gray)
                    Button(action: {
                        DispatchQueue.main.async {
                            withAnimation{
                                isResentDisabled = true
                            }
                            makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/generateAndSendValidationCodeProcess/",
                                        method: "POST", parameters: "email=\(String(describing: userData.basicData!.email))")
                        }
                        
                        
                    }){
                        Text("再寄一次")
                            .fontWeight(.black)
                            
                        
                    }
                    .foregroundColor(isResentDisabled ? .gray : myColor)
                    .disabled(isResentDisabled)
                    .onReceive(timer, perform: { _ in
                        if isResentDisabled{
                            tick += 1
                            if (tick == 60){
                                isResentDisabled = false
                                tick = 0
                            }
                        }
                        
                    })
                }
                
                Spacer()
                
                ZStack{
                    
                    VStack{
                        Button(action: {
                            if (number.count>=4){
                                DispatchQueue.main.async {
                                    let apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/validateEmailProcess/",
                                                                method: "POST", parameters: "email=\(String(describing: userData.basicData!.email))&validation_code=\(number)")
                                    
                                    status = apiReturn.status
                                    if (status == 0 && isForgetPassword == true){
                                        step = step + 1
                                    }
                                }
                                // if status = 0 -> go to homepage
                            }
                        }){
                            if (number.count>=4){
                                Image("Validation_Login")
                            }
                            else{
                                Image("Validation")
                            }
                        }
                        HStack{
                            Text("註冊帳號代表您同意")
                                .font(.footnote)
                            Button(action: {
                                showProtocolView.toggle()
                            }){
                                Text("<用戶協議條款>")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(myColor)
                        }
                        
                        if(isForgetPassword){
                            Spacer()
                                .frame(height: 0.1*UIScreen.screenHeight)
                        }
                        else{
                            HStack{
                                Button(action: {
                                    
                                    //TODO: Go to homepage
                                    
                                }){
                                    Text("略過")
                                }
                                .foregroundColor(.gray)
                            }.padding(.vertical, 0.05*UIScreen.screenHeight)
                        }
                        LogoView()
                            .ignoresSafeArea(edges: .bottom)
                        
                    }
                    if( !numberPadShouldDismiss){
                        CustomNumberPadView(number: $number, numberPadShouldDismiss: $numberPadShouldDismiss)
                            .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                            .frame(height:0.62*UIScreen.screenWidth)
                            .animation(.default)
                            .transition(.move(edge: .bottom))
                    }
                }
                
                
            }
            .sheet(isPresented: $showProtocolView, content: {
                ProtocolView(dismiss: $showProtocolView)
            })
        }
        
        
        
    }
}

struct NumberElements :View{
    
    let digit :Int
    @Binding var number :String
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 69, height: 79)
                .foregroundColor(Color(hex:0xE5E5EA))
            if(number.count > digit){
                Text(String(number[digit]))
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        
    }
}
struct EmailValidationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailValidationView(isForgetPassword: false, step: .constant(1), dismiss: .constant(true))
            .environmentObject(UserData())
    }
}
