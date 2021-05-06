//
//  ShopDetailView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/8.
//

import SwiftUI

struct ShopDetailView: View {
    
    
    @EnvironmentObject var shopData: ShopData
    @State var userName: String = "Someone"
    
    
    @Binding var isShowShopNameEditView :Bool
    @State var isShowIconPicker = false
    
    @Binding var isShowDetailView: Bool
    @Binding var isShowDescriptionView: Bool
    @Binding var isShowNumberEditView: Bool
    @Binding var isShowEmailEditView: Bool
    @Binding var isShowSocialSettingView: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.bgColor)
            VStack {
                BasicNavigationBar(context: "修改店舖資訊", showRingView: false, buttonAction: {withAnimation{isShowDetailView = false}})
                ZStack {
                    BannerView(image: self.$shopData.currentShop.shopIMGs.shopPic)
                    Circle()
                        .frame(width: 106, height: 106, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: 2, x: 0, y: 0)
                    IconView(image: self.$shopData.currentShop.shopIMGs.shopIcon)
                        .clipShape(Circle())
                }
                ScrollView(.vertical) {
                    VStack(spacing:12){
                        Element(title: "名稱", navigation: self.$isShowShopNameEditView, Content: shopData.currentShop.detail!.shop_title, isShopName: true)
                        UserName(Content: self.userName)
                        if let detail = shopData.currentShop.detail{
                            Element(title: "簡介", navigation: self.$isShowDescriptionView, Content: detail.shop_description)
                        }else{
                            Element(title: "簡介", navigation: self.$isShowDescriptionView, Content: "")
                        }
                        
                        if let detail = shopData.currentShop.detail{
                            if !(shopData.currentShop.detail?.shop_address.isEmpty)! {
                                Element(title: "電話號碼", navigation: self.$isShowNumberEditView , Content: detail.shop_address[0].number)}
                            else{
                                Element(title: "電話號碼", navigation: self.$isShowNumberEditView , Content: "")
                            }
                        }else{
                            Element(title: "電話號碼", navigation: self.$isShowNumberEditView , Content: "")
                        }
                        
                        Element(title: "Email", navigation: self.$isShowEmailEditView  , Content:"someMail@gmail.com" )
                        Element(title: "社群帳號設定", navigation: self.$isShowSocialSettingView)
                    }.padding(.top, 20)
                }
                Spacer()
                Button(action: {
                    //TODO: call save detail api
                    
                }){
                    ZStack {
                        Capsule()
                        Text("儲存")
                            .font(.custom("SFNS", size: 18))
                            .foregroundColor(.white)
                    }.frame(width: 0.9*UIScreen.screenWidth, height: 70, alignment: .center)
                    .foregroundColor(.mainTone)
                }
            }
            .padding(.vertical, 40)
        }.ignoresSafeArea(.all)
    }
    func IconHandler( img: UIImage) ->(){
        
    }
    func BannerHandler( img: UIImage) ->(){
        
    }
}

private struct Element:View{
    
    let title: String
    @Binding var navigation: Bool
    
    var Content:String?
    var isShopName: Bool?
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
            HStack{
                Text(title)
                    .foregroundColor(.black)
                    .font(.custom("SFNS", size: 14))
                Spacer()
                if (Content != nil) {
                    Button(action: {
                        withAnimation{
                            navigation.toggle()
                        }
                    }){
                        Text(Content!)
                            .foregroundColor((isShopName != nil) ? .mainTone : Color(hex: 0x48484A))
                            .font(.custom("SFNS", size: 14))
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame( height: 12)
                            .foregroundColor(Color(hex: 0x48484A))
                    }
                }
                else{
                    Button(action: {
                        withAnimation{
                            navigation.toggle()
                        }
                    }){
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame( height: 12)
                            .foregroundColor(Color(hex: 0x48484A))
                    }
                    
                }
            }.padding()
            
            
        }.frame(width: 0.9*UIScreen.screenWidth, height: 46, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
private struct UserName:View{
    
    
    let Content:String
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
            HStack{
                Text("使用者帳號")
                    .foregroundColor(.black)
                    .font(.custom("SFNS", size: 14))
                Spacer()
                Text(Content)
                    .foregroundColor(Color(hex: 0x48484A))
                    .font(.custom("SFNS", size: 14))
            }.padding()
            
            
        }.frame(width: 0.9*UIScreen.screenWidth, height: 46, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
private struct IconView: View{
    @Binding var image: UIImage
    @State var isShowIconIMGPicker = false
    var body: some View{
        ZStack{
            if image.size == CGSize.zero {
                Image("PsuedoFoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }else{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            VStack{
                Spacer()
                ZStack {
                    Rectangle()
                        .frame(height: 33)
                        .foregroundColor(.mainTone)
                        .opacity(0.7)
                    Text("編輯")
                        .font(.custom("SFNS", size: 14))
                        .foregroundColor(.white)
                }.onTapGesture {
                    isShowIconIMGPicker.toggle()
                }
                    
            }
        }.frame(width: 100, height: 100, alignment: .center)
        .fullScreenCover(isPresented: self.$isShowIconIMGPicker, content: {
            ImagePicker(originalImage: image, completionHandler: imgHandler)
        })
    }
    func imgHandler(img: UIImage?) -> Void{
        if let img = img{
            DispatchQueue.main.async {
                let croppedImg = CropSquareImgToCenter(img)
                let scaledImg = scaleImage(originalImage: croppedImg, radius: 200 )
                
                self.image = scaledImg
            }
            
            isShowIconIMGPicker = false
        }
    }
}
private struct BannerView:View{
    @Binding var image:UIImage
    @State var isShowBannerPicker = false
    var body: some View{
        ZStack {
            if image.size == CGSize.zero{
                Rectangle()
                    .foregroundColor(Color(hex: 0xC4C4C4))
                
            }else{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            VStack{
                Spacer()
                ZStack{
                    if image.size == CGSize.zero {
                        
                        Rectangle()
                            .foregroundColor(Color(hex: 0x000000, alpha: 0.6))
                        Text("新增背景圖")
                            .foregroundColor(.white)
                            .font(.custom("SFNS", size: 14))
                        
                    }
                    else{
                        Rectangle()
                            .foregroundColor(Color(hex: 0x000000, alpha: 0.6))
                        Text("修改")
                            .foregroundColor(.white)
                            .font(.custom("SFNS", size: 14))
                    }
                }.frame(height: 40)
                .onTapGesture {
                    self.isShowBannerPicker = true
                }
            }
        }.frame(width:UIScreen.screenWidth, height: UIScreen.screenWidth/16*9)
        .fullScreenCover(isPresented: self.$isShowBannerPicker, content: {
            ImagePicker(originalImage: image,completionHandler: imgHandler)
        })
    }
    func imgHandler(img: UIImage?) -> Void{
        if let img = img{
            DispatchQueue.main.async {
                let croppedImg = CropRect(img, ratio: 16/9)
                self.image = croppedImg
            }
            
            isShowBannerPicker = false
        }
    }
}

