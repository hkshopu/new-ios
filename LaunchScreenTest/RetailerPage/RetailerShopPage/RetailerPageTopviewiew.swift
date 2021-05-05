//
//  RetailerPagetopviewiew.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/11.
//

import SwiftUI

struct RetailerPageTopView: View {
    
    @State var notifications = 1058
    var body: some View {
        HStack(){
            Button(action:{
                
            }){
                Image("Gear")
            }
            Spacer()
            RingView(notifications: self.$notifications)
        }
        .padding()
    }
}

struct RingView : View{
    
    @Binding var notifications: Int
    var body: some View{
        ZStack{
            
            Button(action:{}){
                Image("notification")
            }
            
            ZStack {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(hex: 0x1DBCCF))
                if(notifications<10){
                    Text(String(notifications))
                        .font(.custom("SFNS.ttf", size: 9))
                        .foregroundColor(.white)
                        .offset(y:0.2)
                }else{
                    if (notifications < 100){
                        Text(String(notifications))
                            .font(.custom("SFNS.ttf", size: 7))
                            .foregroundColor(.white)
                            .offset(y:0.2)
                    }else{
                        Text(String("99+"))
                            .font(.custom("SFNS.ttf", size: 5))
                            .foregroundColor(.white)
                            .offset(y:0.2)
                    }
                }
                
            }.offset(x:7, y:-6)
        }
    }
}
struct RetailerPageTopView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageTopView()
    }
}

