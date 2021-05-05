//
//  LaunchScreenTestApp.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/13.
//

import SwiftUI
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn
import UIKit

@main
struct LaunchScreenTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    //@Published var googlelogin = false
    //@AppStorage("email") var email = ""
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        //userData.basicData?.email =""
        WindowGroup {
            let user = delegate.myUser
            let internetTask = delegate.internetTask
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(user!)
                .environmentObject(UserData())
                .environmentObject(internetTask!)
                .environmentObject(ApplicationState())
                .environmentObject(SystemLanguage())
                .environmentObject(ShopData())
                .onOpenURL(perform: { url in
                    ApplicationDelegate.shared.application(UIApplication.shared, open:url,
                        sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                        
                })
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var myUser : User!
    var internetTask : InternetTask!

  // [END appdelegate_interfaces]
  var window: UIWindow?
    @AppStorage("email") var email = ""
  // [START didfinishlaunching]
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize sign-in
    GIDSignIn.sharedInstance().clientID = "349041949227-2bp84a9l88678334ggb6dddfi5fnj447.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    myUser = User()
    internetTask = InternetTask()
    ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
    
    return true
  }
  // [END didfinishlaunching]
  // [START openurl]
  func application(_ application: UIApplication,
                   open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
  }
  // [END openurl]
  // [START openurl_new]
  @available(iOS 9.0, *)
  func application(_ app: UIApplication,
                   open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    
    ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )

    return GIDSignIn.sharedInstance().handle(url)
  }
  // [END openurl_new]
  // [START signin_handler]
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    //var internetTask = InternetTask
    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      // [START_EXCLUDE silent]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
      // [END_EXCLUDE]
      return
    }
    // Perform any operations on signed in user here.
    let userId = emailcheck(email: user.userID)                  // For client-side use only!
    //let idToken = user.authentication.idToken // Safe to send to the server
    let fullName = user.profile.name
    //let givenName = user.profile.givenName
    //let familyName = user.profile.familyName
    email = emailcheck(email: user.profile.email)
    // [START_EXCLUDE]
    print(fullName,email,userId)
    let apiret = makeNosessionAPICall(url: "https://hkshopu-20700.df.r.appspot.com/user/socialLoginProcess/", method: "POST", parameters: "email=\(email)&google_account=\(userId)")
    let loginstatus = apiret.status
    print("登入",loginstatus)
    
    
    switch (loginstatus){
        case 0:
            print("錯誤")

            //userData.isLoggedIn = true
        case 1:
            //userData.basicData?.email = email
            print("已使用 Google 帳戶登入!")
            myUser.id = apiret.user_id
        //        print("userstatus.id = \(userstatus.id)")
        case -1:
            print("已使用 Google 帳戶註冊!")
            //userData.isLoggedIn = true
            //userData.basicData?.email = email!
        default:
            break
    }
    //return loginstatus
    NotificationCenter.default.post(
      name: Notification.Name(rawValue: "ToggleAuthUINotification"),
      object: nil,
      userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
    // [END_EXCLUDE]
  }
  // [END signin_handler]
  // [START disconnect_handler]
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
            withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    NotificationCenter.default.post(
      name: Notification.Name(rawValue: "ToggleAuthUINotification"),
      object: nil,
      userInfo: ["statusText": "User has disconnected."])
    // [END_EXCLUDE]
  }
  // [END disconnect_handler]
    
    
    
    // Swift //


        
}
