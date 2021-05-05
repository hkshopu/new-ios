//
//  FirstAddShopControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import SwiftUI

struct FirstAddShopView: View {
    
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var userStatus: User
    @State var isShowAddShop :Bool = false
    @Binding var flow:RetailerPageFlow
    @State var ishowSignin = false
    var body: some View {
        //customTextField(text: <#Binding<String>#>)
        let context = language.content
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.bgColor)
                ScrollView(.vertical) {
                    VStack(spacing:25){
        //                RetailerPageTopView()
                        Text(context["FirstAddShop_1"]!)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(context["FirstAddShop_2"]!)
                            .font(.custom("SFNS", size: 14))
                            .foregroundColor(Color(hex: 0x48484A))

                        Image("First_Add_Banner")
                        Button(action: {
                            withAnimation{
                                
                                if let id = userStatus.id{
                                    isShowAddShop = true
                                    print(id)
                                }else{
                                    
                                    ishowSignin.toggle()
                                    print(ishowSignin)
                                }
                            }
                        }){
                            ZStack {
                                Capsule()
                                    .frame(width: 0.8*UIScreen.screenWidth, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.mainTone)
                                Text(context["FirstAddShop_3"]!)
                                    .foregroundColor(.white)
                                    .font(.custom("SFNS", size: 18))
                            }
                        }.offset(y:20)
    //                    .fullScreenCover(isPresented: self.$ishowSignin, content: {
    //                        SignUpControlView(dismiss: $ishowSignin)
    //                    })
                        Spacer()
                    }.padding(.top, 0.15*UIScreen.screenHeight)
                }
            }.ignoresSafeArea()
            .fullScreenCover(isPresented: self.$isShowAddShop, content: {
                AddShopFlowControlView(dismiss: self.$isShowAddShop, flow: self.$flow, nextPage: .shopList)
            })
            ZStack{
                EmptyView()
            }
            .sheet(isPresented: self.$ishowSignin, content: {
                SignUpControlView(dismiss: $ishowSignin)
        })
        }
    }
}


struct FirstAddShopView_Previews: PreviewProvider {
    static var previews: some View {
        FirstAddShopView(flow: .constant(.shop))
            .environmentObject(SystemLanguage())
    }
}
