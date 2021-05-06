//
//  ToBeUpdatedView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/5/4.
//

import SwiftUI

struct ToBeUpdatedView : View{
    let IMG: String
    @Binding var dismiss: Bool
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
            VStack(){
                BasicNavigationBar(context: "", showRingView: false, buttonAction: {
                    //TODO: close this view
                    dismiss.toggle()
                })
                Spacer()
            }.padding(.top, 40)
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
                
                
            }.frame(width: 0.9*UIScreen.screenWidth, height: 260, alignment: .center)
            
        }.ignoresSafeArea()
    }
}

//struct ToBeUpdatedView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToBeUpdatedView(IMG: "關注")
//    }
//}
