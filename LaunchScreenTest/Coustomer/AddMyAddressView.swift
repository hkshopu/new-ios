//
//  AddMyAddressView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/19.
//

import SwiftUI

struct AddMyAddressView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @State var address = [String](repeating:"", count: 7)
    
    @State var apiReturn :APIloginReturn?
    @State var isAdressHaveEmpty = false
    @State var test = ""
    
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    
    private let territory :[String] = ["香港", "九龍", "新界"]
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("姓名/公司名稱")                    .padding(.top)
                TextField("輸入姓名或公司名稱", text: $address[1])                    .padding(.bottom)
            }
            .padding(.leading, 10.0)
            .background(Color(.white))
            .frame(width:UIScreen.screenWidth-50)
            .cornerRadius(20)
            
            VStack(alignment: .leading){
                Text("電話號碼")
                    .padding(.top)
                TextField("輸入姓名或公司名稱", text: $address[2])
                    .padding(.bottom)
            }
            .padding(.leading, 10.0)
            .background(Color(.white))
            .frame(width:UIScreen.screenWidth-50)
            .cornerRadius(20)
            VStack {
                HStack{
                    Text("請輸入您的郵寄地址")
                }
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
                
                Spacer().frame(height:5)
            }
            .padding(.leading, 10.0)
            .background(Color(.white))
            .frame(width:UIScreen.screenWidth-50)
            .cornerRadius(20)
            HStack{
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Text("設為預設地址")
                }
            }            .padding(.leading, 10.0)
            .background(Color(.white))
            .frame(width:UIScreen.screenWidth-50)
            .cornerRadius(20)
            HStack{
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Text("設為快遞取件地址")
                }
            }            .padding(.leading, 10.0)
            .background(Color(.white))
            .frame(width:UIScreen.screenWidth-50)
            .cornerRadius(20)
        }
    }
}

struct AddMyAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddMyAddressView()
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("main_color")/*@END_MENU_TOKEN@*/)
            
    }
}
