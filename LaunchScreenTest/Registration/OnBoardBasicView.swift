//
//  OnBoardBasicView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/3/5.
//

import SwiftUI

struct OnBoardBasicView: View {
    
    @Binding var dismiss: Bool
    @Binding var step: Int
    let context:String
    
    var body: some View {
        VStack{
           
            VStack{
            HStack{
                Button(action:{
                    print(step)
                    if(step != 0){
                        withAnimation{
                            step -= 1
                        }
                    }else{
                        dismiss = false
                    }
                })
                {
                    //Back Button
                    Image("Back_Arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                }
                Spacer()
                Text(context)
                    .font(.title2)
                Spacer()
            }.padding(.horizontal, 30)
            }.padding(.top, 40)
            Spacer()
            
            LogoView()
                .ignoresSafeArea(edges: .all)
        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
        
    }
}

struct LogoView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(hex: 0xF6F6F6, alpha: 1.0))
                .ignoresSafeArea(edges: .all)

            Image("Logo_View")
                .ignoresSafeArea(edges: .all)

        }
        .frame(height: 0.07*UIScreen.screenHeight)
        .ignoresSafeArea( edges: .all)
        
        
    }
}

struct OnBoardBasicView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardBasicView(dismiss: .constant(true), step: .constant(1),context: "TEST")
    }
}
