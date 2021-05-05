//
//  PublicShopView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/16.
//

import SwiftUI

struct PublicShopView: View {
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.bgColor)
                VStack {
                    DescriptionView()
                    SelectView()
                }
            }.ignoresSafeArea()
        }
    }
}
private struct DescriptionView: View{
    
    @EnvironmentObject var language :SystemLanguage
    let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce efficitur eu massa vel ullamcorper. Nulla vel elit id nibh vehicula consectetur a non turpis. Nulla auctor turpis et vulputate scelerisque. Vivamus sapien ligula, tempus placerat sapien ut, auctor efficitur quam. Curabitur mi mi, mattis eu tellus vel, malesuada tempus odio. Quisque pulvinar scelerisque venenatis. In dictum orci at congue malesuada. Aenean ligula ligula, laoreet vitae sapien vitae, suscipit sollicitudin est."
    var body: some View{
        ZStack {
            let context = language.content
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing:4) {
                Text(text).lineLimit(2)
                    .font(.custom("SFNS", size: 14))
                    .lineSpacing(4)
                Button(action:{}){
                    Text(context["PublicShopView_1"]!)
                        .foregroundColor(.mainTone)
                        .font(.custom("SFNS", size: 14))
                }
            }.padding(.horizontal, 16)
            
        }.frame(width: 0.9*UIScreen.screenWidth, height:76)
    }
}

private enum sorting : Int, CaseIterable{
    case general = 1
    case new = 2
    case hotSaling = 3
    case lowestPrice = 4
    case highestPrice = 5
}
private struct SelectView: View{
    @State var currentSelected  = sorting.general
    var body: some View{
        ScrollView(.horizontal) {
            HStack{
                ForEach( 0 ..< sorting.allCases.count){ index in
                    SelectElementView(selected: self.$currentSelected, type: sorting.allCases[index])
                }
            }
        }.frame(width:0.9*UIScreen.screenWidth)
        
    }
}

private struct SelectElementView: View{
    
    @EnvironmentObject var language: SystemLanguage
    
    @Binding fileprivate var selected: sorting
    fileprivate let type: sorting
    
    var body: some View{
        HStack{
            let context = language.content
            Circle()
                .frame(width: 8, height: 8, alignment: .center)
                .foregroundColor(.mainTone)
                .opacity((selected == type) ? 1.0 : 0)
            Text(context["PublicShopSelectElement_\(type.rawValue)"]!)
                .foregroundColor((selected == type) ? .black : Color(hex: 0x8E8E93))
                .font(.custom("SFNS", size: 18))
        }.onTapGesture {
            withAnimation{
                self.selected = type
            }
        }
    }
 
}
private struct ProductElement: View{
    
    @Binding var product: ProductData
    var body: some View{
        
        let width = 0.45*UIScreen.screenWidth
        let dg = Color(hex: 0x48484A)
        let lg = Color(hex: 0x8E8E93)
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                
            VStack (spacing: 0){
                ZStack{
                    let m = RoundedRectangle(cornerRadius: 8)
                        //.foregroundColor(.clear)
                    let scaledIMG = CropSquareImgToCenter(product.product_image)
                    
                    Image(uiImage: scaledIMG).mask(m)
                }.frame(width:width, height: 150)
                let width = 0.16*UIScreen.screenWidth
                
                    VStack{
                        HStack {
                            VStack(alignment: .leading){
                                Text(product.product_name)
                                Text("HKD$ \(String(product.min_price)) - \(String(product.max_price))")
                            }
                            .font(.custom("SFNS", size: 12))
                            .drawingGroup()
                            .foregroundColor(dg)
                            Spacer()
                        }
                        HStack(spacing: 10){
                            HStack(spacing: 4){
                                Image("Bag_Product")
                                Text("已賣出 \(String(product.sold))")
                                    .font(.custom("SFNS", size: 10))
                                    .foregroundColor(lg)
                                Spacer()
                                    
                            }.frame(width:width)
                            HStack(spacing: 4){
                                Image("Amount_Product")
                                Text("數量 \(String(product.amount))")
                                    .font(.custom("SFNS", size: 10))
                                    .foregroundColor(lg)
                                Spacer()
                                
                            }
                            Spacer()
                        }
                        HStack(spacing: 10){
                            HStack(spacing: 4){
                                Image("Heart_Product")
                                Text("讚 \(String(product.likes))")
                                    .font(.custom("SFNS", size: 10))
                                    .foregroundColor(lg)
                                    .offset(x:-1)
                                Spacer()
                            }.frame(width:width)
                            HStack(spacing: 4){
                                Image("Eye_Product")
                                    .offset(x:-1.2)
                                Text("檢視 \(String(product.views))")
                                    .font(.custom("SFNS", size: 10))
                                    .foregroundColor(lg)
                                    .offset(x:-3)
                                Spacer()
                            }
                            Spacer()
                        }
                    }.padding(12)
                
                Spacer()
            }
        }.frame(width:width, height:240)
        .shadow(color: Color(hex: 0x00000, alpha: 0.1), radius: 4, x: 0.0, y: 2)
        
    }
}
struct PublicShopView_Previews: PreviewProvider {
    static var previews: some View {
        PublicShopView()
            .environmentObject(SystemLanguage())
    }
}
