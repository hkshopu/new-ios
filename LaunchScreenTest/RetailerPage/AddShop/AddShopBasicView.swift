//
//  AddShopFlowControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import SwiftUI
import UIKit

struct AddShopBasicView: View {
    @EnvironmentObject var internetTask : InternetTask
    @EnvironmentObject var content :SystemLanguage
    @EnvironmentObject var userStatus: User
    @State var step: Int = 1
    
    @State var isImageSelected = false
    @State var isShopNameEntered = false
    @State var isCategorySelected = false
    
    @State var image  = UIImage()
    @State var shopName = ""
    @State var category :[ShopCategory] = []
    
    @State var isEditing = false
    @State var isRepeatedName = false
    
    @Binding var isShowAddShopBasic:Bool
    @Binding var isShowNextView:Bool
    @Binding var allData: [Data]
    
    let textField = UITextField()
    
    
    var body: some View {
        let context = content.content
        ZStack {
            if internetTask.isInternetProcessing{
                Text("Progressing")
            }
            Rectangle()
                .foregroundColor(.bgColor)
            
            VStack {
                
                BasicNavigationBar(context: context[ "AddShopFlowControlView_1"]!, showRingView: false, buttonAction: {withAnimation{isShowAddShopBasic = false}})
                
                ScrollView(.vertical) {
                    VStack {
                        HStack(alignment: .top){
                            VStack{
                                let gray = Color(hex: 0x8E8E93)
                                NumberElement(number: 1, step: self.$step)
                                Rectangle()
                                    .frame(width: 1, height:160)
                                    .foregroundColor(gray)
                                NumberElement(number: 2, step: self.$step)
                                Rectangle()
                                    .frame(width: 1, height:160)
                                    .foregroundColor(gray)
                                NumberElement(number: 3, step: self.$step)
                            }
                            VStack(alignment:.leading){
                                ImgSelectView(isImgSelected: self.$isImageSelected, image: $image, step: self.$step)
                                    .frame(height: 185)
                                EditShopNameView(isShopNameEntered: $isShopNameEntered, text: self.$shopName, step: self.$step, isEditing: self.$isEditing, isRepeatedName: self.$isRepeatedName, textField: textField, completionHandler: completionHandler)
                                    .disabled(step < 2)
                                    .frame(height: 200)
                                ShopCategorySelectView(isShopCategorySelected: self.$isCategorySelected , category: self.$category, step: self.$step)
                                    .disabled(step < 3)
                            }.offset(y:5)
                        }.padding(33)
                        
                        Spacer()
                        
                        
                    }
                    
                }
                Spacer()
                Button(action:{
                    if(isImageSelected && isShopNameEntered && isCategorySelected){
                        
                        let boundaries = "TestBoundaries"
                        
                        // call add shop API
                        let body = makeBody(boundaries: boundaries)
                        allData.append(body)
                        print("Basic")
                        print(String(data: body, encoding: .utf8))
                        isShowNextView = true
                       
                    }
                }){
                    let buttonHeight = 0.08*UIScreen.screenHeight
                    
                    if !(isCategorySelected && isImageSelected && isShopNameEntered){
                        ZStack{
                            RoundedRectangle(cornerRadius: buttonHeight/2)
                                .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                .foregroundColor(Color(hex: 0x1DBCCF))
                            RoundedRectangle(cornerRadius: buttonHeight/2-2)
                                .frame(width : 0.7*UIScreen.screenWidth-4, height:buttonHeight-4)
                                .foregroundColor(.bgColor)
                            Text(context[ "AddShopFlowControlView_10"]!)
                                .foregroundColor(Color(hex: 0x1DBCCF))
                                .fontWeight(.bold)
                        }
                    }else{
                        ZStack{
                            RoundedRectangle(cornerRadius: buttonHeight/2)
                                .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                .foregroundColor(Color(hex: 0x1DBCCF))
                                
                                .foregroundColor(.bgColor)
                            Text(context[ "AddShopFlowControlView_11"]!)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
            }.padding(.vertical, 40)
        }
        .ignoresSafeArea()
        .onTapGesture {
            if isEditing {
                
                isEditing = false
                textField.resignFirstResponder()
                shopName = textField.text!
                if !shopName.isEmpty {
                    completionHandler()
                }
                
            }
        }
        
    }
    func completionHandler() -> Void{
        DispatchQueue.main.async { [self] in
            print(textField.text.unsafelyUnwrapped)
            let apiRetuen = makeAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/checkShopNameIsExistsProcess/",
                                        method: "POST", parameters: "shop_title=\(textField.text.unsafelyUnwrapped)")
            
            if apiRetuen.status == 0{
                
                isRepeatedName = false
                isShopNameEntered = true
                step = 3
                
            }else{
                withAnimation{
                    isRepeatedName = true
                }
                
                textField.becomeFirstResponder()
            }
            
        }
    }
    func makeBody(boundaries: String) ->Data{
        
        var body = Data()
        
        
        // append user_id
        //TODO: Read Id from environment
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "user_id", value: "\(userStatus.id.unsafelyUnwrapped)"))
        
        print(String(data: body, encoding: .utf8))
        //append shop title
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "shop_title", value: shopName))
        print(String(data: body, encoding: .utf8))
        //append shop icon
        body.append(makeMultiformPNGBody(boundaries: boundaries, key: "shop_icon", image: image))
        //print(String(data: body, encoding: .))
        
        //append shop categories
        for c in category{
            let s = String(c.id)
            body.append(makeMultiformParamBody(boundaries: boundaries, key: "shop_category_id", value: s))
            //print(String(data: body, encoding: .none))
        }
        //print(String(data: body, encoding: .none))
        print(body)
        return body
    }
}

private struct NumberElement: View{
    
