//
//  SignUpView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/26.
//

import SwiftUI

struct NewPassWord: View {
    
    @EnvironmentObject var userData :UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @Binding var step :Int
    @Binding var dismiss: Bool

    
    @State var email = ""
    @State var password = "" {
        didSet{
            invalidPassword = !isValidPassword(password)
        }
    }
    @State var confirm_password = ""
    @State var isShowPassword = false
    
    @State var invalidEmail = false
    @State var invalidPassword = false
    @State var invalidConfirm = false
    @State var loginstatus = -1
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    //var user : User
    
    var body: some View {
        VStack(alignment: .center){
            // Top Roll Including Back Button
            HStack{
                Button(action:{
                    withAnimation{
                        dismiss = false
                    }
                })
                {
                    //Back Button
                    Image("Back_Arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                }
                Spacer()
                Text("輸入新密碼")
                    .font(.title2)
                Spacer()
            }.padding(.horizontal, 30)
            
            Spacer()
                .frame(height:90)
            
            //TODO: Put Social Login Here
            
            
            
            
            //
            
            
            // Name Roll
            VStack (alignment:.center, spacing: 20){
                
//                HStack(alignment:.center, spacing: 32){
//                    Button(action:{}){
//                        Image("Google_LogIn_s")
//                    }
//                    Button(action:{}){
//                        Image("Facebook_LogIn_s")
//                    }
//                    Button(action:{}){
//                        Image("Apple_LogIn_s")
//                    }
//
//                }
                Text("請輸入您的新密碼")
                    .font(.body)
                    .foregroundColor(Color(hex: 0x8E8E93, alpha: 1.0))
                
//                if invalidEmail {
//                    Text("電子郵件格式錯誤")
//                        .fontWeight(.bold)
//                        .foregroundColor(.red)
//                }
//
//                HStack{
//                    let width = 0.82*UIScreen.screenWidth
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 8)
//                            .frame(width: width, height: elementsHeight)
//                            .foregroundColor(elementColor)
//                        TextField("電子郵件地址",
//                                  text: self.$email,
//                                  onCommit:{
//                                    invalidEmail = !isValidEmail(email)
//                                  })
//                            .frame(width:width-30)
//                            .keyboardType(.emailAddress)
//                            .disableAutocorrection(true)
//                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
//
//
//                    }
//
//                }
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
                            TextField("新密碼",
                                      text: self.$password,
                                      onCommit:{
                                        invalidPassword = !isValidPassword(password)
                                      })
                                .frame(width:width-30)
                                .keyboardType(.asciiCapable)
                                .disableAutocorrection(true)
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                        }else{
                            SecureField("新密碼",
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
                //Text("\(password)")
                if invalidConfirm{
                    Text("兩次密碼不同！")
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
                            TextField("再次確認密碼",
                                      text: self.$confirm_password,
                                      onEditingChanged:{ editing in
                                        if !editing {
                                            invalidConfirm = !(password == confirm_password)
                                        }
                                      },
                                      onCommit: {
                                        invalidConfirm = !(password == confirm_password)
                                      })
                                .frame(width:width-30)
                                .keyboardType(.asciiCapable)
                                .disableAutocorrection(true)
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                        }else{
                            SecureField("再次確認密碼",
                                        text: self.$confirm_password,
                                        onCommit: {
                                          invalidConfirm = !(password == confirm_password)
                                        })
                                .frame(width:width-30)
                                .keyboardType(.asciiCapable)
                                
                        }
                        
                        
                        Button(action: {
//                            if isShowPassword {
//                                confirm_password_h = confirm_password
//                            }
//                            else{
//                                confirm_password = confirm_password_h
//                            }
                                isShowPassword.toggle()
                            
                        }){
                            Image(isShowPassword ? "Eye_On" : "Eye_Off")
                                
                        }
                        .offset(x:0.33 * UIScreen.screenWidth)
                        
                    }

                }
                
                //Text("\(confirm_password)")
            }
            
            Spacer()
                .frame(height:40)
            VStack{
                Button(action:{
                    invalidPassword = !isValidPassword(password)
                    invalidConfirm = !(password == confirm_password)
                    
                    if (!( invalidPassword || invalidConfirm)){
                        
                        parameterPacking()
//                        userData.BasicSignUp(email: email, password: password)
                        //step = 1
                        makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/resetPasswordProcess/", method: "POST", parameters: "email=\(email)&password=\(password)&confirm_password=\(confirm_password)")
//                        status
//                        ret_val
//                        0
//                        密碼修改成功!
//                        -1
//                        該電子郵件不存在或未被使用!
//                        -2
//                        密碼格式錯誤!
//                        -3
//                        兩次密碼輸入不一致!


                    
                    }
                    
                }){
                    Image("LogIn_CHT")
                }
                switch (loginstatus){
                case 0:
                    Text("密碼修改成功!")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    //SignUpControlView( step: 6)
                case -1:
                    Text("該電子郵件不存在或未被使用!")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                case -2:
                    Text("密碼格式錯誤!")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                case -3:
                    Text("兩次密碼輸入不一致!")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                default :
                    Text("測試列")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                }
                
            }
            Spacer()
            
        }
        .padding(.vertical, 40)
        .onAppear(){
            if userData.haveBasicData {
                email = userData.basicData?.email ?? ""
            }
        }
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

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(step: Binding(0))
//    }
//}
