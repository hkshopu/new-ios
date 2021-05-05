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

struct SignInView: View {
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("FBID") var FBID = ""
    @AppStorage("APID") var APID = ""
    
    @EnvironmentObject var userData :UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @Binding var step :Int
    @Binding var dismiss: Bool
    
    @State var loginstatus = Int()
    @State var manager = LoginManager()
    
    //@State var email = ""
    @State var password = ""
//    {
//        didSet{
//            invalidPassword = !isValidPassword(password)
//        }
//    }
    @State var confirm_password = ""
    @State var isShowPassword = false
    
    @State var invalidEmail = false
    @State var unuseEmail = false
    @State var SocailEmail = false
    
    
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    @State var apiReturn : APIReturn?
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
                    HStack(alignment:.center, spacing: 32){
//                        Button(action:{}){
//                            Image("Google_LogIn_s")
//                        }
//                        Button(action:{}){
//                            Image("Facebook_LogIn_s")
//                        }
//                        Button(action:{}){
//                            Image("Apple_LogIn_s")
//                        }
                        VStack(spacing: 16.0){
                            Button(action: {
                                
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
            //                    withAnimation{
            //                        loginScenario = 2
            //                    }
                            }){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(Color(hex:0x1977F3))
                                    HStack(spacing:4){
                                        Spacer()
                                        Image("Facebook_LogIn_s")
                                            .resizable()
                                            .frame(width:23, height:23)
                                            .offset(x:5, y:-4)
                                        //Spacer()
                                        Text("以FACEBOOK帳號繼續")
                                            .foregroundColor(.white)
                                            .font(.custom("Roboto-Medium", size: 16))
                                            .offset(x:12)
                                        Spacer()
                                    }//.frame(width: 0.46*UIScreen.screenWidth)
                                }
                            }
                            .frame(width: UIScreen.screenWidth*0.7, height: 50)

                            Button(action: {

                                GIDSignIn.sharedInstance()?.presentingViewController=UIApplication.shared.windows.first?.rootViewController
                                GIDSignIn.sharedInstance()?.signIn()

                            }){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(Color(hex:0xF4511E))
                                    HStack(spacing:4){
                                        Spacer()
                                        Image("Google_LogIn_s")
                                            .resizable()
                                            .frame(width:30, height:30)
                                        //Spacer()
                                        Text("以GOOGLE帳號繼續")
                                            .foregroundColor(.white)
                                            .font(.custom("Roboto-Medium", size: 16))
                                        Spacer()
                                    }//.frame(width: 0.46*UIScreen.screenWidth)
                                }
                                    
                            }
                            .frame(width: UIScreen.screenWidth*0.7, height: 50)
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
                                                    let Apemail = emailcheck(email: email)
                                                    loginstatus = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/socialLoginProcess/", method: "POST", parameters: "email=\(Apemail)&apple_account=\(APID)").status

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
                            .frame(width: UIScreen.screenWidth*0.7, height: 50)
                            
                        }//.offset(y:40)
                    }
                    //.padding()
                    //.offset(y: -20)
                }.padding()
                Spacer()
                Text("或用電子郵件登入")
                    .font(.body)
                    .foregroundColor(Color(hex: 0x8E8E93, alpha: 1.0))
                Spacer()
                    //.frame(height: 0.025*UIScreen.screenHeight)
                
                ScrollView {
                    VStack (alignment:.leading, spacing: 20){
                        if invalidEmail {
                            Text("電子郵件格式錯誤")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        if unuseEmail {
                            Text("該電子郵件未被使用!")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        if SocailEmail {
                            Text("該電子郵件已經註冊且只可透過社群登入!")
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
                                          })
                                    .frame(width:width-30)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                
                                
                            }
                            
                        }
                        
                    }
                    Spacer()
                        .frame(height: 16)
                    VStack{
                        Button(action:{
                            invalidEmail = !isValidEmail(email)
                            //invalidPassword = !isValidPassword(password)
                            //invalidConfirm = !(password == confirm_password)
                            
                            if ((!invalidEmail)){
                                //api call https://hkshopu-20700.df.r.appspot.com/user/validateEmailProcess/
                                apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/checkEmailIsAllowedLoginProcess/", method: "POST", parameters:String(describing:"email=\(email)"))
                                switch (apiReturn?.status) {
                                case 0:
                                    print("email pass")

                                    print(email,password,userData.basicData?.email,userData.basicData?.password)
                                    parameterPacking()
                                    //SignInPassWord(step: self.$step, dismiss: self.$dismiss)
                                    step = 5
                                //go to password
                                //case -3
                                case -1:
                                    unuseEmail = true
                                    print("該電子郵件未被使用!")
                                    SocailEmail = false
                                case -2:
                                    SocailEmail = true
                                    print("該電子郵件已經註冊且只可透過社群登入!")
                                    unuseEmail = false
                                default:
                                    break
                                }
                                
//                                status
//                                ret_val
//                                0
//                                該電子郵件可正常登入!
//                                -1
//                                該電子郵件未被使用!
//                                -2
//                                該電子郵件只可透過社群登入!


                            }
                            
                        }){
                            Image("Next_CHT")
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(step: .constant(0), dismiss: .constant(true))
            .environmentObject(UserData())
    }
}
