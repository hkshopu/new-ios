//
//  ContentView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/13.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var userStatus : User
    @State var cursor = false
    @State var animate = false
    @State var circleTrigger = false
    @State var circle2Trigger = false
    @State var c1Opacity = 0.0
    @State var c2Opacity = 0.0
    @State var launchScreenOpacity = 1.0
    @State var tick = 0
    @State var showintro = true
    let timer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
    
    var body: some View {
        
        let width = UIScreen.screenWidth
        ZStack{
            MainFlowControlView()
                .foregroundColor(.black)

            if let id = userStatus.id{

            }else{
                if showintro {
                IntroView(isintroshow: $showintro).frame(width:UIScreen.screenWidth)
                    .foregroundColor(.black)
                }
            }
            ZStack{
                Color(hex: 0x1DBCCF, alpha: 1.0)
                Image("Circle_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: circleTrigger ? 3 * width : 0 )
                    .opacity(c1Opacity)
                Image("Circle_2")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: circle2Trigger ? 3 * width : 0 )
                    .opacity(c2Opacity)
                
                
                Image("Logo")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: animate ? 0.36*UIScreen.screenWidth :0.4*UIScreen.screenWidth)
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
            //.onAppear(perform: {animateSplash()})
            .onReceive(timer, perform: { _ in
                if (tick < 60){
                    tick += 1
                    
                    if tick == 2 {
                        withAnimation{
                            cursor.toggle()
                        }
                        
                    }
                    if tick == 6{
                        withAnimation(Animation.easeIn(duration: 0.35)){
                            animate.toggle()
                        }
                    }
                    if tick == 8 {
                        withAnimation(Animation.spring(response:1
                        )){
                            circleTrigger.toggle()
                            c1Opacity = 1.0
                        }
                    }
                    if tick == 10{
                        withAnimation(Animation.spring(response:1
                        )){
                            circle2Trigger.toggle()
                            c2Opacity = 1.0
                            c1Opacity = 0.0
                        }
                    }
                    if tick == 12{
                        withAnimation(Animation.spring(response: 1)){
                            c2Opacity = 0
                        }
                    }
                    if tick == 22{
                        withAnimation(Animation.easeOut(duration: 1.0)){
                            launchScreenOpacity = 0.0
                        }
                    }
                }
            })
            .opacity(launchScreenOpacity)
        }.ignoresSafeArea(.all, edges: .all)
    }
    //}

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ApplicationState())
    }
}

