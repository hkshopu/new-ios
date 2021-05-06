//
//  ShopDescriptionEditView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/30.
//

import SwiftUI

struct ShopDescriptionEditView: View {
    
    @EnvironmentObject var language : SystemLanguage
    @EnvironmentObject var shopData : ShopData
    @EnvironmentObject var internetTask : InternetTask
    @State var bannerIMG: UIImage = UIImage()
    @State var scaledIMG: UIImage = UIImage()
    //@State var isPickedIMG = false
    @State var isShowImagePicker = false
    @State var description: String = ""
    @State var isDescriptionEditing: Bool = false
    @Binding var dismiss: Bool
    @StateObject var kbh = KeyboardHandler()
    
    @State var TVheight :CGFloat = CGFloat.zero
    let textView = UITextView()
    let isShowTel = false
    let isShowEmail = false
    let number = "5511-6235"
    let email = "123123@gmail.com"
    var body: some View {
        let context = language.content
        ZStack(alignment:.top){
            
            ZStack(alignment: .top){
                
                if bannerIMG.size == CGSize.zero {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color(hex:0xC4C4C4))
                        Image("Description_Default")
                    }
                    .frame(height:0.33*UIScreen.screenHeight)
                    .onTapGesture {
                        isShowImagePicker = true
                    }
                    
                }
                else{
                    Image(uiImage: bannerIMG)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            isShowImagePicker = true
                        }
                }
                BasicNavigationBar(context: "", showRingView: true, buttonAction: {withAnimation{dismiss = false}}).offset(y:40)
            }.fullScreenCover(isPresented: self.$isShowImagePicker, content: {
                ImagePicker(originalImage: bannerIMG, completionHandler: imageHandler)
            })
            VStack{
                Spacer()
                let bannerHeight = UIScreen.screenWidth / 4 * 2.75
                ZStack {
                    RoundedRectangle(cornerRadius: 48)
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -4 )
                    VStack{
                        Spacer()
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 48)
                    }
                    VStack(alignment: .leading){
                        HStack(spacing: 8){
                            
                            // TODO: Fetch Shop Icon From Shop Data
                            //Image(systemName: "person.fill")
                            Image(uiImage: self.shopData.currentShop.shopIMGs.shopIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32, alignment: .center)
                                .foregroundColor(Color(hex:0xC4C4C4))
                                .clipShape(Circle())
                            Text(shopData.currentShop.detail!.shop_title)
                                .font(.custom("SF-PRO-Text-Semibold", size: 18))
                            //Text("somthing")
                                //.font(.custom("SFNS", size: 18))
                            Spacer()
                            Image("Share")
                        }
                        ZStack (alignment: .topLeading){
                            Text(description).foregroundColor(.clear).padding(6)
                                .background(TextViewGeometryGetterView())
                            Text(context["ShopDescriptionEditView_1"]!)
                                .font(.custom("SFNS", size: 14))
                                .foregroundColor(Color(hex:0xC9C9C9))
                                .opacity(description.isEmpty ? 1 : 0)
                                .offset(x:5, y:5)
                            customTextEditor(text: self.$description, isEditing: self.$isDescriptionEditing, completionHandler: completionHandler, textView: textView )
                                .frame(height: TVheight)
                                
                        }.onAppear(){
                            if !shopData.currentShop.detail!.shop_description.isEmpty{
                                description = shopData.currentShop.detail!.shop_description
                            }
                        }
                        
                        .onPreferenceChange(ViewHeightKey.self, perform: { value in
                            TVheight = value
                        })
                        
                        Spacer()
                        
                        if ( isShowTel ||  isShowEmail){
                            Text(context["ShopDescriptionEditView_2"]!)
                                .font(.custom("SFNS", size: 14))
                        }
                        if isShowTel {
                            HStack(spacing:12){
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.mainTone)
                                Text(number)
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(Color(hex:0x8e8E93))
                            }
                        }
                        if isShowEmail {
                            HStack(spacing:12){
                                Image( "mail")
                                    .foregroundColor(.mainTone)
                                Text(email)
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(Color(hex:0x8e8E93))
                            }
                        }
                        
                        SaveButton {
                            do{
                                //if let id = userStatus.id {
                                    if let shopid = shopData.currentShopID {
                                        let apireturn = makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/\(shopid)/update/", method: "POST", parameters: "shop_description=\(description)")
                                        print("shopid = ", shopid," shop_description = ",description)
                                    print (apireturn.status)
                                    }
                                //}
                            }
                        }
                    }
                    .padding(40)
                    .onTapGesture {
                        completionHandler()
                    }
                }.frame(height: UIScreen.screenHeight - bannerHeight + 48)
            }
            VStack{
                
                Spacer()
                
                if isDescriptionEditing {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color(hex:0xC9C9C9))
                            .frame(height: 32)
                        HStack{
                            Spacer()
                            Button(action:{
                                completionHandler()
                                withAnimation{
                                    isDescriptionEditing = false
                                }
                            }){
                                Text("Done").fontWeight(.bold)
                            }
                        }.padding(.horizontal)
                    }.padding(.bottom, kbh.kbh)
                }
            }.padding(.top, 40)
        }
        .ignoresSafeArea(.all)

    }
    private func completionHandler() -> Void{
        description = textView.text
        textView.resignFirstResponder()
    }
    private func imageHandler( image: UIImage?) -> Void{
        
        
        let img = image ?? UIImage()
        if img.size != CGSize.zero {
            DispatchQueue.main.async {
                
                let croppedImg = CropImg(img)
                self.bannerIMG = croppedImg
                self.scaledIMG = scaleImage(originalImage: croppedImg, radius: 1080)
            }
        }
        
        
        isShowImagePicker = false
        
    }
}

struct ShopDescriptionEditView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDescriptionEditView(dismiss: .constant(false))
            .environmentObject(SystemLanguage())
        
    }
}
private func CropImg(_ uiImage: UIImage) -> UIImage{
    
    
    let cropSquare: CGRect
    
    
    let resizedHeight = uiImage.size.width / 4 * 3
    let yOffset = (uiImage.size.height - resizedHeight) / 2
    
    print(uiImage.size.width)
    print(uiImage.size.height)
    print(resizedHeight)
    
    cropSquare = CGRect(x:0, y: yOffset, width: uiImage.size.width-1, height: resizedHeight-1)
    
    print(cropSquare)
    let cgImageRef = uiImage.cgImage?.cropping(to: cropSquare)
    
    return UIImage(cgImage: cgImageRef!)
}
