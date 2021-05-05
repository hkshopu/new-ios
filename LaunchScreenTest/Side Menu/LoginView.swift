//
//  Sign&LoginView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/1/29.
//

import SwiftUI

struct LoginView: View {
    //@State var isLoggedIn = false
    
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.white)
            VStack{
                //loginHeader()
                loginBody()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
struct loginHeader: View {
    var body: some View{
        GeometryReader{ geometry in
            VStack{
            }
        }
    }
    
}
struct loginBody: View {
    @EnvironmentObject var UserSettings: UserSettings
    @State var EmailAddress = ""
    @State var Password = ""
    var body: some View{
        GeometryReader{ geometry in
                    VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        VStack(alignment: .center){
                            Text("Test login")
                                Spacer()
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            Text("Email")
                                .font(.headline)
                            TextField("type in email", text: $EmailAddress)
                                .padding()
                            SecureTextField(label: "Password", placeHolder: "password a-z,A-Z,0-9,and special", text: $Password).keyboardType(.asciiCapable)
                            
                            Button(action: {
                                print("login")
                                if let errorMessage = self.validView() {
                                    print(errorMessage)
                                    return
                                }
                                print ("successfully")
                                //Alert(title: Text("error!"), message:Text("Sign in!"), dismissButton:.default(Text("OK")))

                                //test 123456Ab?
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width:0.3*geometry.size.width, height: 0.3*geometry.size.height)
                                        .foregroundColor(.black)
                                    Text("Login")
                                        .foregroundColor(.white)
                                }
                            }).padding().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    }).padding()
        }.padding().frame(height:0.3*UIScreen.screenHeight)
    }
    
    private func validView() -> String? {

        if EmailAddress != UserSettings.EmailAddress{
            return "email error"
        }
        
        if Password != UserSettings.Password{
            return "password error"
        }
        // Do same like other validation as per needed
        
        return nil
    }
//    private func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//    private func isValidPassword(_ password: String) -> Bool {
//        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
//        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//        return passwordPred.evaluate(with: password)
//    }

}

