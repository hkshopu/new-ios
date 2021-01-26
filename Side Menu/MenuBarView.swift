//
//  MenuBarView.swift
//  Test
//
//  Created by 林亮宇 on 2021/1/14.
//

import SwiftUI

struct MenuBarView: View {
    
    @EnvironmentObject var applicaitonState: ApplicationState
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 0.03*UIScreen.screenHeight)
                .foregroundColor(.white)
            GeometryReader{geometry in
                
                
                HStack(alignment: .bottom){
                    
                    Button(action: {
                        
                        applicaitonState.menuBarItem = 1
                        applicaitonState.menuBarButtonTapped = true
                        
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:0.7*geometry.size.height)
                        
                        
                    }
                    Spacer().frame(width:50)
                    Text("HKSop")
                        .font(.title)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .offset(y:3)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:0.8*geometry.size.height)
                    }.offset(y:3)
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(systemName: "cart")
                            .resizable()
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:0.8*geometry.size.height)
                    }.offset(y:3)
                    
                }.padding(15.0)
                .frame(height:0.04*UIScreen.screenHeight)
            }.frame(height:0.04*UIScreen.screenHeight)    }
    }
}


struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
