//
//  MainView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/14.
//

import SwiftUI

struct MainView: View{

    @EnvironmentObject var applicationState:ApplicationState
    // MARK
    
    // applicationState.menuBarItem
    // Default = -1
    // Hamburger menu button tapped = 1
    // Search Button tapped = 2
    // Cart button tapped = 3
    
    // applicationState.menuBarButtonTapped
    // Check if the button above is tapped
    
    var body: some View{
        ZStack(alignment: .leading){
            VStack{
                
                MenuBarView()
                    .zIndex(2)
                
                switch applicationState.mainViewID{
                
                case 3:
                    //My Shop View
                    MyShopView()
                default:
                    // Default View
                    ZStack{
                        //NavigationBar
                        Rectangle().foregroundColor(.red)
                    }.frame(height:0.01*UIScreen.screenHeight)
                    
                    ZStack{
                        //mainCell
                        Rectangle().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                    }
                }
                
                
                
                //Spacer()
                
            }.ignoresSafeArea(.all, edges: .all)
            .disabled(applicationState.menuBarButtonTapped ? true:false)
            .grayscale(applicationState.menuBarButtonTapped ? 0.80:0.0)
            .onTapGesture {
                if(applicationState.menuBarButtonTapped){
                    // Tap empty area to go back
                    applicationState.menuBarItem = -1
                    applicationState.menuBarButtonTapped.toggle()
                    
                }
            }
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            
            switch applicationState.menuBarItem{
            case 1:
                // Hamburger menu
                MenuView()
                    .frame(width:0.8*UIScreen.screenWidth)
                    .animation(.linear(duration: 0.30))
                    .transition(.move(edge: .leading))
                    .zIndex(3)
            default:
                //Show Nothing
                EmptyView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
    }
}

