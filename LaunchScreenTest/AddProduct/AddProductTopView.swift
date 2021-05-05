//
//  AddProductTopView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/4/6.
//

import SwiftUI

struct AddProductTopView: View {
    
    @Binding var dismiss: Int
    @Binding var step: Int
    let context:String
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 0.07*UIScreen.screenHeight)
            HStack{
                Button(action:{
                    if(step != 0){
                        withAnimation{
                            step -= 1
                        }
                    }else{
                        dismiss = 0
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
            
            Spacer()
            
//            LogoView()
//                .ignoresSafeArea(edges: .all)
        }
        
    }
}

struct AddProductTopView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductTopView(dismiss: .constant(0), step: .constant(1),context: "TEST")
    }
}
