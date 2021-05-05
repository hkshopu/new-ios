//
//  ShopView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/29.
//

import SwiftUI

struct ShopView: View {
    
    private let grid :[GridItem] = Array(repeating: .init(.fixed(0.45*UIScreen.screenWidth)), count: 2)
    
    @Binding var haveProduct: Bool
    
    @Binding var products: [ProductData]
    @Binding var willShowFullScreenCover :Bool
    @Binding var fcControl: FullScreenCoverControl
    @State var isShowAddProduct = false
    
    var body: some View {
        
        VStack (spacing:40){
            // shop description
            Button(action:{
                let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                serialQueue.sync {
                    fcControl = .shopDescription
                }
                
                willShowFullScreenCover = true
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(hex: 0xF6f6F6))
                        .frame(width:0.38*UIScreen.screenWidth, height:50)
                    Text("+新增店舖簡介")
                        .font(.custom("SFNS", size: 14))
                        .foregroundColor(.mainTone)
                    
                }
            }
            .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: 4, x: 0.0, y: 2)
            // product elements
            LazyVGrid(columns: grid, spacing:25){
                
                if haveProduct {
                    ForEach( products, id:\.self.id ){product in
                        ProductElementView(product: product)
                            .onTapGesture {
                                let id = product.id
                                //retrieve product datat from server
                            }
                    }
                }
                else{
                    DefaultElementView()
                        .onTapGesture {
                            let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                            serialQueue.sync {
                                fcControl = .addProduct
                            }
                            willShowFullScreenCover = true
                        }
                        .fullScreenCover(isPresented: self.$isShowAddProduct, content: {
                            // TODO: Call Add Product View Here
                        })
                }
                
            }
            
        }
        
    }
}

private struct ProductElementView: View{
    
    let product: ProductData
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
                    
                    Image(uiImage: scaledIMG)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .mask(m)
                    
                    
                }.frame(width:width, height: 150)
                let width = 0.16*UIScreen.screenWidth
                Spacer()
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
                    HStack(spacing: 6){
                        HStack(spacing: 2){
                            Image("Bag_Product")
                            Text("已賣出")
                                .modifier(bodyText())
                            
                            
                            Text("\(String(product.sold))")
                                .modifier(bodyText())
                            Spacer()
                            
                        }.frame(width:width)
                        HStack(spacing: 4){
                            Image("Amount_Product")
                            Text("數量")
                                .modifier(bodyText())
                            
                            if product.amount<10 {
                                Text(String(product.amount))
                                    .modifier(bodyText())
                            }
                            else if(product.amount>=10 && product.amount<100) {
                                Text("約\(String(product.amount % 10))0")
                                    .modifier(bodyText())
                            }else{
                                Text("99+")
                                    .modifier(bodyText())
                                
                            }
                            Spacer()
                            
                            
                            
                        }
                        Spacer()
                    }
                    HStack(spacing: 6){
                        HStack(spacing: 4){
                            Image("Heart_Product")
                            Text("讚")
                                .modifier(bodyText())
                                .offset(x:-1)
                            
                            
                            Text(String(product.likes))
                                .modifier(bodyText())
                                .offset(x:-1)
                            Spacer()
                        }.frame(width:width)
                        HStack(spacing: 4){
                            Image("Eye_Product")
                                .offset(x:-1.2)
                            Text("檢視")
                                .modifier(bodyText())
                                .offset(x:-3)
                            
                            
                            Text(String(product.views))
                                .modifier(bodyText())
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

private struct DefaultElementView: View{
    
    var body: some View{
        
        let width = 0.45*UIScreen.screenWidth
        let dg = Color(hex: 0x48484A)
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
            
            VStack (spacing: 0){
                ZStack{
                    let m = RoundedRectangle(cornerRadius: 8)
                    //.foregroundColor(.clear)
                    ZStack{
                        Rectangle()
                            .foregroundColor(.mainTone)
                        VStack(spacing: 14){
                            Text("+")
                                .foregroundColor(.white)
                                .font(.custom("SFNS", size:30))
                            Text("新增商品")
                                .foregroundColor(.white)
                                .font(.custom("SFNS", size:20))
                        }
                        
                    }.mask(m)
                }.frame(width:width, height: 150)
                let width = 0.16*UIScreen.screenWidth
                Spacer()
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text("商品名稱")
                            Text("HKD$")
                        }
                        .font(.custom("SFNS", size: 12))
                        .drawingGroup()
                        .foregroundColor(dg)
                        Spacer()
                    }
                    HStack(spacing: 10){
                        HStack(spacing: 4){
                            Image("Bag_Product")
                            Text("已賣出")
                                .modifier(bodyText())
                            Spacer()
                            
                        }.frame(width:width)
                        HStack(spacing: 4){
                            Image("Amount_Product")
                            Text("數量")
                                .modifier(bodyText())
                            Spacer()
                            
                        }
                        Spacer()
                    }
                    HStack(spacing: 10){
                        HStack(spacing: 4){
                            Image("Heart_Product")
                            Text("讚")
                                .modifier(bodyText())
                                .offset(x:-1)
                            Spacer()
                        }.frame(width:width)
                        HStack(spacing: 4){
                            Image("Eye_Product")
                                .offset(x:-1.2)
                            Text("檢視")
                                .modifier(bodyText())
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

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(haveProduct: .constant(false), products: .constant([]), willShowFullScreenCover: .constant(false), fcControl: .constant(.addProduct))
    }
}
struct ProductData: Identifiable{
    
    let id: Int
    let product_name: String
    let product_image: UIImage
    let min_price: Double
    let max_price: Double
    let sold: Int
    let amount: Int
    let likes: Int
    let views: Int
    
    init( id: Int, product_name:String,product_image: String, min_price: Double, max_price: Double, sold: Int, amount: Int, likes: Int, views: Int){
        
        self.id = id
        self.product_name = product_name
        self.product_image = product_image.loadImgFromURL(defaultIMG: UIImage(named: "testImage"))
        self.min_price = min_price
        self.max_price = max_price
        self.sold = sold
        self.amount = amount
        self.likes = likes
        self.views = views
        
    }
    
}
private struct bodyText: ViewModifier {
    func body(content: Content) -> some View {
        let lg = Color(hex: 0x8E8E93)
        return content.font(.custom("SFNS", size: 9)).foregroundColor(lg)
        
    }
}
