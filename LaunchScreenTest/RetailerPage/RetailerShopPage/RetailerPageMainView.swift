//
//  RetailerPageMainView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import SwiftUI

struct RetailerPageMainView: View {
    
    
    @State var flow = ShopFlow.service
    @Binding var haveProduct:Bool
    @Binding var retailerFlow: RetailerPageFlow
    @Binding var products: [ProductData]
    @Binding var willShowFullScreenCover:Bool
    @Binding var fcControl: FullScreenCoverControl

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 48)
                .foregroundColor(.white)
            Rectangle()
                .offset(y:48)
                .foregroundColor(.white)
                .ignoresSafeArea(edges: .bottom)
            VStack {
                HStack{
                    Spacer()
                    Element(flow : self.$flow, haveProduct: self.$haveProduct, products: self.$products, attr: ShopFlow.service, title: "功能服務")
                    Spacer()
                    Element(flow: self.$flow, haveProduct: self.$haveProduct, products: self.$products, attr: ShopFlow.shop , title: "我的賣場")
                    Spacer()
                    
                    
                
                }.padding(19)
                
                switch flow {
                case .service:
                    ServiceView(flow: self.$retailerFlow, willShowFullScreenControl: self.$willShowFullScreenCover, fcControl: self.$fcControl)
                case .shop:
                    ShopView(haveProduct: self.$haveProduct, products: self.$products, willShowFullScreenCover: self.$willShowFullScreenCover, fcControl: self.$fcControl)
                        
                }
                
                Spacer()
            }
            
        }
        .frame(width:UIScreen.screenWidth)
    }
}


private struct Element:View{
    @EnvironmentObject var shopData:ShopData
    @EnvironmentObject var internetTask: InternetTask
    @Binding var flow: ShopFlow
    @Binding var haveProduct: Bool
    @Binding var products: [ProductData]
    let attr : ShopFlow
    let title: String
    
    
    
    var body: some View{
        Button(action:{
            if flow != attr{
                flow = attr
            }
            if flow == .shop {
                //TODO: Check if shop have product
                
                //call api
                
                getProductList()
                if products.count > 0 {
                    haveProduct = true
                }else{
                    haveProduct = false
                }
                
            }
            else{
                haveProduct = false
            }
        }){
            HStack{
                
                Circle()
                    .frame(width:8, height: 8)
                    .foregroundColor((flow == attr) ? Color(hex:0x1DBCCF) : .white)
                    .offset()

                Text(title)
                    .font(.custom("SFNS", size: 18))
                    .foregroundColor((flow == attr) ? .black : Color(hex:0x8E8E93))
            }
        }
        
    }
    private func getProductList(){
        let url = "\(internetTask.domain)product/\(shopData.currentShopID!)/shop_product/"
        let data = makeAPIGeneralCall(internetTask: internetTask, url: url, method: "GET", parameters: "")
        let decoder = JSONDecoder()
        do{
            let decodede = try decoder.decode(APIGeneralReturn<[ProductAPI]>.self, from: data)
            var temp :[ProductData] = []
            for product in decodede.data{
                temp.append(ProductData(id: product.id, product_name: product.product_title, product_image: product.pic_path, min_price: product.product_price, max_price: product.product_price, sold: product.sold_quantity, amount: product.quantity, likes: product.like, views: product.seen))
            }
            self.products = temp
            print(products)
        }catch{
            print("Error in product data decoding")
            print(data)
        }
    }
}
private struct ProductAPI: Identifiable, Codable{
    let id : Int
    let product_title : String
    let quantity :Int
    let product_price: Double
    let like : Int
    let seen : Int
    let sold_quantity : Int
    let pic_path :String
}

struct RetailerPageMainView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageMainView(haveProduct: .constant(false), retailerFlow: .constant(.firstAddShop), products: .constant([]), willShowFullScreenCover: .constant(false), fcControl: .constant(.addProduct))
    }
}
