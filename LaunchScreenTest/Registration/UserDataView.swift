//
//  UserDataView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/25.
//

import SwiftUI

struct UserDataView: View {
    
    enum Gender : String{
        case male = "M"
        case female = "F"
        case other = "O"
        case def = ""
    }
    
    
    @EnvironmentObject var internetTask:InternetTask
    @EnvironmentObject var userData: UserData
    
    @Binding var step :Int
    @Binding var dismiss: Bool
    
    @State var first_name = ""
    @State var last_name = ""
    
    @State var dateOfBirth = Date()
    @State var dateInString = "DD/MM/YYYY"
    
    @State var phone = ""
    @State var genderEnum: Gender = .def
    @State var genderOffset :CGFloat = 0
    @State var genderIsTapped = false
    
    @State var isDatePicked: Bool = false
    @State var isShowDatePicker: Bool = false
    
    @State var invalidFName = false
    @State var invalidLName = false
    @State var invalidPhone = false
    
    @State var parameterTest = false
    
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    @State var apiReturn : APIReturn?
    
    var body: some View {
        
        ZStack {
            // Top Roll Including Back Button
            OnBoardBasicView(dismiss: $dismiss, step: $step, context: "用戶資料")
            
            ScrollView {
                VStack(alignment: .center){
                    
                    
                    let width = 0.82*UIScreen.screenWidth
                    
                    // Data TextFields
                    VStack (alignment:.leading, spacing: 20){
                        
                        // Name Roll
                        HStack{
                            let width = 0.4*UIScreen.screenWidth
                            VStack {
                                if(invalidLName){
                                    
                                    Text("姓氏有誤！")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                    
                                    
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: width, height: elementsHeight)
                                        .foregroundColor(elementColor)
                                    TextField("姓氏", text: self.$last_name, onCommit: {
                                        // Name Check
                                        let RegEx = "^[A-Za-z\\u4e00-\\u9fa5]{1,45}$"
                                        invalidLName = !validation(value: last_name, RegEx: RegEx)
                                    })
                                    .frame(width:width-30)
                                    
                                    
                                }
                            }
                            VStack {
                                if(invalidFName){
                                    
                                    Text("名字有誤！")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                    
                                    
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: width, height: elementsHeight)
                                        .foregroundColor(elementColor)
                                    TextField("名字", text: self.$first_name, onCommit: {
                                        // Name Check
                                        let RegEx = "^[A-Za-z\\u4e00-\\u9fa5]{1,45}$"
                                        invalidFName = !validation(value: first_name, RegEx: RegEx)
                                    })
                                    .frame(width: width-30)
                                }
                            }
                            
                        }
                        
                        // Gender Row
                        
                        Text("性別")
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: width, height: elementsHeight)
                                .foregroundColor(elementColor)
                            if genderIsTapped{
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 0.25*UIScreen.screenWidth, height: elementsHeight-10)
                                    .foregroundColor(.white)
                                    .offset(x:genderOffset)
                                    .shadow(color: .gray, radius: 2, x: 0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0)
                                    .animation(.linear)
                                    .transition(.opacity)
                            }
                            
                            HStack{
                                let width = 0.25*UIScreen.screenWidth
                                Button(action:{
                                    withAnimation{
                                        genderIsTapped = true
                                        genderEnum = .male
                                        genderOffset = -0.26*UIScreen.screenWidth
                                    }
                                    
                                }){
                                    Text("男")
                                }
                                .frame(width: width)
                                .foregroundColor(.black)
                                Button(action:{
                                    withAnimation{
                                        genderIsTapped = true
                                        genderEnum = .female
                                        genderOffset = 0
                                    }
                                }){
                                    Text("女")
                                }
                                .frame(width: width)
                                .foregroundColor(.black)
                                
                                Button(action:{
                                    withAnimation{
                                        genderIsTapped = true
                                        genderEnum = .other
                                        genderOffset = 0.26*UIScreen.screenWidth
                                    }
                                }){
                                    Text("其他")
                                }
                                .frame(width: width)
                                .foregroundColor(.black)
                                
                            }
                            
                        }
                        
                        // Date of Birth Roll
                        
