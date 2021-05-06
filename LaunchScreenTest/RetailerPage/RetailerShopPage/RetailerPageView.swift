//
//  RetailerPageControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/11.
//

import SwiftUI

enum ShopFlow{
    case service
    case shop
}

enum FullScreenCoverControl{
    case imgPicker
    case shopDetail
    case addProduct
    case category
    case addShop
    case shopDescription
    case myRating
    case myProductControl
    case myFocus
    case myIncome
}
struct RetailerPageView: View {
    @EnvironmentObject var internetTask:InternetTask
    @EnvironmentObject var shopData: ShopData
    @Binding var flow: RetailerPageFlow
    @State var haveProduct = false
    @State var willShowFullScreenCover = false
    @State var products: [ProductData] = []
    @State var isShowAddProduct = false
    @State var fcControl = FullScreenCoverControl.imgPicker
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color(hex: 0xF6FBFA))
            VStack{
                HStack{
                    Button(action:{
                        withAnimation {
                            flow = .shopList
                        }
                    })
                    {
                        //Back Button
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                            .foregroundColor(Color(hex:0x8E8E93))
                    }
                    Spacer()
                    Text("")
                        .font(.custom("SFNS", size: 18))
                        .foregroundColor(Color(hex:0x48484A))
                    Spacer()
                    RingView(notifications: .constant(20))
                }.padding(.horizontal, 30)
                
                
                ScrollView{
                    VStack(spacing: 20){
                        RetailerPageProfileView( willShowFullScreenCover: self.$willShowFullScreenCover, fcControl: self.$fcControl)
                        RetailerPageInfoView(willShowFullScreenCover: self.$willShowFullScreenCover, fcControl: self.$fcControl)
                            .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 4.0)
                        RetailerPageMainView(haveProduct: self.$haveProduct, retailerFlow: self.$flow, products: self.$products, willShowFullScreenCover: self.$willShowFullScreenCover, fcControl: self.$fcControl)
                    }.padding(.bottom, 20)
                }
                
            }.padding(.top, 50)
            
            if haveProduct {
                Button(action:{
                    let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                    serialQueue.sync {
                        fcControl = .addProduct
                    }
                    willShowFullScreenCover = true
                }){
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                        Text("+")
                            .font(.custom("SFNS", size: 40))
                            .foregroundColor(.white)
                    }.foregroundColor(Color(hex: 0x1DBCCF, alpha: 0.6))
                }.offset(x:0.35*UIScreen.screenWidth, y:0.4*UIScreen.screenHeight)
            }else{
                
            }
//            Button(action:{print(fcControl)
//                print(willShowFullScreenCover)
//            }){
//                Text("Print")
//            }
        }
        .frame(width: UIScreen.screenWidth)
        .ignoresSafeArea(.all)
        .fullScreenCover(isPresented: self.$willShowFullScreenCover, content: {FullScreenView(fcControl: self.$fcControl, willShowFullScreenCover: self.$willShowFullScreenCover, flow: self.$flow, imageHandler: imageHandler)})
        .onAppear{
            
            // make API Call for getting ShopDetail
            let data = makeAPIGeneralCall(internetTask: internetTask, url: "\(internetTask.domain)shop/\(String(shopData.currentShopID!))/show/", method: "GET", parameters: "")
            let decoder = JSONDecoder()
            
            do{
                let decoded = try decoder.decode(APIGeneralReturn<ShopDetail>.self, from: data)
                if decoded.status == 0{
                    shopData.currentShop.detail = decoded.data
                }
            }catch{
                print("Error in ShopDetail Data decoding!!!")
                print(String(data: data, encoding: .utf8))
            }
            shopData.currentShop.shopIMGs = ShopIMGs(ShopIconURL: shopData.currentShop.detail!.shop_icon, ShopPicURL: shopData.currentShop.detail!.shop_pic, ShopDescriptionURL: "")
            
        }
        
    }
    private func imageHandler( image: UIImage?) -> Void{
        
        
        var img = image ?? UIImage()
        img =  CropRect(img, ratio: 1.0)
        shopData.currentShop.shopIMGs.shopIcon = img
        
        willShowFullScreenCover = false
        SaveIMG2Backend()
        
    }
    private func SaveIMG2Backend(){
        // TODO: Call API To Update IMG Here
    }
}

struct RetailerPageView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageView(flow: .constant(.firstAddShop))
            .environmentObject(ShopData())
            .environmentObject(SystemLanguage())
    }
}
private struct Navi: View {
    @Binding var flow  : RetailerPageFlow
    let context: String = ""
    var body: some View {
        HStack{
            Button(action:{
                withAnimation {
                    flow = .shopList
                }
            })
            {
                //Back Button
                Image(systemName: "arrow.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                    .foregroundColor(Color(hex:0x8E8E93))
            }
            Spacer()
            Text(context)
                .font(.custom("SFNS", size: 18))
                .foregroundColor(Color(hex:0x48484A))
            Spacer()
            RingView(notifications: .constant(20))
        }.padding(.horizontal, 30)
        
    }
}

struct FullScreenView: View {
    
    @EnvironmentObject var shopData: ShopData
    @Binding var fcControl: FullScreenCoverControl
    @Binding var willShowFullScreenCover: Bool
    @Binding var flow:RetailerPageFlow
    
    let imageHandler :(UIImage?)->Void
    var body: some View {
        ZStack{
            switch fcControl {
            case .imgPicker:
                ImagePicker(originalImage: shopData.currentShop.shopIMGs.shopIcon, completionHandler: imageHandler)
            case .shopDetail:
                ShopDetailControlView(isShowDetailView: $willShowFullScreenCover)
            case .addShop:
                AddShopFlowControlView(dismiss: self.$willShowFullScreenCover, flow: self.$flow, nextPage: .shop)
            case .category:
                CategorySelectView(selectedCat: self.$shopData.currentShop.categorys, isShowShopCategoryView: self.$willShowFullScreenCover, isShopCategorySelected: .constant(false), shouldCallApi: true)
            case .addProduct:
                AddProductFlowControlView(isShowAddprodut: self.$willShowFullScreenCover)
            case .shopDescription:
                ShopDescriptionEditView(dismiss: self.$willShowFullScreenCover)
                
            case .myRating:
                ToBeUpdatedView(IMG: "評價",dismiss: self.$willShowFullScreenCover)
            case .myProductControl:
                MyProductControlView(isShowMyProduct: self.$willShowFullScreenCover)
            //ToBeUpdatedView(IMG: "")
            case .myFocus:
                ToBeUpdatedView(IMG: "關注",dismiss: self.$willShowFullScreenCover)
            case .myIncome:
                ToBeUpdatedView(IMG: "進帳",dismiss: self.$willShowFullScreenCover)
            }
            
        }
    }
}
