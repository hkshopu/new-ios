//
//  CostomerPageTopView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct CostomerPageTopView: View {
    @State var notifications = 1058
    var body: some View {
        VStack{
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                })

                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("Shopping_Cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                })
                customRingView(notifications: self.$notifications)
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                    Image("notification")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 24)
//                })

//                Button(action:{
//                    if(step != 0){
//                        withAnimation{
//                            step -= 1
//                        }
//                    }else{
//                        dismiss = 0
//                    }
//                })
//                {
//                    //Back Button
//                    Image("Back_Arrow")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 24)
//                }
//                Spacer()
//                Text(context)
//                    .font(.title2)
//                Spacer()
            }.padding()
            
        }
    }
}

private struct customRingView : View{
    
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


struct CostomerPageTopView_Previews: PreviewProvider {
    static var previews: some View {
        CostomerPageTopView()
    }
}
