//
//  ServiceView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/19.
//

import SwiftUI

struct ServiceView: View {
    @State var isShowCategoryView = false
    @Binding var flow: RetailerPageFlow
    @Binding var willShowFullScreenControl: Bool
    @Binding var fcControl: FullScreenCoverControl
    var body: some View {
        VStack{
            
            MySaleElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            PaymentElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            ShippigFeeElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            ShopCategoryElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            CampaignElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            AddShopElementView(flow: self.$flow, willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            AccountSettingElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            SupportElementView(willShowFullScreenCover: self.$willShowFullScreenControl, fcControl: self.$fcControl)
            
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(flow: .constant(.shop), willShowFullScreenControl: .constant(false), fcControl: .constant(.addProduct))
            .environmentObject(ShopData())
            .environmentObject(InternetTask())
    }
}

private struct MySaleElementView: View{
    let elementHeight: CGFloat = 40.0
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    var body: some View{
        VStack {
            BasicServiceView(iconName: "List_Retailer", title: "我的銷售", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            HStack(spacing: 0.11*UIScreen.screenWidth){
                MySaleButton(iconName: "Wallet", text: "待付款")
                MySaleButton(iconName: "Product", text: "待發貨")
                MySaleButton(iconName: "Delivered", text: "待收貨")
                MySaleButton(iconName: "Rating", text: "評價")
            }
            //.frame(height:70)
            //.padding(.vertical, 10)
            Spacer().frame(height:20)
            saperator()
        }
    }
}
private struct PaymentElementView: View{
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Payment", title: "銀行帳號", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            saperator()
        }
        
    }
}
private struct ShippigFeeElementView: View{
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Shipping_Fee", title: "運輸設定", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            saperator()
        }
    }
}
private struct ShopCategoryElementView: View{
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 70.0
    
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Shop_Category", title: "店舖分類", elementHeight: elementHeight, additionalView: AnyView(CategorySubView(category: $shopData.currentShop.categorys)), isShowChildrenView: self.$willShowFullScreenCover, fcControl: self.$fcControl, fcType: .category)
            saperator()
        }
        .onAppear{
            //print("onAppear Triggered")
            let data = makeAPIGeneralCall(internetTask: internetTask, url: "\(internetTask.domain)shop_category/index/", method: "GET", parameters: "")
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(APICatReturn.self, from: data)
                var temp : [ShopCategory] = []
                for id in shopData.currentShop.detail!.shop_category_id{
                    for category in decoded.shop_category_list{
                        if id == category.id{
                            temp.append(category)
                        }
                    }
                }
                shopData.currentShop.categorys = temp
            }catch{
                print("Error in decoding Category!!!")
            }
        }
        
    }
}
private struct CampaignElementView: View{
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Sale", title: "廣告與行銷活動", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            saperator()
        }
    }
}
private struct AddShopElementView: View{
    
    @Binding var flow: RetailerPageFlow
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Store", title: "新增店舖", elementHeight: elementHeight, isShowChildrenView: self.$willShowFullScreenCover, fcControl: self.$fcControl, fcType: .addShop)
            saperator()
        }
        
    }
}
private struct AccountSettingElementView: View{
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Gear_Retailer", title: "用戶帳號設定", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            saperator()
        }
    }
}
private struct SupportElementView: View{
    @Binding var willShowFullScreenCover: Bool
    @Binding var fcControl: FullScreenCoverControl
    let elementHeight: CGFloat = 40.0
    var body: some View{
        VStack {
            BasicServiceView(iconName: "Support_Retailer", title: "幫助中心", elementHeight: elementHeight, isShowChildrenView: .constant(false), fcControl: self.$fcControl)
            saperator()
        }
    }
}
private struct BasicServiceView: View{
    
    let iconName: String
    let title:String
    let elementHeight: CGFloat
    var additionalView: AnyView?
    @Binding var isShowChildrenView: Bool
    @Binding var fcControl: FullScreenCoverControl
    var fcType: FullScreenCoverControl?
    var body: some View{
        VStack{
            HStack{
                ZStack {
                    Image(iconName)
                }.frame(width: 30)
                
                Text(title)
                    .font(.custom("SFNS", size: 14))
                
                Spacer()
                
                Button(action: {
                    withAnimation{
                        if let fc = fcType{
                            let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                            serialQueue.sync {
                                fcControl = fc
                            }
                            isShowChildrenView = true
                        }
                        
                        
                    }
                }){
                    HStack {
                        Text("更多")
                            .font(.custom("SFNS", size: 14))
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                    }
                }
                .foregroundColor(Color(hex:0x8E8E93))
            }
            if let view = additionalView{
                view
            }
        }.frame(height:elementHeight)
        .padding(.horizontal, 40)
    }
}

private struct saperator: View{
    var body: some View{
        Rectangle()
            .frame(height:1)
            .foregroundColor(Color(hex: 0xC4C4C4))
    }
}

private struct MySaleButton: View{
    
    let iconName: String
    let text: String
    
    var body: some View{
        Button(action:{
            
        }){
            VStack{
                Image(iconName)
                Text(text)
                    .font(.custom("SFNS", size: 14))
                    .lineLimit(1)
            }
        }
        .foregroundColor(.black)
    }
    
}

private struct CategorySubView: View{
    
    @Binding var category: [ShopCategory]
    
    var body: some View{
        HStack{
            //Text(String(category.count))
            ForEach(category, id: \.self.id) { item in
                ZStack{
                    let c = item.c_shop_category.count
                    let hexInString = item.shop_category_background_color
                    let intVal = UInt(hexInString, radix: 16)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(hex: intVal!))
                        .frame(width:CGFloat(c * 14 + 16), height:33)
                    Text(item.c_shop_category)
                        .foregroundColor(.white)
                        .font(.custom("SFNS", size: 14))
                }
            }
            Spacer()
        }
    }
}
