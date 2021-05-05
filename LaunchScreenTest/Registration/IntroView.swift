//
//  IntroView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/24.
//
import Foundation
import SwiftUI
import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn
import UIKit
//api
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
//api

struct IntroView: View {
    @EnvironmentObject var internetTask :InternetTask
    @EnvironmentObject var userData : UserData
    @EnvironmentObject var userStatus : User
    //@Binding var step :Int
    //@ObservedObject var fbmanager = UserLoginManager()
    @State var showLogin = false
    @State var shouldShowSignIn = false
    @State var shouldShowSignUp = false
    @Binding var isintroshow : Bool
    
    var body: some View {
        ZStack {
            
            //toggle login control here
            ZStack{
                
                if shouldShowSignUp {
                    ZStack{
                        SignUpControlView(dismiss: self.$shouldShowSignUp)
                    }
                    .animation(.linear)
                    .transition(.move(edge: .bottom))
                }
                // email signup
                
                
                if shouldShowSignIn {
                    //apple login
                    ZStack{
                        SignInControlView(dismiss: self.$shouldShowSignIn)
                    }
                    .animation(.linear)
                    .transition(.move(edge: .bottom))
                    
                }
            }.zIndex(4.0)
            ZStack{
                Rectangle()
                    .ignoresSafeArea(edges: .all)
                    .foregroundColor(Color(hex: 0xE4FBFF, alpha: 1.0))
                    .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                HStack{
                    Spacer()
                    //DEBUG
                    //Text("\(logginScenario)")
                    Button(action:{
                        DispatchQueue.main.asyncAfter(deadline: .now()){
                            withAnimation{
                                showLogin.toggle()
                                isintroshow.toggle()
                            }
                            
                        }
                        withAnimation{
                            
                        }
                    }){
                        Text("略過")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(hex: 0x48484A))
                    }.padding(40.0)
                }
                .offset(y: -0.42*UIScreen.screenHeight)
                .ignoresSafeArea( edges: .top)
                .zIndex(3.0)
                
                VStack(alignment: .center, spacing: 0){
                    
                    
                    ImageSwapView()
                        .frame(height:0.4*UIScreen.screenHeight)
                        .padding(.top, 40)
                    
                    if showLogin {
                        LogginView(shouldShowSignIn: self.$shouldShowSignIn, shouldShowSignUp: self.$shouldShowSignUp)
                            
                            .offset(y:50)
                            .ignoresSafeArea(edges: .all)
                            .animation(.spring())
                            .transition(.move(edge: .bottom))
                    }
                }.zIndex(2.0)
                .padding(.top, 50.0)
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation{
                        showLogin.toggle()
                    }
                }
                
            }
        }
        
    }
}

struct ImageSwapView: View{
    @EnvironmentObject var language: SystemLanguage
    
    @State var dragOffset :CGFloat = 0
    @State var imageIndex = 0
    @State var forward = true
    @State var percentage :[CGFloat] = [100.0, 0.0, 0.0, 0.0]
    
    let maxIndex = 2
    
