//
//  MenuView.swift
//  Test
//
//  Created by 林亮宇 on 2021/1/14.
//

import SwiftUI

struct MenuView: View {
    @State var isLoggedIn = false
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.gray)
            VStack{
                MenuHeader(isLoggedIn: $isLoggedIn)
                Spacer().frame(height:10)
                MenuBody()
            }
            .padding(.top, 20.0)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

struct MenuElement: View {
    let id :Int
    let title : String
    @Binding var element : Int
    @EnvironmentObject var applicationState:ApplicationState
    var body: some View {
        ZStack{
            if(id == element){
                Rectangle()
                    .foregroundColor( .gray)
            }
            else{
                Rectangle()
                    .foregroundColor( .white)
            }
            HStack{
                Text(title)
                Spacer()
            }.padding(.leading, 50.0)
            
            
            .multilineTextAlignment(.leading)
        }.onTapGesture {
            element = id
            applicationState.mainViewID = id
            applicationState.menuBarItem = -1
            applicationState.menuBarButtonTapped = false
        }
    }
}

struct MenuHeader: View{
    @Binding var isLoggedIn :Bool
    var body: some View{
        GeometryReader{ geometry in
            HStack{
                Spacer()
                ZStack{
                    VStack{
                        Image("Logo")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 0.3*geometry.size.width)
                        Image(systemName: "person.crop.circle.fill.badge.questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width:0.2*geometry.size.width)
                        Spacer()
                        HStack{
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width:0.3*geometry.size.width, height: 0.15*geometry.size.height)
                                        .foregroundColor(.white)
                                    Text("LOGIN")
                                        .foregroundColor(.black)
                                }
                            })
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width:0.3*geometry.size.width, height: 0.15*geometry.size.height)
                                        .foregroundColor(.white)
                                    Text("LOGIN")
                                        .foregroundColor(.black)
                                }
                            })
                        }
                    }.padding()
                }
                Spacer()
            }
        }.frame(height:0.3*UIScreen.screenHeight)
    }
}
struct MenuBody: View{
    @State var tappedElement = -1
    
    var body:some View{
        GeometryReader{ geometry in
            ZStack{
                HStack{
                    Rectangle()
                        .frame(width:40)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.white)
                ScrollView(){
                    
                    VStack(alignment:.leading){
                        MenuElement(id: 0, title:"Product", element:$tappedElement)
                        MenuElement(id: 1, title:"Shop", element:$tappedElement)
                        MenuElement(id: 2, title:"My Profile", element:$tappedElement)
                        MenuElement(id: 3, title:"My Shop", element:$tappedElement)
                        MenuElement(id: 4, title:"Shop Management", element:$tappedElement)
                        
                    }
                    Rectangle()
                        .frame(width: 0.9*geometry.size.width, height:2)
                        .foregroundColor(.gray)
                    VStack(alignment:.leading){
                        MenuElement(id: 5, title:"Setting", element:$tappedElement)
                        MenuElement(id: 6, title:"About Us", element:$tappedElement)
                        MenuElement(id: 7, title:"Contact Us", element:$tappedElement)
                    }
                    
                }.padding([.top, .trailing], 11.0)
            }.padding([.bottom, .trailing], 7.0)
        }
    }
}

