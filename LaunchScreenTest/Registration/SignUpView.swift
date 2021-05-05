//
//  SignUpView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/26.
//

import Foundation
import SwiftUI
import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn
import UIKit

struct SignUpView: View {
    
    @EnvironmentObject var userData :UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @AppStorage("logged") var logged = false
    @State var loginstatus = Int()
    @State var manager = LoginManager()
    @AppStorage("FBID") var FBID = ""
    @AppStorage("APID") var APID = ""
    
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
    @State var isEmailUsed = false
    @State var invalidPassword = false
    @State var invalidConfirm = false
    
    @State var showProtocolView = false
    
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    //var user : User
    
    var body: some View {
        ZStack {
            
            OnBoardBasicView(dismiss: $dismiss, step: $step, context: "用戶資料")
            .onAppear(){
                if userData.haveBasicData {
                    email = userData.basicData?.email ?? ""
                }
            }
            
            VStack (alignment: .center, spacing: 15){
                
                //Social Login
                VStack{
                    HStack(alignment:.center, spacing: 32){
                        Button(action:{
                            GIDSignIn.sharedInstance()?.presentingViewController=UIApplication.shared.windows.first?.rootViewController
                            GIDSignIn.sharedInstance()?.signIn()
                        }){
                            Image("Google_LogIn_s")
                        }
                        Button(action:{
                            // 加抓user ID for json 傳送
                            if logged{
                                manager.logOut()
                                email = ""
                                logged = false
                            }
                            else{
                                manager.logIn(permissions: ["public_profile","email"], from: nil){
                                    (result, err) in
                                    if err != nil{
                                        print(err!.localizedDescription)
                                        return
                                    }
                                    if !result!.isCancelled {
                                        //success
                                        logged = true
                                        //get details
                                        let requst = GraphRequest(graphPath: "me",parameters: ["fields" : "id,email"])
                                        requst.start { (_, res, _) in
                                            //return as dictinoary
                                            
                                            guard let profiledata = res as? [String : Any]
                                            else{return}
                                            //
                                            
                                            email = profiledata["email"] as! String
                                            FBID = profiledata["id"] as! String
                                            
                                            loginstatus = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/socialLoginProcess/", method: "POST", parameters: "email=\(email)&facebook_account=\(FBID)").status
                                            
                                            print("email =\(email) FBID = \(FBID)")
                                        }
                                    }
                                }
                            }
                        }){
                            Image("Facebook_LogIn_s")
                        }
                        SignInWithAppleButton(
                                    onRequest: { request in
                                        request.requestedScopes = [.fullName, .email]
                                    },
                                    onCompletion: { result in
                                        
                                        switch result {
                                        case .success(let authResults):
                                            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                                let userId = appleIDCredential.user
                                                let identityToken = appleIDCredential.identityToken
                                                let authCode = appleIDCredential.authorizationCode
                                                let email = appleIDCredential.email
                                                let givenName = appleIDCredential.fullName?.givenName
                                                let familyName = appleIDCredential.fullName?.familyName
                                                let state = appleIDCredential.state
                                                print(appleIDCredential.email)
                                                // Here you have to send the data to the backend and according to the response let the user get into the app.
                                            }
                                            print("success")
                                            switch authResults.credential {
                                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                                print("getEmail",appleIDCredential.email, "UserID",appleIDCredential.user)
                                                
                                                let APID = appleIDCredential.user
                                                guard let email = appleIDCredential.email
                                                else {
                                                    return
                                                }
                                                //loginstatus = APSocailMedialogin(email, APID)

                                            default:
                                                break
                                            }
                                            //print("email =\(email) APID = \(APID)")
          
                                        case .failure(let error):
                                            print("failure", error)
                                                                            }
                                    }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(width: 44, height: 44)
                        //.offset(x: 30, y: 0)
                        .cornerRadius(44)

//                        .clipShape(Circle()
//                                    .offset(x:-30)
//                        )
                        //.clipShape(<#T##shape: Shape##Shape#>)
                            //Image("Apple_LogIn_s")
                        
                        
                    }
                    Text("或用電子郵件註冊")
                        .font(.body)
                        .foregroundColor(Color(hex: 0x8E8E93, alpha: 1.0))
                }
                
                Spacer()
                    .frame(height: 0.025*UIScreen.screenHeight)
                
                ScrollView {
                    VStack (alignment:.leading, spacing: 20){
                        if invalidEmail {
                            Text("電子郵件格式錯誤")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        if isEmailUsed{
                            Text("電子郵件已被使用")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        HStack{
                            let width = 0.82*UIScreen.screenWidth
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: width, height: elementsHeight)
                                    .foregroundColor(elementColor)
                                TextField("電子郵件地址",
                                          text: self.$email,
                                          onCommit:{
                                            invalidEmail = !isValidEmail(email)
                                            DispatchQueue.main.async {
                                                let apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/checkEmailExistsProcess/", method: "POST", parameters: "email=\(email)")
                                                if (apiReturn.status == -1){
                                                    isEmailUsed = true
                                                }
                                            }
                                          })
                                    .frame(width:width-30)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                
                                
                            }
                            
                        }
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
                                    isShowPassword.toggle()
                                    
                                }){
                                    Image(isShowPassword ? "Eye_On" : "Eye_Off")
                                    
                                }
                                .offset(x:0.33 * UIScreen.screenWidth)
                                
                            }
                            
                        }
                        Text("密碼格式必須包括大小階英文、數字及符號")
                            .foregroundColor(Color(hex:0x8E8E93))
                            .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                            .offset(x:15, y:-10)
                        //Text("\(confirm_password)")
                        
                        
                    }
                    Spacer()
                        .frame(height: 16)
                    VStack{
                        Button(action:{
                            invalidEmail = !isValidEmail(email)
                            invalidPassword = !isValidPassword(password)
                            invalidConfirm = !(password == confirm_password)
                            
                            if (!(invalidEmail || invalidPassword || invalidConfirm)){
                                
                                DataHandle()
                                
                                DispatchQueue.main.async {
                                    let apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/checkEmailExistsProcess/", method: "POST", parameters: "email=\(email)")
                                    if (apiReturn.status == -1){
                                        isEmailUsed = true
                                    }
                                    else{
                                        step = 1
                                    }
                                }
                                
                            }
                            
                        }){
                            Image("Next_CHT")
                        }
                        HStack{
                            
                            Text("註冊帳號代表您同意")
                                .foregroundColor(Color(hex: 0x8E8E93, alpha: 1.0))
                                .font(.footnote)
                            Button(action:{
                                showProtocolView.toggle()
                            }){
                                Text("<用戶協議條款>")
                                    .foregroundColor(Color(hex: 0x1DBCCF, alpha: 1.0))
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .padding(.bottom, 0.07*UIScreen.screenHeight)
            }
            .padding(.top, 0.2*UIScreen.screenHeight)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showProtocolView, content: {
            ProtocolView(dismiss: $showProtocolView)
        })
    }
    private func DataHandle(){
        let basicData = BasicData(email: email, password: password, confirm_password: confirm_password)
        
        userData.basicData = basicData
        
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(step: .constant(0), dismiss: .constant(false))
            .environmentObject(UserData())
    }
}