    var body: some View{
        
        let myGesture = DragGesture()
            .onChanged { value in
                let distance = value.translation.width
                
                self.dragOffset += distance/100
                if distance < 0 {
                    forward = true
                }
                else{
                    forward = false
                }
                withAnimation{
                    percentage[imageIndex] -= abs(distance)/200
                    if forward {
                        if imageIndex != maxIndex {
                            percentage[imageIndex+1] += abs(distance)/200
                        }
                        
                    }
                    else{
                        if imageIndex != 0 {
                            percentage[imageIndex-1] += abs(distance)/200
                        }
                    }
                }
                
            }
            .onEnded{ value in
                
                DispatchQueue.main.async {
                    withAnimation{
                        
                        if (value.translation.width < -100){
                            
                            percentage [imageIndex] = 0
                            if (imageIndex != maxIndex){
                                imageIndex += 1
                            }
                            percentage [imageIndex] = 100
                            self.dragOffset = 0
                            
                        }
                        if (value.translation.width>100){
                            
                            percentage[imageIndex] = 0
                            if (imageIndex != 0){
                                imageIndex -= 1
                                
                            }
                            percentage[imageIndex] = 100
                            
                            self.dragOffset = 0
                            
                        }
                        
                        else{
                            
                            percentage[imageIndex] = 100.0
                            if forward {
                                if imageIndex != maxIndex {
                                    percentage[imageIndex+1] = 0
                                }
                                
                            }
                            else{
                                if imageIndex != 0 {
                                    percentage[imageIndex-1] = 0
                                }
                                
                            }
                            self.dragOffset = 0
                            
                        }
                    }
                }
                
            }
        
        let myTransition = AnyTransition.asymmetric(insertion: AnyTransition.move(edge: forward ? .trailing : .leading), removal: AnyTransition.move(edge: forward ? .leading : .trailing))
        
        let size = 0.3*UIScreen.screenHeight
        
        VStack{
            switch(imageIndex){
            case 0:
                VStack(alignment: .center, spacing: 3){
                    Image("介紹_1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)
                    VStack (spacing: 8){
                        Text("開店好簡單 什麼都賣等你來")
                            .font(.custom("Roboto-Bold", size: 18))
                        Text("不論你是買家、商家或是創業家，一鍵上手")
                            .font(.custom("Roboto-Regular", size: 14))
                    }
                }.gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
                
            case 1:
                VStack{
                    Image("介紹_2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)
                    VStack (spacing: 8){
                        Text("我的店鋪 隨時隨地不NG")
                            .font(.custom("Roboto-Bold", size: 18))
                        Text("無時無刻管理你的店鋪，不再受限地區與時差")
                            .font(.custom("Roboto-Regular", size: 14))
                    }
                }
                .gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
            case 2:
                
                VStack (spacing: 16){
                    Image("介紹_3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)
                    VStack (spacing: 8){
                        Text("簡單明瞭 你我都是行銷高手")
                            .font(.custom("Roboto-Bold", size: 18))
                        Text("導引頁面清楚，「店匯」帶你輕鬆搞定所有設定")
                            .font(.custom("Roboto-Regular", size: 14))
                    }
                    
                }
                .gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
            //            case 3:
            //
            //                VStack {
            //                    Rectangle()
            //                        .frame(width:size, height: size)
            //                        .foregroundColor(.green)
            //                        .gesture(myGesture)
            //                        .offset(x:dragOffset)
            //                        .transition(myTransition)
            //                    Text("Image 4")
            //                        .font(.title)
            //                }
            //                .gesture(myGesture)
            //                .offset(x:dragOffset)
            //                .transition(myTransition)
            //                .drawingGroup()
            default:
                EmptyView()
            }
            Spacer()
                .frame(height:16)
            HStack{
                let focusColor = Color(hex:0x1DBCCF)
                let normalColor = Color(hex:0xC4C4C4)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width:10+0.4*percentage[0], height:10)
                    .foregroundColor(imageIndex==0 ? focusColor : normalColor)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width:10+0.4*percentage[1], height:10)
                    .foregroundColor(imageIndex==1 ? focusColor : normalColor)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width:10+0.4*percentage[2], height:10)
                    .foregroundColor(imageIndex==2 ? focusColor : normalColor)
                
                //                RoundedRectangle(cornerRadius: 5)
                //                    .frame(width:10+0.4*percentage[3], height:10)
                //                    .foregroundColor(.white)
                
            }
            
            //            Text("\(percentage[0]), \(percentage[1]),\(percentage[2]), \(percentage[3])")
        }
        .padding(.top, 40)
    }
}

struct LogginView: View {
    @Binding var shouldShowSignIn :Bool
    @Binding var shouldShowSignUp :Bool
    @EnvironmentObject var internetTask : InternetTask
    @EnvironmentObject var userstatus : User
    //login
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("FBID") var FBID = ""
    @AppStorage("APID") var APID = ""
    @State var loginstatus = Int()
    @State var manager = LoginManager()
    @State var apiloginreturn : APIloginReturn?
    @State var buttonSize  = CGSize.zero
    //
    //@Binding var step :Int
    //@Binding var dismiss: Int
    
