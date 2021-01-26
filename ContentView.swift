//
//  ContentView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/13.
//

import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

struct ContentView: View {
    
    @State var cursor = false
    @State var animate = false
    @State var opacity :Double = 1.0
    @State var scale :Double = 0
    @State var opacity2 :Double = 1.0
    @State var scale2 :Double = 0
    @State var circleTrigger = false
    @State var circle2Trigger = false
    @State var launchScreenOpacity = 1.0
    
    var body: some View {
        ZStack{
            
            //Home View here..
            MainView().frame(width:UIScreen.screenWidth)
                
            ZStack{
                Color("bg")
                Image("Circle_2")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:CGFloat(0.3*scale)*UIScreen.screenWidth)
                    .opacity(opacity)
                Image("Circle_2")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:CGFloat(0.3*scale2)*UIScreen.screenWidth)
                    .opacity(opacity2)
                
                
                Image("logo_v2")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: animate ? 0.48*UIScreen.screenWidth :0.52*UIScreen.screenWidth)
                //.transformEffect(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
                //.scaleEffect(0.2)
                Image("Cursor")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:0.05*UIScreen.screenWidth)
                    //.offset(x:-0.03*UIScreen.screenWidth, y:0.025*UIScreen.screenHeight)
                    //.opacity(opacity)
                    .offset(x:cursor ? -0.04*UIScreen.screenWidth :0.3*UIScreen.screenWidth, y: cursor ? 0.025*UIScreen.screenHeight : 0.2*UIScreen.screenHeight)
                
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: {animateSplash()})
            .opacity(launchScreenOpacity)
        }.ignoresSafeArea(.all, edges: .all)
    }
    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            withAnimation(Animation.easeIn(duration: 0.35)){
                cursor.toggle()
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                withAnimation(Animation.spring()){
                    animate.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    withAnimation(Animation.spring(response:1
                    )){
                        circleTrigger.toggle()
                        opacity = 0
                        scale = 5
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                        withAnimation(Animation.spring(response:1
                        )){
                            circle2Trigger.toggle()
                            opacity2 = 0.0
                            scale2 = 5
                            
                        }
                        withAnimation(Animation.easeOut(duration: 1.0)){
                            launchScreenOpacity = 0.0
                        }
                    }
                }
                
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ApplicationState())
    }
}

