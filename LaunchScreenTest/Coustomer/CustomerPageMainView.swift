//
//  CustomerPageMainView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct CustomerPageMainView: View {
    let width = 0.9*UIScreen.screenWidth
    let height = UIScreen.screenHeight
    let buyliststep = ["待付款", "待發貨", "待收貨","評價"]
    let buyliststepimage = ["Wallet","Product","Delivered","Rating"]
    let buyliststeppoint = ["","","",""]
    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 40)
                    .padding(-20.0)
                    .foregroundColor(Color(red: 0.898, green: 0.898, blue: 0.898))
                    .frame(width:width)
                VStack{
                    VStack{//購買清單層
                        HStack{
                            Image("List_Customer")
                            Text("購買清單")
                                .font(.body)
                                //.lineLimit(nil)
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                HStack{
                                    Text("更多")
                                        .font(.body)
                                    Image(systemName: "chevron.forward")
                                }
                            })
                        }
                        HStack(spacing: 0.1*UIScreen.screenWidth){
                            ForEach(0 ..< 4) { item in
                                VStack( spacing: 5.0){
                                    Image(buyliststepimage[item])
                                    Text(buyliststep[item])
                                }
                            }
                        }
                    //Spacer()
                    }                        .padding(.horizontal, 10.0)
                    HStack{//我的地址層
                        Image("Map_Icon")
                        Text("我的地址")
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            HStack{
                                Text("更多")
                                    .font(.body)
                                Image(systemName: "chevron.forward")
                            }
                        })
                    }
                    .padding(.horizontal, 10.0)
                    HStack{//我的用戶帳號設定層
                        Image("Gear_Customer")
                        Text("用戶帳號設定")
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            HStack{
                                Text("更多")
                                    .font(.body)
                                Image(systemName: "chevron.forward")
                            }
                        })
                    }
                    .padding(.horizontal, 10.0)
                    HStack{//幫助中心層
                        Image("Support_Customer")
                        Text("幫助中心")
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            HStack{
                                Text("更多")
                                    .font(.body)
                                Image(systemName: "chevron.forward")
                            }
                        })
                    }
                    .padding(.horizontal, 10.0)
                    Spacer()
                }
            }.padding()
            //Spacer()
    }
    
}

struct CustomerPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageMainView()
    }
}
