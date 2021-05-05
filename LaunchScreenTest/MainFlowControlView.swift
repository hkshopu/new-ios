//
//  FlowControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/10.
//

import SwiftUI

enum MainFlow :Int{
    case home = 1
    case customer = 2
    case retailer = 3
}
struct MainFlowControlView: View {
    @EnvironmentObject var internetTask :InternetTask
    @EnvironmentObject var shopData: ShopData
    @State private var mainFlow = MainFlow.home
    @State var previous = MainFlow.home
    @State var animationControl = false
    @State var middleAnimationControl = false
    
    
    var body: some View {
        VStack{
            switch mainFlow{
            case .home:
                //Rectangle()
                DummyView(IMG: "Homepage_Dummy")
                    //.foregroundColor(.red)
                    .animation(.easeInOut)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                    //.zIndex(1.0)
            case .customer:
                if middleAnimationControl {
                    ZStack{
                        DummyView(IMG: "Customer_Dummy")
                        //testView()
                    }
                    .animation(.easeInOut)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }else{
                    ZStack{
                        DummyView(IMG: "Customer_Dummy")
                        //testView()
                    }
                    .animation(.easeInOut)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                }
                                
                //.zIndex(3.0)
            case .retailer:
                RetailerPageFlowControlView()
                    .animation(.easeInOut)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    //.zIndex(2.0)
            }
            BottomNavigatorView(mainFlow : self.$mainFlow, previous: self.$previous, animationControl: self.$animationControl, middleAnimationControl: self.$middleAnimationControl)
        }.ignoresSafeArea()
    }
    
}

struct MainFlowControlView_Previews: PreviewProvider {
    static var previews: some View {
        MainFlowControlView()
            .environmentObject(InternetTask())
            .environmentObject(SystemLanguage())
    }
}
private struct testView: View{
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    var body: some View{
        ZStack{
            
            Button(action: {
                DispatchQueue.main.async {
                    makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)user/loginProcess/", method: "POST", parameters: "email=brightlin@times-transform.com&password=123456Ab@")
                    
                    
                }
                
            }){
                ZStack{
                    Capsule()
                        .foregroundColor(.black)
                    Text("Log IN + Get List")
                }.frame(width: 200, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
            .foregroundColor(.white)
        }
    }
}

private struct DummyView:View{
    let IMG: String
    @State var scale :CGFloat = 0.2
    var body: some View{
        ZStack(alignment: .center){
            let uiimage = UIImage(named: IMG) ?? UIImage()
            
            let viewHeight = 0.9*UIScreen.screenHeight
            let viewWidth = UIScreen.screenWidth
            let ratio = viewHeight/viewWidth
            
            let original = uiimage.cgImage
            let cropRect = CGRect(x: .zero, y: .zero, width: CGFloat(original!.width), height: CGFloat(original!.width) * ratio)
            let croppedUI = UIImage(cgImage: original!.cropping(to: cropRect)!)
            
            Image(uiImage: croppedUI)
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.frame(height:100)
            Rectangle()
                .opacity(0.4)
                //.offset(y:(imgHeight-UIScreen.screenHeight) / 2)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                    
                VStack(spacing:16){
                    Text("COMING SOON")
                        .font(.custom("Roboto-Medium", size: 24))
                    Text("由於還在草創階段，店匯正在籌備買賣等功能以及累積店鋪商品數量。版本2.0即將開通進階功能，敬請期待！")
                        .font(.custom("Roboto-Regular", size: 14))
                        .lineSpacing(6)
                        .multilineTextAlignment(.center)
                    Link(destination: URL(string: "https://www.hkshopu.com")!){
                        ZStack{
                            Capsule()
                                .foregroundColor(.mainTone)
                            Text("了解更多")
                                .foregroundColor(.white)
                                .font(.custom("Roboto-Regular", size: 18))
                        }
                    }.frame(width: 0.6*UIScreen.screenWidth,height:60)
                    .padding(.top, 20)
                }.padding(.horizontal, 32)
                Image("Indicator")
                    .offset(x: 0.16*UIScreen.screenWidth, y: 0.32*UIScreen.screenHeight)
                    .scaleEffect(scale)
                    .animation(.spring())
                    .onAppear{
                        withAnimation{
                            scale = 1.0
                        }
                    }
                
            }.frame(width: 0.9*UIScreen.screenWidth, height: 260, alignment: .center)
            
        }
    }
}