    let width = UIScreen.screenWidth
    let heght = 0.6 * UIScreen.screenHeight
    var body: some View{
        ScrollView{
        ZStack (alignment: .top){
            ZStack(alignment: .bottom){
                RoundedRectangle(cornerRadius: 48.0)
                    .frame(width: width, height: heght)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(width:width, height: 48.0)
                    .foregroundColor(.white)
            }.ignoresSafeArea(edges: .all)
            .drawingGroup()
            
            VStack(spacing: 16.0){
                Button(action: {
                    withAnimation{
                        shouldShowSignUp = true
                    }
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(hex:0x1DBCCF))
                        HStack(spacing:4){
                            Image("mail_s")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                            //Spacer()
                            Text("EMAIL 註冊")
                                .foregroundColor(.white)
                                .font(.custom("Roboto-Medium", size: 16))
                                .offset(x:12)
                            Spacer()
                        }.frame(width: 0.46*UIScreen.screenWidth)
                    }
                    
                }
                .frame( height: 50)
                
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
                                    
                                    apiloginreturn = makeloginAPICall(internetTask: self.internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/socialLoginProcess/", method: "POST", parameters: "email=\(email)&facebook_account=\(FBID)")
                                    print("email =\(email) FBID = \(FBID)")
                                    userstatus.id = optioanlInt(int: apiloginreturn!.user_id)
                                    userstatus.isLoggedIn = true
                                    print("userstatus.id = \(userstatus.id),loggin = \(userstatus.isLoggedIn)")
                                }
                            }
                        }
                    }
                    //                    withAnimation{
                    //                        loginScenario = 2
                    //                    }
                }){
                    //                    Image("Facebook LogIn")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
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
                .frame(height: 50)
                Button(action: {
                    
                    GIDSignIn.sharedInstance()?.presentingViewController=UIApplication.shared.windows.first?.rootViewController
                    GIDSignIn.sharedInstance()?.signIn()
                    print(email)
                }){
                    //                    Image("Google LogIn")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
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
                .frame(height: 50)
                
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
                                apiloginreturn = makeloginAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/socialLoginProcess/", method: "POST", parameters: "email=\(Apemail)&apple_account=\(APID)")
                                userstatus.id = optioanlInt(int: apiloginreturn!.user_id)
                                userstatus.isLoggedIn = true
                                print("userstatus.id = \(userstatus.id),loggin = \(userstatus.isLoggedIn)")
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
                
                .frame( height: 50)
                
                
                //                Button(action: {
                //                    withAnimation{
                //                        loginScenario = 4
                //
                //                    }
                //                }){
                //                    Image("Apple LogIn")
                //                }
                HStack{
                    Text("已經是會員了嗎？")
                        .foregroundColor(Color(hex:0x48484A))
                    Button(action:{
                        withAnimation{
                            shouldShowSignIn = true
                            
                        }
                    }){
                        Text("登入")
                            .fontWeight(.heavy)
                            .foregroundColor(Color(hex:0x48484A))
                            .underline()
                    }
                }.offset(y:10)
            }
            .offset(y:40)
            .frame(width: UIScreen.screenWidth*0.7)
            //            switch (apiloginreturn?.status){
            //            case 0:
            //                Text("錯誤")
            //                    .fontWeight(.bold)
            //                    .foregroundColor(.red)
            //                //userData.isLoggedIn = true
            //            case 1:
            //                Text("已使用 Google 帳戶登入!")
            //                    .fontWeight(.bold)
            //                    .foregroundColor(.red)
            //                Text("email:\(email) , userid = \(userstatus.id!)")
            //
            //            case -1:
            //                Text("已使用 Google 帳戶註冊!")
            //                    .fontWeight(.bold)
            //                    .foregroundColor(.red)
            //                Text("email:\(email) , userid = \(userstatus.id!)")
            //            case 2:
            //                Text("已使用 Facebook 帳戶登入!")
            //                .fontWeight(.bold)
            //                .foregroundColor(.red)
            //                Text("email:\(email) , userid = \(userstatus.id!)")
            //            case -2:
            //                Text("已使用 Facebook 帳戶註冊!")
            //                .fontWeight(.bold)
            //                .foregroundColor(.red)
            //                Text("email:\(email) , userid = \(userstatus.id!)")
            //            case 3:
            //                Text("已使用 Apple 帳戶登入!")
            //                .fontWeight(.bold)
            //                .foregroundColor(.red)
            //                Text("email:\(userstatus.profile!.email) , userid = \(userstatus.id!)")
            //            case -3:
            //                Text("已使用 Apple 帳戶註冊!")
            //                .fontWeight(.bold)
            //                .foregroundColor(.red)
            //                Text("email:\(userstatus.profile!.email) , userid = \(userstatus.id!)")
            //            default :
            //                Text("測試列")
            //                .fontWeight(.bold)
            //                .foregroundColor(.red)
            //            }
            
        }
        }
    }
}

struct ViewSizeGeometryGetterView: View {
    
    //@Binding var ViewHeightKey:CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            let value = geometry.frame(in: .local).size
            
            Color.clear.preference(key: ViewSizeKey.self, value: value  )
        }
    }
}
