//
//  RetailerPageShopSelectView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/13.
//

import SwiftUI

struct RetailerPageShopSelectView: View {
    @EnvironmentObject var language: SystemLanguage
    @EnvironmentObject var shopData: ShopData
    @State var isShowAddShop = false
    @Binding var flow: RetailerPageFlow
    var body: some View {
        let context = language.content
        ZStack {
            Rectangle()
                .foregroundColor(.bgColor)
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        HStack{
                            Spacer()
                            RingView(notifications: .constant(20))
                        }.padding()
                        ForEach(shopData.shop){ shop in
                            Element(flow: self.$flow, shop: shop)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    withAnimation{
                        isShowAddShop = true
                    }
                }){
                    ZStack {
                        Capsule()
                            .frame(width: 0.9*UIScreen.screenWidth, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.mainTone)
                        Text(context["ShopSelectView_5"]!)
                            .foregroundColor(.white)
                            .font(.custom("SFNS", size: 18))
                    }
                }//.offset(y:20)
            }.padding(.top, 40)
        }.ignoresSafeArea()
        .fullScreenCover(isPresented: self.$isShowAddShop, content: {
            AddShopFlowControlView(dismiss: self.$isShowAddShop, flow: self.$flow, nextPage: .shop)
        })
        
    }
}
private struct Element:View{
    @EnvironmentObject var language : SystemLanguage
    @EnvironmentObject var shopData : ShopData
    @Binding var flow: RetailerPageFlow
    let shop: Shop
    
    private let elementHeight :CGFloat = 120
    
    private let productamount = "-"
    private let follow = "-"
    private let incomes = "-"
    
    var body: some View{
        let context = language.content
        let gray = Color(hex: 0x8E8E93)
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 4)
            ZStack(alignment:.topTrailing){
                Rectangle()
                    .foregroundColor(.clear)
                Button(action:{}) {
                    Text(context["ShopSelectView_1"]!)
                        .font(.custom("SFNS", size: 14))
                        .foregroundColor(gray)
                }
            }.padding()
            VStack(spacing: 10){
                HStack{
                    AsyncImage(
                        url: URL(string: shop.iconURL)!,
                        placeholder: { ProgressView() },
                       image: {
                        Image(uiImage: $0)
                        .resizable()
                       }
                    )
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 64, height: 64, alignment: .center)
                    
                        
                    VStack(alignment: .leading, spacing: 8){
                        Text(shop.name)
                            .font(.custom("SFNS", size: 18))
                            .fontWeight(.semibold)
                        StarView(rating: shop.rating,willShowFullScreenCover: .constant(false),fcControl: .constant(.myRating))
                    }
                    Spacer()
                        
                    
                }.padding(.horizontal, 20)
                HStack{
                    Text(context["ShopSelectView_2"]! + ((shop.product_count == 0) ? productamount : String(shop.product_count)))
                        .font(.custom("SFNS", size: 12))
                        .foregroundColor(gray)
                    Spacer()
                    Text(context["ShopSelectView_3"]! + ((shop.follower == 0) ? follow : String(shop.follower)))
                        .font(.custom("SFNS", size: 12))
                        .foregroundColor(gray)
                    Spacer()
                    Text(context["ShopSelectView_4"]! + ((shop.income == 0) ? incomes : String(shop.income)))
                        .font(.custom("SFNS", size: 12))
                        .foregroundColor(gray)
                }.padding(.horizontal, 20)
            }
        }
        .onAppear{
            
                    }
        .frame(width: 0.9*UIScreen.screenWidth, height: elementHeight, alignment: .center)
        .onTapGesture {
            print(shop.id)
            shopData.currentShopID = shop.id
            flow = .shop
        }
    }
}
struct RetailerPageShopSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageShopSelectView(flow: .constant(.firstAddShop))
            .environmentObject(SystemLanguage())
    }
}
