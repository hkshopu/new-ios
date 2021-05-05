//
//  SignUpView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/26.
//

import SwiftUI

struct SignInPassWord: View {
    
    @EnvironmentObject var userData :UserData
    @EnvironmentObject var internetTask:InternetTask
    @EnvironmentObject var userStatus :User
    @Binding var step :Int
    @Binding var dismiss: Bool
    @State var loginstatus = Int(6)
    
    @State var email = ""
    @State var password = ""
//    {
//        didSet{
//            invalidPassword = !isValidPassword(password)
//        }
//    }
    @State var confirm_password = ""
    @State var isShowPassword = false
    
    @State var invalidEmail = false
    @State var invalidPassword = false
    @State var invalidConfirm = false
    
    @State var ifDisable = false
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    //var user : User
    
    var body: some View {
        ZStack {
            
            OnBoardBasicView(dismiss: $dismiss, step: $step, context: "用戶登入")
            .onAppear(){
                if userData.haveBasicData {
                    email = userData.basicData?.email ?? ""
                }
            }
            
            VStack (alignment: .center, spacing: 15){
                
                //Social Login
                Group{
                    Text(email)
                        .font(.body)
                        .foregroundColor(Color(hex: 0x8E8E93, alpha: 1.0))
                }
                
                Spacer()
                    .frame(height: 0.025*UIScreen.screenHeight)
                
                ScrollView {
                    VStack (alignment:.leading, spacing: 20){
                        if invalidPassword {
                            Text("密碼格式錯誤")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        HStack{
                            let width = 0.82*UIScreen.screenWidth
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: width, height: elementsHeight)
                                    
                                    .foregroundColor(elementColor)
                                
                                if(isShowPassword){
                                    TextField("密碼",
                                              text: self.$password,
                                              onCommit:{
                                                invalidPassword = !isValidPassword(password)
                                              })
                                        .frame(width:width-30)
                                        .keyboardType(.asciiCapable)
                                        .disableAutocorrection(true)
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    
                                }else{
                                    SecureField("密碼",
                                                text: self.$password,
                                                onCommit:{
                                                    invalidPassword = !isValidPassword(password)
                                                })
                                        .frame(width:width-30)
                                        .keyboardType(.asciiCapable)
                                    
                                }
                                
                                
                                Button(action: {isShowPassword.toggle()}){
                                    Image(isShowPassword ? "Eye_On" : "Eye_Off")
                                    
                                }
                                .offset(x:0.33 * UIScreen.screenWidth)
                                
                                
                            }
                            
                        }
                        
                    }
                    Spacer()
                        .frame(height: 16)
                    
                    VStack{
                        
                        Button(action:{
                            //invalidEmail = !isValidEmail(email)
                            invalidPassword = !isValidPassword(password)
                            //invalidConfirm = !(password == confirm_password)
                            
                            if ((!invalidPassword)){
                                //parameterPacking()
                                
                                let apiReturn = makeloginAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/loginProcess/", method: "POST", parameters:"email=\(email)&password=\(password)")
                                loginstatus = optioanlInt(int: apiReturn.status)
                                userStatus.id = optioanlInt(int: apiReturn.user_id)
                                
                            }
                            
                        }){
                            Image("Next_CHT")
                        }
                        Button(action:{
                        
                            let apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/generateAndSendValidationCodeProcess/",
                                        method: "POST", parameters: "email=\(String(describing: userData.basicData!.email))")
                            loginstatus = apiReturn.status
                            ifDisable = true
                            step = 6
                        }){
                            Text("忘記密碼？")
                                .foregroundColor(Color(hex: 0x1DBCCF, alpha: 1.0))
                                .font(.footnote)
                        }.disabled(ifDisable)
                        switch loginstatus {
                        case 0:
                            Text("登入成功")
//                            userStatus.id =
                            //userData.$isLoggedIn
                        case -1:
                            Text("電子郵件或密碼未填寫")
                        case -2:
                            Text("Email Error")
                        case -3:
                            Text("Password Error")
                        default:
                            Text("登入狀態")
                            //break
                        }
                    }
                }
                .padding(.bottom, 0.07*UIScreen.screenHeight)
            }
            .padding(.top, 0.2*UIScreen.screenHeight)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    private func parameterPacking(){
        let basicData = BasicData(email: email, password: password, confirm_password: confirm_password)
        var count = 0
        let s :[String] = [email, password, confirm_password]
        userData.basicData = basicData
        
        let m  = Mirror(reflecting: basicData)
        for child in m.children{
            userData.parameter.append(child.label ?? "")
            userData.parameter.append("=")
            userData.parameter.append(s[count])
            if count < m.children.count-1{
                userData.parameter.append("&")
                count += 1
            }
        }
        userData.haveBasicData = true
    }
}

private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

private func isValidPassword(_ password: String) -> Bool {
    let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordPred.evaluate(with: password)
}

struct SignInPassWord_Previews: PreviewProvider {
    static var previews: some View {
        SignInPassWord(step: .constant(0), dismiss: .constant(true))
            .environmentObject(UserData())
    }
}
