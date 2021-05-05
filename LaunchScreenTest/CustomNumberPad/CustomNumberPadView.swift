//
//  CustomNumberPadView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/3/4.
//

import SwiftUI

struct CustomNumberPadView: View {
    
    @Binding var number:String 
    @Binding var numberPadShouldDismiss :Bool
    
    let buttonWidth = 0.3*UIScreen.screenWidth
    let buttonHeight = 0.12*UIScreen.screenWidth
    
    let backgroundColor = Color(hex: 0xd1d4d9)
    let spacing :CGFloat = 9
    
    var body: some View {
        let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
        //let numberPadHeight = 4*buttonHeight + 80
        ZStack (alignment:.top){
            Rectangle()
                .foregroundColor(backgroundColor)
                //.frame(height:numberPadHeight)
            VStack (alignment: .center, spacing: spacing){
                //Text(number)
                Spacer()
                    .frame(height: 10)
                HStack(alignment: .center, spacing: spacing){
                    ForEach(1 ..< 4) { item in
                        CustomNumberPadButtonView(pressed: $number, dismiss: $numberPadShouldDismiss, number: item, size: buttonSize)
                    }
                }
                HStack(alignment: .center, spacing: spacing){
                    ForEach(4 ..< 7) { item in
                        CustomNumberPadButtonView(pressed: $number,dismiss: $numberPadShouldDismiss, number: item, size: buttonSize)
                    }
                }
                HStack(alignment: .center, spacing: spacing){
                    ForEach(7 ..< 10) { item in
                        CustomNumberPadButtonView(pressed: $number,dismiss: $numberPadShouldDismiss, number: item, size: buttonSize)
                    }
                }
                HStack(alignment: .center, spacing: spacing){
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .foregroundColor(backgroundColor)
                    CustomNumberPadButtonView(pressed: $number, dismiss: $numberPadShouldDismiss, number: 0, size: buttonSize)
                    Button(action:{
                        if (!number.isEmpty){
                            number.removeLast()
                        }
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: buttonWidth, height: buttonHeight)
                                .foregroundColor(backgroundColor)
                            Image(systemName: "delete.left")
                                .foregroundColor(.black)
                        }
                    }
                    
                }
            }
        }

    }
}
struct CustomNumberPadButtonView: View{
    
    @Binding var pressed: String
    @Binding var dismiss: Bool
    
    var number :Int
    var size: CGSize
    let shadowColor = Color(hex: 0xd1d4d9)
    
    var body: some View{
        Button(action:{
            
            if (pressed.count < 4){
                pressed.append(String(number))
            }
            if(pressed.count >= 4){
                withAnimation{
                    dismiss = true
                }
            }
        }){
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .shadow(color: shadowColor, radius: 2, x: 0.0, y: 0.0 )
                    .frame(width: size.width, height: size.height)
                
                Text(String(number))
                    .font(.title)
                    
            }.foregroundColor(.black)
        }
    }
}
struct CustomNumberPadView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNumberPadView(number: .constant(""), numberPadShouldDismiss: .constant(true))
    }
}
