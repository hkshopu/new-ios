//
//  Sign&LoginView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/1/29.
//

import SwiftUI

struct Sign_LoginView: View {
    //@State var isLoggedIn = false
    
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.gray)
            VStack{
                //SigninHeader()
                SigninBody()
            }
        }
    }
}

struct Sign_LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Sign_LoginView()
    }
}
struct SigninHeader: View {
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Text("Sign in with")
                HStack{
                    Button(action: {}, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:0.3*geometry.size.width, height: 0.15*geometry.size.height)
                                .foregroundColor(.white)
                            Text("AP")
                                .foregroundColor(.black)
                        }
                    })
                    Button(action: {}, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:0.3*geometry.size.width, height: 0.15*geometry.size.height)
                                .foregroundColor(.white)
                            Text("FB")
                                .foregroundColor(.black)
                        }
                    })
                    Button(action: {}, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:0.3*geometry.size.width, height: 0.15*geometry.size.height)
                                .foregroundColor(.white)
                            Text("GG")
                                .foregroundColor(.black)
                        }
                    })
                }

            }
        }
        .padding().frame(height:0.2*UIScreen.screenHeight)

    }
    
}
struct SigninBody: View {
    @EnvironmentObject var UserSettings: UserSettings
    @State var isLoggedIn = false
    @State var Username = ""
    @State var EmailAddress = ""
    @State var Password = ""
    //16位英文數字鍵盤上之必須包含大小寫數字及普通符號
    @State var Passwordconfirm = ""
    @State var FirstName = ""
    @State var LastName = ""
    @State var Gender = ""
    @State var DayofBirth = Date()
    @State var MobilePhoneArea = ""
    //港區
    @State var MobilePhone = ""
    //八位純數字文字
    @State var Address = ""
    @State var check = Bool()
    @State var alertstatus = false
    @State var alertext = ""
    var body: some View {
        GeometryReader{ geometry in
        List{
                ScrollView(){
                    VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        Text("Basic Information")
                        VStack{
                            
                            LabelTextField(label: "UserName", placeHolder: "fill the name", text: $Username)
                            LabelTextField(label: "EmailAddress", placeHolder: "email", text: $EmailAddress).keyboardType(.emailAddress)
                            SecureTextField(label: "Password", placeHolder: "password a-z,A-Z,0-9,and special", text: $Password).keyboardType(.asciiCapable)
                            SecureTextField(label: "Confirm Password", placeHolder: "password", text: $Passwordconfirm).keyboardType(.asciiCapable)
                            //過濾password 暫時限制numberpad
                            
                            //需要formatter .fillter(0123456789)+
                        }.padding()
                        Text("Optional")
                        VStack(alignment: .leading){
                            LabelTextField(label: "First Name", placeHolder: "first name", text: $FirstName)
                            LabelTextField(label: "Last Name", placeHolder: "Last", text: $LastName)
                            Picker(selection:$Gender, label: Text("Gender"), content: {
                                Text("Male").tag(1)
                                Text("Female").tag(0)
                            })
                            .frame(height: 30.0).clipped()

                            DatePicker("Day of Birth", selection: $DayofBirth, displayedComponents: .date).padding(.leading)
                            
                            Text("MobileNumber")
                                .padding(.leading)
                            HStack{
                                TextField("area", text: $MobilePhoneArea)
                                TextField("8位電話號碼",value: $MobilePhoneArea,formatter: NumberFormatter()).keyboardType(.numberPad)
                            }.padding()
                            
                            VStack{
                                
                                Button(action: {
                                    print("sign in")
                                    if let errorMessage = self.validView() {
                                        print(errorMessage)
                                        alertstatus = true
                                        return
                                    }
                                    //Alert(title: Text("error!"), message:Text("Sign in!"), dismissButton:.default(Text("OK")))
                                    UserSettings.Username = Username
                                    UserSettings.EmailAddress = EmailAddress
                                    UserSettings.Password = Password
                                    print("UserName = \(UserSettings.Username)")
                                    print("EmailAddress = \(UserSettings.EmailAddress)")
                                    print("Password = \(UserSettings.Password)")
                                    
                                    //test 123456Ab?
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width:0.3*geometry.size.width, height: 0.1*geometry.size.height)
                                        .foregroundColor(.black)
                                    Text("SignIn")
                                        .foregroundColor(.white)
                                }
                            }).padding()
                            }
                        }.padding()
                        


                        
                    }).padding()
            }
        }
        }
    }
    private func validView() -> String? {
        if self.Username.count < 4 {
            return "at last 4 chr"
        }
        if EmailAddress.isEmpty {
            return "Email is empty"
        }
        
        if !self.isValidEmail(EmailAddress) {
            return "Email is invalid"
        }
        
        if Password.isEmpty {
            return "Password is empty"
        }
        
        if self.Password.count < 8 {
            return "Password should be 8 character long"
        }
        
        if self.Password != self.Passwordconfirm
        {
            return "Password Confirm error"
        }
        if isValidEmail(EmailAddress) == false{
            return "email error"
        }
        
        if isValidPassword(Password) == false{
            return "密碼必須含有至少一個大小寫字母,一個數字以及一個符號"
        }
        // Do same like other validation as per needed
        
        return nil
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

}

struct LabelTextField : View {
    var label: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField(placeHolder, text: $text)
                .padding(.all, 1.0)
        }.padding().frame(height: 50.0)
    }
}
struct SecureTextField : View {
    var label: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            SecureField(placeHolder, text: $text)
                .padding(.all, 1.0)
                
        }.padding().frame(height: 50.0)
        
    }
}

struct EyeImage: View {
    
    //1
    private var imageName: String
    init(name: String){
        self.imageName = name
    }
    
    //2
    var body: some View {
        Image(imageName)
            .resizable()
            .foregroundColor(.black)
            //.frame()
    }
    
}

class UserSettings: ObservableObject{
    //全域先暫時放這裡
    
    @Published var isLoggedIn = false
    @Published var UserIDNum = Int(1)
    @Published var Username = ""
    @Published var EmailAddress = ""
    @Published var Password = ""
    //16位英文數字鍵盤上之必須包含大小寫數字及普通符號
    @Published var Passwordconfirm = ""
    @Published var FirstName = ""
    @Published var LastName = ""
    @Published var Gender = ""
    @Published var DayofBirth = Date()
    @Published var MobilePhoneArea = ""
    //港區
    @Published var MobilePhone = ""
    //八位純數字文字
    @Published var Address = ""
    
    //list 順序 ID email password nickname fullname gender daybirth PhoneNumber+area
    //還未整理
}