                        Text("出生日期")
                        ZStack(alignment:.center){
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: width, height: elementsHeight)
                                .foregroundColor(elementColor)
                            HStack{
                                Text("\(dateInString)")
                                    .foregroundColor(isDatePicked ? .black : .gray)
                                Spacer()
                                Button(action:{
                                    withAnimation{
                                        isShowDatePicker.toggle()
                                    }
                                }){
                                    Image("Calender")
                                }
                            }.frame(width: width-30, height: elementsHeight)
                            
                            
                            
                            
                        }
                        
                        if(invalidPhone){
                            
                            Text("電話格式有誤！")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            
                        }
                        
                        // Phone number roll
                        
                        ZStack{

                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: width, height: elementsHeight)
                                .foregroundColor(elementColor)
                            
                            TextField("電話號碼", text: self.$phone, onCommit:{
                                // number validation
                                
                                invalidPhone = (phone.count != 8)
                                
                            })
                            .frame(width: width-30)
                            .keyboardType(.numberPad)
                            
                        }
                        
                        
                    }
                    
                    Spacer().frame(height:40)
                    
                    VStack{
                        // Next & Skip
                        Group{
                            Button(action:{
                                let RegEx = "^[A-Za-z\\u4e00-\\u9fa5]{1,45}$"
                                invalidFName = !validation(value: first_name, RegEx: RegEx)
                                invalidLName = !validation(value: last_name, RegEx: RegEx)
                                invalidPhone = (phone.count != 8)
                                
                                if (!(invalidPhone || invalidFName || invalidLName)){
                                    
                                    // store data in environment userData
                                    DataHandle()
                                    
                                    step = 2
                                }
                                
                            }){
                                Image("Next_CHT")
                            }
                            Button(action:{
                                DispatchQueue.main.async {
                                    
                                    //pack basicData
                                    parameterPacking()
                                    
                                    //call register API
                                    apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/registerProcess/",
                                                            method: "POST",
                                                            parameters: userData.parameter)
                                    
                                    //call send validation code API
                                    makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/generateAndSendValidationCodeProcess/",
                                                method: "POST", parameters: "email=\(String(describing: userData.basicData!.email))")
                                }
                                step = 3
                            }){
                                Text("略過")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
//                    if (parameterTest){
//                        Text("status = \(apiReturn!.status)")
//                    }

                    
                    
                }
                .padding(.top, 50)
            }
            .padding(.vertical, 0.07*UIScreen.screenHeight)
            
            Rectangle()
                .ignoresSafeArea(edges: .all)
                .foregroundColor(.black)
                .opacity(isShowDatePicker ? 0.8: 0.0)
            if(isShowDatePicker){
                CustomDatePickerView(dateOfBirth: $dateOfBirth,
                                     isShowDatePicker: $isShowDatePicker,
                                     dateInString: $dateInString,
                                     isDatePicked: $isDatePicked
                )
            }
            
        }
        .onAppear{
            if (userData.haveDetailData){
                switch userData.advancedData?.gender{
                case "M":
                    genderEnum = .male
                case "F":
                    genderEnum = .female
                case "O":
                    genderEnum = .other
                default:
                    genderEnum = .def
                }
                
                first_name = userData.advancedData?.first_name ?? ""
                last_name = userData.advancedData?.last_name ?? ""
                phone = userData.advancedData?.phone ?? ""
                
                let subDate = userData.advancedData!.birthday.components(separatedBy: "-")
                dateInString = "\(subDate[2])/\(subDate[1])/\(subDate[0])"
            }
            
        }
        
    }
    
    private func DataHandle(){
        let gender = genderEnum.rawValue
        let date = dateOfBirth.description.components(separatedBy: " ")
        let birthday = date[0]
        
        let advancedData = AdvancedData (first_name: first_name, last_name: last_name, phone: phone, gender: gender, birthday: birthday)
        
        userData.advancedData = advancedData
        
        userData.haveDetailData = true

    }
    private func parameterPacking(){
        var parameter = ""
        var count = 0
        let basicData = userData.basicData!
        let s :[String] = [basicData.email, basicData.password, basicData.confirm_password]
        
        let m  = Mirror(reflecting: basicData)
        for child in m.children{
            parameter.append(child.label ?? "")
            parameter.append("=")
            parameter.append(s[count])
            if count < m.children.count-1{
                parameter.append("&")
                count += 1
            }
        }
        
        userData.parameter = parameter
    }
}

struct CustomDatePickerView: View{
    
    @Binding var dateOfBirth : Date
    @Binding var isShowDatePicker: Bool
    @Binding var dateInString: String
    @Binding var isDatePicked: Bool
    
    var body: some View{
        ZStack {
            let width = 0.82*UIScreen.screenWidth
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: width+30, height: width)
            VStack (alignment: .trailing){
                Button(action:{
                    withAnimation{
                        let date = dateOfBirth.description.components(separatedBy: " ")
                        let subDate = date[0].components(separatedBy: "-")
                        dateInString = "\(subDate[2])/\(subDate[1])/\(subDate[0])"
                        isShowDatePicker = false
                        isDatePicked = true
                    }
                }){
                    Text("完成")
                }.offset(x:-10)
                DatePicker("DD/MM/YYYY",
                           selection: $dateOfBirth,
                           in: ...Date(),
                           displayedComponents: .date)
                    .frame(width: width)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
            }.padding(.top, 30)
        }
    }
}
private func validation(value: String, RegEx: String) -> Bool{
    
    let pred = NSPredicate(format:"SELF MATCHES %@", RegEx)
    
    return pred.evaluate(with: value)
}
struct UserDataView_Previews: PreviewProvider {
    @State (initialValue: 1) var step_init :Int
    static var previews: some View {
        UserDataView(step: .constant(1), dismiss: .constant(true))
            .environmentObject(UserData())
    }
}