    let number: Int
    @Binding var step: Int
    
    var body: some View{
        ZStack{
            let gray = Color(hex: 0x8E8E93)
            
            if(number == step ){
                Circle()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(Color(hex:0x1DBCCF))
                Text(String(number))
                    .font(.custom("SFNS.ttf", size: 14))
                    .foregroundColor(.white)
            }
            
            if (number < step){
                Circle()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(gray)
                Text(String(number))
                    .font(.custom("SFNS.ttf", size: 14))
                    .foregroundColor(.white)
            }
            
            if(number > step){
                Circle()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(gray)
                Circle()
                    .frame(width: 22, height: 22, alignment: .center)
                    .foregroundColor(.bgColor)
                Text(String(number))
                    .font(.custom("SFNS.ttf", size: 14))
                    .foregroundColor(gray)
                
            }
            
        }
    }
}

private struct ImgSelectView: View{
    
    @EnvironmentObject var content :SystemLanguage
    
    @Binding var isImgSelected: Bool
    @Binding var image: UIImage
    @Binding var step: Int
    
    @State var isShowImageLib = false
    //@State var haveImage = false
    
    var body: some View{
        let context = content.content
        VStack(alignment:.leading, spacing: 6){
            Group {
                HStack {
                    Text(context[ "AddShopFlowControlView_2"]!)
                        .fontWeight(.black)
                        .tracking(1)
                    if (isImgSelected){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: 0x32D74B))
                    }
                    
                }
                Text(context[ "AddShopFlowControlView_3"]!)
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundColor(Color(hex: 0x48484A))
                    .allowsTightening(false)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }.padding(.trailing)
            
            HStack{
                Spacer()
                Group{
                    if image.size != CGSize.zero {
                        Image(uiImage: scaleImage(originalImage: image, radius: 100))
                            .clipShape(Circle())
                        
                    }
                    else{
                        Image("PsuedoFoto")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                .onTapGesture {
                    isShowImageLib.toggle()
                }
                .offset(y:-10)
                
            }.padding()
        }
        .fullScreenCover(isPresented: self.$isShowImageLib, content: {
            ImagePicker(originalImage: image, completionHandler: imageHandler)
        })
    }
    private func imageHandler( image: UIImage?) -> Void{
        
        let scaledImage = scaleImage(originalImage: image ?? UIImage(), radius: 200)
        self.image = scaledImage
        isShowImageLib = false
        isImgSelected = true
        if (step == 1) {
            step += 1
        }
        
        
    }
}

private struct EditShopNameView :View{
    
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var language: SystemLanguage
    
    @Binding var isShopNameEntered :Bool
    @Binding var text: String
    @Binding var step: Int
    @Binding var isEditing: Bool
    @Binding var isRepeatedName: Bool
    
    @State var test = false
    let textField: UITextField
    let completionHandler: () -> Void
    
    var body: some View{
        let context = language.content
        VStack(alignment:.leading){
            HStack {
                Text(context[ "AddShopFlowControlView_4"]!)
                    .fontWeight(.black)
                    .tracking(1)
                
                if (isShopNameEntered){
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: 0x32D74B))
                }
                if (isRepeatedName){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                
            }
            Text(context[ "AddShopFlowControlView_5"]!)
                .lineLimit(10)
                .font(.footnote)
                .foregroundColor(Color(hex: 0x48484A))
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 48)
                    .foregroundColor(Color(hex:0xE5E5EA))
                if isRepeatedName {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                        .frame(height: 48)
                        .foregroundColor(.red)
                }
                Group {
                    ShopNameTextField(isEditing: self.$isEditing, text: self.$text, completionHandler: completionHandler, textField: textField)
                        .frame(height: 40)
                }.padding(.horizontal, 15)
                
            }.offset(y:10)
            Spacer()
            //Text(text)
        }.padding(.trailing, 25)
    }
}


struct ShopCategorySelectView: View{
    @EnvironmentObject var language: SystemLanguage
    
    @Binding var isShopCategorySelected: Bool
    @Binding var category: [ShopCategory]
    @Binding var step :Int
    
    @State var isShowCategoryView = false
    
    var body: some View{
        let context = language.content
        let gray = Color(hex: 0x8E8E93)
        VStack(alignment:.leading){
            HStack {
                Text(context[ "AddShopFlowControlView_6"]!)
                    .fontWeight(.black)
                    .tracking(1)
                if (isShopCategorySelected){
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: 0x32D74B))
                }
                
            }
            Text(context[ "AddShopFlowControlView_7"]!)
                .lineLimit(10)
                .font(.footnote)
                .foregroundColor(Color(hex: 0x48484A))
            ZStack{
                
                VStack {
                    HStack{
                        Image("Shop_Category")
                        Text(context[ "AddShopFlowControlView_8"]!)
                            .font(.footnote)
                        Spacer()
                        if !isShopCategorySelected {
                            Text(context[ "AddShopFlowControlView_9"]!)
                                .font(.caption)
                                .foregroundColor(gray)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 10)
                                .foregroundColor(gray)
                        }
                        
                    }
                    if isShopCategorySelected {
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
                .padding()
            }
            .background(Color(.white))
            .onTapGesture {
                isShowCategoryView = true
            }
            .padding(.trailing, 25)
            
            
        }.fullScreenCover(isPresented: self.$isShowCategoryView, content: {
            CategorySelectView(
                selectedCat: self.$category,
                isShowShopCategoryView: self.$isShowCategoryView,
                isShopCategorySelected: self.$isShopCategorySelected)
        })
    }
}

struct AddShopBasicView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopBasicView(isShowAddShopBasic: .constant(false), isShowNextView: .constant(false), allData: .constant([]))
            .environmentObject(InternetTask())
            .environmentObject(SystemLanguage())
    }
}
