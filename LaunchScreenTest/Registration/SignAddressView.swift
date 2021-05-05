//
//  AddressView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/3/2.
//

import SwiftUI

struct SignAddressView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @Binding var step :Int
    @Binding var dismiss: Bool
    
    @State var address = [String](repeating:"", count: 7)
    
    @State var apiReturn :APIReturn?
    @State var isAdressHaveEmpty = false
    @State var test = ""
    
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    
    private let territory :[String] = ["香港", "九龍", "新界"]
    var body: some View {
        ZStack {
            
            OnBoardBasicView(dismiss: $dismiss, step: $step, context: "用戶資料")
            
            VStack {
                Group{
                Spacer()
                    .frame(height:0.2*UIScreen.screenHeight)
//                Button(action: {addressPacking()}, label: {
//                    Text("parameter = \(test)")
//                })
                }
                Text("請輸入您的郵寄地址")
                
                if isAdressHaveEmpty {
                    Text("地址欄位有誤！")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                HStack{
                    let width = 0.4*UIScreen.screenWidth
                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: width, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("地域", text: $address[0])
                                
                            Spacer()
//                            Text("地域")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Button(action: {}){
//                                Image("Chevron_Down")
//                            }
                            
                        }.frame(width: width-30)
                    }
                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: width, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("地區", text: $address[1])
                                
                            Spacer()
//                            Text("地區")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Button(action: {}){
//                                Image("Chevron_Down")
//
//                            }
                        }.frame(width: width-30)
                    }
                }
                HStack{

                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 0.5*UIScreen.screenWidth, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("街道名稱", text: $address[2])
                                
                            Spacer()
//                            Text("地域")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Button(action: {}){
//                                Image("Chevron_Down")
//                            }
                            
                        }.frame(width: 0.5*UIScreen.screenWidth-30)
                    }
                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 0.3*UIScreen.screenWidth, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("街道門牌", text: $address[3])
                                .keyboardType(.numberPad)
                                
                            Spacer()
//                            Text("地區")
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Button(action: {}){
//                                Image("Chevron_Down")
//
//                            }
                        }.frame(width: 0.3*UIScreen.screenWidth-30)
                    }
                }
                ZStack{
                    let width = 0.82*UIScreen.screenWidth
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: width, height: elementsHeight)
                        .foregroundColor(elementColor)
                    HStack{
                        TextField("其他地址", text: $address[4])
                            
                        Spacer()
//                        Button(action: {}){
//                            Image("Chevron_Down")
//
//                        }
                    }
                    .frame(width: width-30)
                }
                HStack{
                    let width = 0.4*UIScreen.screenWidth
                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: width, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("樓層", text: $address[5])
                                .keyboardType(.numberPad)
                            Spacer()

                            
                        }.frame(width: width-30)
                    }
                    ZStack(alignment:.center){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: width, height: elementsHeight)
                            .foregroundColor(elementColor)
                        
                        HStack {
                            TextField("室", text: $address[6])
                                .keyboardType(.numberPad)
                            Spacer()

                        }.frame(width: width-30)
                    }
                }
                
                Spacer().frame(height:40)
                
                VStack{
                    Button(action:{
                        //Check if all blanks are filled
                        
                        isAdressHaveEmpty = false
                        
                        for i in 0...3{
                            if address[i].isEmpty{
                                isAdressHaveEmpty = true
                                break
                            }
                            
                        }
                        if(!isAdressHaveEmpty){
                            DispatchQueue.main.async {
                                
                                parameterPacking()
                                addressPacking()
                                
                                print(userData.parameter)
                                // call registeration API
                                apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/registerProcess/",
                                                        method: "POST",
                                                        parameters: userData.parameter)

                               makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/generateAndSendValidationCodeProcess/",
                                            method: "POST", parameters: "email=\(String(describing: userData.basicData?.email))")

                            }
                            step = 3
                        }
                        
                    }){
                        Image("Next_CHT")
                    }
                    Button(action:{
                        DispatchQueue.main.async {
                            
                            // packing basicData and advancedData only
                            parameterPacking()
                            
                            // call registeration API
                            apiReturn = makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/registerProcess/",
                                                    method: "POST",
                                                    parameters: userData.parameter)
                            // cal email validation API
                           makeAPICall(internetTask: internetTask,url: "https://hkshopu-20700.df.r.appspot.com/user/generateAndSendValidationCodeProcess/",
                                        method: "POST", parameters: "email=\(String(describing: userData.basicData?.email))")

                        }
                        step = 3
                    }){
                        Text("略過")
                            .foregroundColor(.gray)
                    }

                }
                Spacer()
            }
        }
        .onAppear(){
            if userData.haveAddressData {
                address[0] = userData.addressData?.region ?? ""
                address[1] = userData.addressData?.district ?? ""
                address[2] = userData.addressData?.street_name ?? ""
                address[3] = userData.addressData?.street_no ?? ""
                address[4] = userData.addressData?.address ?? ""
                address[5] = userData.addressData?.floor ?? ""
                address[6] = userData.addressData?.room ?? ""
            }
        }
    }
    
    private func addressPacking(){
        
        var addressParameter = ""
        let addressData = AddressData(region: address[0] , district: address[1], street_name: address[2], street_no: address[3], address: address[4], floor: address[5], room: address[6])
        let s = ["region", "district", "street_name", "street_no", "address", "floor", "room"]
        var count = 0
        
        for i in s{
            
            addressParameter.append("&")
            addressParameter.append(i)
            addressParameter.append("=")
            addressParameter.append(address[count])
            switch count {
            case 3:
                addressParameter.append("號")
            case 5:
                if (address[count] != ""){
                    addressParameter.append("樓")
                }
                
            case 6:
                if (address[count] != ""){
                    addressParameter.append("室")
                }
            default:
                do{}
            }
            count += 1

        }
        test = addressParameter
        userData.addressData = addressData
        userData.haveAddressData = true
        userData.parameter.append(addressParameter)
    }
    
    
    private func parameterPacking(){
        
        var parameter = ""
        // handle basic data parameter
        var countBasic = 0
        let basicData = userData.basicData!
        
        let s1 :[String] = [basicData.email, basicData.password, basicData.confirm_password]
        
        
        let m1  = Mirror(reflecting: basicData)
        for child in m1.children{
            parameter.append(child.label ?? "")
            parameter.append("=")
            parameter.append(s1[countBasic])
            if countBasic < m1.children.count-1{
                parameter.append("&")
                countBasic += 1
            }
        }
        
        //handle advanced data parameters
        let advancedData = userData.advancedData!
        var countAdvanced = 0
        
        let s2 :[String] = [advancedData.first_name, advancedData.last_name, advancedData.phone, advancedData.gender, advancedData.birthday]
        
        
        let m2  = Mirror(reflecting: advancedData)
        for child in m2.children{
            parameter.append("&")
            parameter.append(child.label ?? "")
            parameter.append("=")
            parameter.append(s2[countAdvanced])
            countAdvanced += 1
            
        }
        
        userData.parameter = parameter
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        SignAddressView(step: .constant(2), dismiss: .constant(false))
            .environmentObject(UserData())
    }
}
