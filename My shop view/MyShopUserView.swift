//
//  MyShopUserView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/21.
//

import SwiftUI

struct UserRow: View {
    let user : UserData
    var body: some View {
        GeometryReader { geometry in
            
            HStack{
                //User Image
                Image(systemName: user.userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 5)
                    .frame(width:0.2*geometry.size.width)
                
                VStack(alignment:.leading){
                    HStack{
                        //User name
                        Text(user.userName)
                            .font(.title)
                        Button(action:{}){
                            Image(systemName: "square.and.pencil")
                                .renderingMode(.original)
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        }
                        
                    }
                    //Join Date
                    Text("Join Date : \(user.joinDate)")
                    
                }.padding()
                Spacer()
                // Gear Setting Button
                Button(action:{
                    //Goto Edit View
                }){
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .foregroundColor(.black)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.1*geometry.size.width)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                }
            }.padding(20.0)
        }.frame(idealHeight: 0.09*UIScreen.screenHeight, maxHeight: 0.13*UIScreen.screenHeight)
        
        
    }
}

