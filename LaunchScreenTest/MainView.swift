////
////  MainView.swift
////  LaunchScreenTest
////
////  Created by 林亮宇 on 2021/1/14.
////
//
//import SwiftUI
//
//struct MainView: View{
//
//    @EnvironmentObject var applicationState:ApplicationState
//    // MARK
//    
//    // applicationState.menuBarItem
//    // Default = -1
//    // Hamburger menu button tapped = 1
//    // Search Button tapped = 2
//    // Cart button tapped = 3
//    
//    // applicationState.menuBarButtonTapped
//    // Check if the button above is tapped
//    
//    var body: some View{
//        ZStack(alignment: .leading){
//            IntroView()
//
////            switch applicationState.menuBarItem{
////            case 1:
////                // Hamburger menu
////                MenuView()
////                    .frame(width:0.8*UIScreen.screenWidth)
////                    .animation(.linear(duration: 0.30))
////                    .transition(.move(edge: .leading))
////                    .zIndex(3)
////            default:
////                //Show Nothing
////                EmptyView()
////            }
//        }
//    }
//}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//        
//    }
//}
//
//
