//
//  AddProductView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/23.
//

import SwiftUI
import Photos

private enum ProductState{
    case new
    case secondHand
}
struct AddProductView: View {
    @EnvironmentObject var internetTask : InternetTask
    @EnvironmentObject var shopdata : ShopData
    @EnvironmentObject var userstatus : User
    @State var isShowIMGPicker = false
    @State var images: [UIImage] = []
    @State var assets: [PHAsset] = []
    
    @State var domain = "https://hkshopu.df.r.appspot.com"
    
    @State var productName: String = ""
    
    @State var productDescription: String = ""
    
    // category
    
    @State private var productState = ProductState.new
    
    @State var isSpecTriggered = false
    @State var price = ""
    
    @State var amount = ""
    @Binding var isShowAddprodut:Bool
    @Binding var isSpecShow:Bool
    @Binding var isCategoryShow:Bool
    //@Binding var isShippingfeeShow:Bool
    @Binding var isShippingFeeEdited : Bool
    @Binding var isShippingFeeShow : Bool
    @Binding var productSize:ProductSize
    @Binding var shippingFee: [ShippingFee]
    @Binding var productCategory: ProductCategory
    @Binding var QulityAndPrice: [AddProductSpec]
    //@State var isShippingFeeEdited = true
    @State var prepTime: String = ""
    //@State var isShowAddprodut = false
    @State var checkAnyEmpty = false
    @State var checkAnyShippment = false
    @State var alerttext = ""
    //@State var apireturn : APIReturn
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.bgColor)
            VStack {
                AddproductNavigationBar(dimiss: $isShowAddprodut, context: "新增商品")
                    .padding()
                        .frame(width:UIScreen.screenWidth*0.95)
//                BasicNavigationBar(context: "新增商品", showRingView: false) {
//                    isShowAddprodut = false
//                }
//                .padding(.vertical, 40)
//                .frame(width:UIScreen.screenWidth*0.95,height: UIScreen.screenHeight*0.15)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        Group{
                            AddPhoto(isShowIMGPicker: self.$isShowIMGPicker, images: self.$images, assets: self.$assets)
                            ProductNameView(text: self.$productName)
                            ProductDescriptionView(text: self.$productDescription)
                            ProductCategoryView(isCatShow: $isCategoryShow,productcatgory: self.$productCategory)
                            ProductStatusView(state: self.$productState)
                            ProductSpecView(isSpecToggled: self.$isSpecTriggered,isSepcShow: $isSpecShow,QulityAndPrice: $QulityAndPrice)
                        }
                        
                        if(!isSpecTriggered){
                            Group{
                                ProductPriceView( price: self.$price)
                                ProductAmountView( amount: self.$amount)
                            }
                            .animation(.spring())
                            .transition(.opacity)
                        }
                        Group{
                            ProductShippingFeeView(isShippingFeeShow: self.$isShippingFeeShow, shippingFee: self.$shippingFee, isShippingFeeEdited: $isShippingFeeEdited)
                            
                            ProductPromotionView()
                            ProductPrepView(value:self.$prepTime)
                        }
                        Group{
                            FacebookView()
                            IGView()
                        }
                        Spacer()
                        
                        
                    }//.padding(.vertical, 60)
                    .padding(.horizontal,20)
                }
                
                // Bottom Buttons
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height:90)
                        .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: 10, x: 0.0, y:-2)
                        
                    let pad = 0.12*UIScreen.screenWidth
                    HStack(spacing: 30){
                        Button(action:{
                            //TODO: Save Logic here
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 2)
                                    .frame(height:40)
                                    
                                Text("儲存")
                                    .font(.custom("SFNS", size: 14))
                                    
                            }.foregroundColor(Color(hex: 0x8E8E93))
                        }
                        Button(action:{
                            checkAnyEmpty = false
                            checkAnyShippment = false
                            // TODO: onBoard logic here
                            //AddProductApi(internetTask: internetTask, url: "https://hkshopu.df.r.appspot.com/product/save/", method: "POST")
                            if productDescription.isEmpty || productName.isEmpty || productCategory.category.title.isEmpty {
                                checkAnyEmpty = true
                            }
                            if price.isEmpty && amount.isEmpty{
                                if QulityAndPrice.isEmpty || !isSpecTriggered{
                                    checkAnyEmpty = true
                                }
                            }
                            for i in shippingFee {
                                if i.isToggled {
                                    checkAnyShippment = true
                                }
                            }
                            if !checkAnyShippment {
                                checkAnyEmpty = true
                            }
                            if !checkAnyEmpty{
                                AddproductApinosession()
                            }
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height:40)
                                    .foregroundColor(.mainTone)
                                Text("上架")
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(.white)
                            }
                                    
                            
                        }.alert(isPresented: $checkAnyEmpty)  { () -> Alert in
                            Alert(title: Text("錯誤"), message: Text("必填資訊不能為空"))
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }.padding(.top, 40)
        }
        .foregroundColor(.black)
        .ignoresSafeArea(.all)
        .onAppear{
            //if edit, call api to grab product info
        }

    }
    private func AddproductApinosession(){
        let decoder = JSONDecoder()
        var semaphore = DispatchSemaphore (value: 0)
        var apiReturn : APIReturn?
        var SpecList = ""
        var ShipList = ""
        var PicList = Data()
        if price.isEmpty {
            price = "0"
        }
        if amount.isEmpty {
            amount = "0"
        }
        if prepTime.isEmpty {
            prepTime = "0"
        }
        //if
        for (index,i) in QulityAndPrice.enumerated() {
            print(index,i)
            if index != 0 {
                if i.id != QulityAndPrice.last?.id{
                    SpecList = SpecList + "{\"price\":\(i.price),\"quantity\":\(i.quantity),\"spec_dec_1_items\":\"\(i.spec_dec_1_items)\",\"spec_dec_2_items\":\"\(i.spec_dec_2_items)\",\"spec_desc_1\":\"\(i.spec_desc_1)\",\"spec_desc_2\":\"\(i.spec_desc_2)\"},"
                }else{
                    SpecList = SpecList + "{\"price\":\(i.price),\"quantity\":\(i.quantity),\"spec_dec_1_items\":\"\(i.spec_dec_1_items)\",\"spec_dec_2_items\":\"\(i.spec_dec_2_items)\",\"spec_desc_1\":\"\(i.spec_desc_1)\",\"spec_desc_2\":\"\(i.spec_desc_2)\"}"
                }
            }
        }
        if SpecList.isEmpty{
            SpecList = "{\"price\":0,\"quantity\":0,\"spec_dec_1_items\":\"a\",\"spec_dec_2_items\":\"b\",\"spec_desc_1\":\"a\",\"spec_desc_2\":\"b\"}"
        }
        for i in shippingFee {
            if i.id != shippingFee.last?.id{
                if i.id != shippingFee.last!.id-1{
                    ShipList = ShipList + "{\"onoff\":\(i.isToggled),\"price\":\(Int(i.price.dropFirst(4)).unsafelyUnwrapped),\"shipment_desc\":\"\(i.title)\",\"shop_id\":0},"
                }else{
                    ShipList = ShipList + "{\"onoff\":\(i.isToggled),\"price\":\(String(Int(i.price.dropFirst(4)).unsafelyUnwrapped)),\"shipment_desc\":\"\(i.title)\",\"shop_id\":0}"
                }
            }
        }
//        PicList.append(Data("[".utf8))
//        for i in images {
//            if i != images.first{
//                //PicList = PicList + "," + (i.pngData())
//                PicList.append(Data(",".utf8))
//                PicList.append(i.pngData()!)
//            }else{
//                //PicList = (i.pngData())
//                //PicList.append(Data("\(i.pngData() ?? Data("Error in Image".utf8))".utf8))
//                PicList.append(i.pngData()!)
//            }
//
//
//        }
//        PicList.append(Data("]".utf8))
        //PicList = "[" + PicList + "]"
        print("規格list開始")
        print(SpecList)
        print("規格list結束")
        print("--------------")
        print("運費list開始")
        print(ShipList)
        print("運費list結束")
//        print(images,assets)
        let parameters = [
          [
            "key": "shop_id",
            "value": "\(shopdata.currentShopID)",
            //"value": "1", //test only
            "type": "text"
          ],
          [
            "key": "product_category_id",
            "value": "\(productCategory.category.id)",
            "type": "text"
          ],
          [
            "key": "product_sub_category_id",
            "value": "\(productCategory.sub_category.id)",
            "type": "text"
          ],
          [
            "key": "product_title",
            "value": "\(productName)",
            "type": "text"
          ],
          [
            "key": "quantity",
            "value": "\(amount)",
            "type": "text"
          ],
          [
            "key": "product_description",
            "value": "\(productDescription)",
            "type": "text"
          ],
          [
            "key": "product_price",
            "value": "\(price)",
            "type": "text"
          ],
          [
            "key": "shipping_fee",
            "value": "0",
            "type": "text"
          ],
          [
            "key": "weight",
            "value": "\(productSize.ProductWeight)",
            "type": "text"
          ],
          [
            "key": "new_secondhand",
            "value": "\(productState)",
            "type": "text"
          ],
          [
            "key": "product_pic_list",
            //"src": "\(assets)",
            "src": "",
            //"src": "\(PicList)",
            "type": "file"
          ],
          [
            "key": "product_spec_list",
            "value": "{ \"product_spec_list\" : [\(SpecList)] }",
            //"value": "{ \"product_spec_list\" : }",
            "type": "text"
          ],
          [
            "key": "user_id",
            "value": "\(userstatus.id)",
            //"value": "23",
            "type": "text"
          ],
          [
            "key": "length",
            "value": "\(productSize.ProductLong)",
            "type": "text"
          ],
          [
            "key": "width",
            "value": "\(productSize.ProductWidth)",
            "type": "text"
          ],
          [
            "key": "height",
            "value": "\(productSize.ProductHeight)",
            "type": "text"
          ],
          [
            "key": "shipment_method",
            "value": "[\(ShipList)]",
            "type": "text"
          ],
            [
            "key": "longterm_stock_up",
            "value": "\(prepTime)",
            "type": "text"
            ],
            [
            "key": "product_status",
            "value": "active",
            "type": "text"
            ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        var error: Error? = nil
        print("上架開始")
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body.append(Data("--\(boundary)\r\n".utf8))
                            body.append(Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8))
                if param["contentType"] != nil {
                    body.append(Data("\r\nContent-Type: \(param["contentType"] as! String)".utf8))
                }
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    print("key = \(paramName) , value = \(paramValue) , type = \(paramType)")
                    body.append(Data("\r\n\r\n\(paramValue)\r\n".utf8))
                    //print(String(decoding:body, as:UTF8.self))
                } else {
                    //圖片陣列
//                    body.append(Data("\r\n\r\n".utf8))
//                    body.append(PicList)
//                    body.append(Data("\r\n".utf8))
                    for i in images {
                        body += makeMultiformPNGBody(boundaries: "\(boundary)", key: "\(paramName)" , image: i)
                        
                    }
                    
                }
                //to do call mutiypngapi

            }
        }
        body.append(Data("--\(boundary)--\r\n".utf8));
        let postData = body
        //print(body)
        var request = URLRequest(url: URL(string: "https://hkshopu.df.r.appspot.com/product/save/")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        print(String(decoding:data, as:UTF8.self))
          semaphore.signal()
        }
        internetTask.isInternetProcessing = true
        print("start processing...")
        
        task.resume()
        semaphore.wait()
    }
}
private struct AddPhoto: View{
    
    @Binding var isShowIMGPicker: Bool
    @Binding var images: [UIImage]
    @Binding var assets: [PHAsset]
    //let paddingAmount : CGFloat
    
    var body: some View{
        ZStack{
            
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        Button(action:{
                            isShowIMGPicker = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 86, height: 86, alignment: .center)
                                    .foregroundColor(.mainTone)
                                VStack(spacing: 4){
                                    Text("+")
                                        .font(.custom("SFNS", size: 36))
                                    Text("加入照片")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }.foregroundColor(.white)
                            }
                            
                        }
                        ForEach(images, id: \.self){ image in
                            IMGElement(imageSet: self.$images, assets: self.$assets, image: image)
                            //圖
                        }
                        Spacer()
                        
                    }.padding(.horizontal, 35)
                }.frame(height: 108,alignment: .center)

        }.background(ElementBG())
        .fullScreenCover(isPresented: self.$isShowIMGPicker,
                         content: {
                            ImagePickerCoordinatorView(images: self.$images, assets: self.$assets)
                            
                         })
        //.padding(paddingAmount)
        
    }
}

private struct IMGElement: View{
    
    @Binding var imageSet: [UIImage]
    @Binding var assets: [PHAsset]
    
    let image: UIImage
    var body : some View{
        ZStack{
            
            Image(uiImage: CropSquareImgToCenter(image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 86)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Button(action:{
                let index = imageSet.firstIndex(of: image)
                withAnimation{
                    imageSet.remove(at: index!)
                }
                assets.remove(at: index!)
                
            }){
                Image("Remove_Product")
            }
            .offset(x:36, y:-33)
            if image == imageSet.first{
                Image("Cover_Photo").offset(y:30)
            }
            
        }
    }
}

private struct ProductNameView: View{
    
    @Binding var text: String
    var body: some View{
        VStack(alignment:.leading, spacing: 0){
            ElementTitle(title: "商品名稱", isMust: true)
            TextField("輸入商品名稱", text: self.$text, onEditingChanged: {_ in }, onCommit: {})
                .font(.custom("SFNS", size: 14))
                .offset(x:36)
        }
        .padding(.vertical,12)
        .background(ElementBG())
    }
}

private struct ProductDescriptionView: View{
    
    @Binding var text: String
    @State var height :CGFloat = CGFloat.zero
    
    var body: some View{
        VStack(alignment:.leading, spacing: 0){
            ElementTitle(title: "商品描述", isMust: true)
            ZStack(alignment:.leading){
                
                Text(text).foregroundColor(.clear).padding(6)
                    .background(GeometryGetterView())
                Text("輸入商品描述")
                    .font(.custom("SFNS", size: 14))
                    .foregroundColor(Color(hex:0xC9C9C9))
                    .opacity(text.isEmpty ? 1 : 0)
                TextEditor(text: $text)
                    .frame(height: height)
                    //.background(Rectangle().foregroundColor(.clear))
                    .offset(x:-4, y:2)
                    .onAppear{
                        UITextView.appearance().backgroundColor = .clear
                    }
                
                
                //.frame(idealHeight:30, maxHeight: 150)
                
                
            }
            .onPreferenceChange(ViewHeightKey.self) { height = $0 }
            .padding(.horizontal, 36)
            
            
            
            
        }
        .padding(.vertical,12)
        .background(ElementBG())
    }
}
private struct ProductCategoryView: View{
    // category to be declared here
    @Binding var isCatShow: Bool
    @Binding var productcatgory: ProductCategory
    var body: some View{
        ZStack {
            HStack {
                ElementTitle(title: "商品分類", isMust: true)
                Button(action:{
                    // show product category view
                    isCatShow.toggle()
                }){
                    if !productcatgory.category.title.isEmpty && !productcatgory.sub_category.title.isEmpty{
                        Text("\(productcatgory.category.title)>\(productcatgory.sub_category.title)")
                            .foregroundColor(.gray)
                    }else{
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: 0x8e8E93))
                    }
                }.offset(x:-36)
            }
        }.padding(.vertical, 12)
        .background(ElementBG())
    }
}
private struct ProductStatusView: View{
    @Binding var state: ProductState
    @State var rect: CGRect = CGRect.zero
    var body: some View{
        ZStack {
            HStack (spacing:3){
                Group {
                    Text("商品保存狀況")
                        .font(.custom("SFNS", size: 14))
                    Text("*")
                        .fontWeight(.light)
                        .baselineOffset(-10)
                        .foregroundColor(.red)
                }
                
                
                Spacer()
                ZStack{
                    let width = rect.width/2
                    let height = rect.height
                    RoundedRectangle(cornerRadius: 9)
                        .foregroundColor(Color(hex:0xC9C9C9))
                        .background(StatusGeometryGetter())
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(width: width-4, height: height-4)
                        .offset(x: (state == .new) ? -width/2 : width/2)
                    HStack{
                        Text("全新")
                            .frame(width:width-10, height:height-2)
                            .onTapGesture {
                                withAnimation{
                                    state = .new
                                }
                            }
                        Text("二手")
                            .frame(width:width-10, height:height-2)
                            .onTapGesture {
                                withAnimation{
                                    state = .secondHand
                                }
                            }
                        
                    }
                }.onPreferenceChange(StatusPreferenceKey.self) { value in
                    rect = value
                }
            }.padding(.horizontal, 36)
        }.padding(.vertical, 12)
        .background(ElementBG())
        .frame(height: 56)
    }
}

private struct ProductSpecView: View{
    // Specs to be declared here
    @Binding var isSpecToggled: Bool
    @Binding var isSepcShow: Bool
    @Binding var QulityAndPrice: [AddProductSpec]
    @State var SpecEdited = false
    var body: some View{
        VStack {
            HStack {
                ElementTitle(title: "商品規格", isMust: false)
                Toggle("", isOn: self.$isSpecToggled.animation())
                    .animation(.easeInOut)
                    .offset(x:-36)
                
                
            }
            if(isSpecToggled){
                
                Rectangle()
                    .frame(height:1)
                    .foregroundColor(Color(hex:0xC4C4C4))
                
                VStack(spacing: 16) {
                    Button(action:{
                        // TODO: Navigate to the spec view
                        isSepcShow.toggle()
                        SpecEdited.toggle()
                    }){
                        HStack{
                            Text("新增產品規格")
                                .font(.custom("SFNS", size: 14))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.foregroundColor(Color(hex: 0x1DBCCF))
                    }.padding(.horizontal, 36)
                    
                    HStack {
                        ElementTitle(title: "商品價格", isMust: true)
                        
                        // TODO: = HKD$ spec.min - HKD$ spec.max
                        //let ranked = shippingFee.sorted(by: { $0.price < $1.price})

                        let rankedPrice = QulityAndPrice.sorted (by: { $0.price < $1.price})
                        if(rankedPrice.count > 2){
                            let idx = rankedPrice.lastIndex
//                            {
//                                $0.title.isEmpty
//                            }
                            Text("HKD$ \(rankedPrice[1].price) - HKD$ \(rankedPrice.last!.price)")
                                .font(.custom("SFNS", size: 14))
                                .foregroundColor(.gray)
                                .padding(.trailing, 36)
                        }
                        else{
                            if (rankedPrice.count > 1) {
                                Text("HKD$ \(rankedPrice [1].price)")
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 36)
                            }
                        }
//
//                        Text("HKD -")
//                            .font(.custom("SFNS", size: 14))
//                            .foregroundColor(.gray)
//                            .padding(.trailing, 36)
                    }
                    HStack {
                        ElementTitle(title: "商品數量", isMust: true)
                        
                        // TODO: = minAmount - maxAmount
                        let rankedQuantity = QulityAndPrice.sorted (by: { $0.quantity < $1.quantity})
                        if(rankedQuantity.count > 2){
                            let idx = rankedQuantity.lastIndex
//                            {
//                                $0.title.isEmpty
//                            }
                            Text("\(rankedQuantity[1].quantity) - \(rankedQuantity.last!.quantity)")
                                .font(.custom("SFNS", size: 14))
                                .foregroundColor(.gray)
                                .padding(.trailing, 36)
                        }
                        else{
                            if (rankedQuantity.count > 1) {
                                Text(" \(rankedQuantity [1].quantity)")
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 36)
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
        }.padding(.vertical, 12)
        .background(ElementBG())
    }
}

private struct ProductPriceView: View{
    
    
    @Binding var price :String
    
    @State var isEdited = false
    var body: some View{
        HStack{
            ElementTitle(title: "商品價格", isMust: true)
            
            Group{
                
                HStack{
                    
                    TextField("請輸入商品價格", text: self.$price, onEditingChanged:{flag in
                        if flag{
                            price = ""
                        }
                    }, onCommit:{
                        isEdited = true
                        let prefix = "HKD$ "
                        let s = prefix + price
                        
                        if price.isEmpty{
                            isEdited = false
                        }else{
                            price = s
                        }
                    })
                    .font(.custom("SFNS", size: 14))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                }
                
                
            }.offset(x: -36)
        }
        .padding(.vertical,12)
        .background(ElementBG())
        
    }
}

private struct ProductAmountView: View{
    
    
    @Binding var amount :String
    
    var body: some View{
        HStack{
            ElementTitle(title: "商品數量", isMust: true)
            
            Group{
                
                
                TextField("請輸入商品數量", text: self.$amount)
                    .font(.custom("SFNS", size: 14))
                    .multilineTextAlignment(.trailing)
                
            }.offset(x: -36)
        }
        .padding(.vertical,12)
        .background(ElementBG())
        
    }
}
private struct ProductShippingFeeView: View{
    // Shipping fee binding object here
    @Binding var isShippingFeeShow: Bool
    @Binding var shippingFee: [ShippingFee]
    @Binding var isShippingFeeEdited: Bool
    var body: some View{
        VStack {
            HStack {
                ElementTitle(title: "運費", isMust: true)
                if( !isShippingFeeEdited ){
                    Button(action:{
                        // TODO: show product ShippingFee  view
                        isShippingFeeShow.toggle()
                        //isShippingFeeEdited.toggle()
                        for i in shippingFee {
                            //if i.isToggled{
                            print(i.title)
                            //}
                        }
                    }){
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(hex: 0x8e8E93))
                    }.offset(x:-36)
                }
                else{
                    
                    let range = shippingFee.filter { (i) -> Bool in
                        return i.isToggled == true
                    }
                    let ranked = range.sorted(by: { $0.price < $1.price})
                    Group{
                        if(ranked.count > 1){
//                            let idx = ranked.lastIndex {
//                                $0.title.isEmpty
//                            }
                            Text("\(ranked.first!.price) - \(ranked.last!.price)")
                                .font(.custom("SFNS", size: 14))
                        }
                        else{
                            if ranked.count == 0{
                                Text("沒有選擇任何運輸方式")
                                    .font(.custom("SFNS", size: 14))
                            }else{
                                Text(" \(ranked[0].price)")
                                    .font(.custom("SFNS", size: 14))
                            }
                        }
                        Button(action:{
                            // TODO: show product ShippingFee  view
                            isShippingFeeShow.toggle()
                            
                        }){
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(hex: 0x8e8E93))
                        }
                    }
                    .foregroundColor(Color(hex: 0x48484A))
                    .offset(x: -36)
                    
                }
            }
            
            if (isShippingFeeEdited){
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: 0xC4C4C4))
                VStack(spacing: 16){
                    ForEach(shippingFee, id: \.self.id){ item in
                        if( !item.title.isEmpty && item.isToggled){
                            ShippingFeeElement(title: item.title, price: item.price)
                        }
                    }
                }.padding(.top, 14)
            }
        }.padding(.vertical, 12)
        .background(ElementBG())
    }
}
private struct ShippingFeeElement: View{
    
    let title: String
    let price: String
    
    var body: some View{
        HStack{
            Text(title)
                .font(.custom("SFNS", size: 14))
            Spacer()
            Text("\(price)")
                .font(.custom("SFNS", size: 14))
                .foregroundColor(Color(hex: 0x48484A))
        }.padding(.horizontal, 36)
    }
}

private struct ProductPromotionView: View{
    // TODO: Logic to be confirmed
    //Promotion to be declared here
    var body: some View{
        ZStack {
            HStack {
                ElementTitle(title: "廣告與行銷活動", isMust: false)
                Button(action:{
                    // show product category view
                }){
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: 0x8e8E93))
                }.offset(x:-36)
            }
        }.padding(.vertical, 12)
        .background(ElementBG())
    }
}

private struct ProductPrepView: View{
    
    @State var isChecked = false
    @Binding var value: String
    
    var body: some View{
        Group {
            HStack (spacing:3){
                
                
                CheckBox(isChecked: self.$isChecked)
                
                Text( isChecked ? "較長備貨天數" : "需要較長備貨嗎？")
                    .font(.custom("SFNS", size: 14))
                
                Spacer()
                
                if(isChecked){
                    TextField("請輸入備貨時間", text: self.$value)
                        .font(.custom("SFNS", size: 14))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    
                }
                
            }.padding(.horizontal, 36)
        }
        .padding(.vertical, 14)
        .background(ElementBG())
    }
}

private struct FacebookView: View{
    
    @State var isChecked = false
    
    var body: some View{
        Group {
            HStack (spacing:3){
                
                
                Image("FB_product")
                
                Text( "分享到Facebook")
                    .font(.custom("SFNS", size: 14))
                
                Spacer()
                
                Toggle(isOn: self
                        .$isChecked, label: {})
                
            }.padding(.horizontal, 36)
            
        }
        .padding(.vertical, 14)
        .background(ElementBG())
    }
}

private struct IGView: View{
    
    @State var isChecked = false
    
    var body: some View{
        Group {
            HStack (spacing:3){
                
                
                Image("IG_product")
                
                Text( "分享到Instagram")
                    .font(.custom("SFNS", size: 14))
                
                Spacer()
                
                Toggle(isOn: self
                        .$isChecked, label: {})
                
            }.padding(.horizontal, 36)
            
        }
        .padding(.vertical, 14)
        .background(ElementBG())
    }
}

private struct ElementTitle:View{
    let title: String
    let isMust: Bool
    var body: some View{
        HStack (spacing:3){
            Text(title)
                .font(.custom("SFNS", size: 14))
            if (isMust) {
                Text("*")
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .offset(y:7)
            }
            
            Spacer()
        }.padding(.horizontal, 36)
    }
}
private struct StatusGeometryGetter: View{
    //let state: ProductState
    var body: some View{
        GeometryReader{ geometry in
            Rectangle()
                .foregroundColor(.clear)
                .preference(key: StatusPreferenceKey.self, value: geometry.frame(in: .local))
        }
    }
}

private struct StatusPreferenceKey: PreferenceKey{
    typealias Value = CGRect
    static var defaultValue: CGRect = CGRect.zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
private struct ElementBG: View{
    var body: some View{
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(.white)
    }
}
//struct AddProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddProductView(isShowAddprodut: true, isShowAddprodut: true, isSpecShow: .constant(false), isCategoryShow: .constant(false),isShippingFeeEdited: .constant(false), isShippingFeeShow: .constant(false), shippingFee: .constant([ShippingFee(id: 0, title: "郵政", price: "HKD$ 100", isToggled: false), ShippingFee(id: 1, title: "順豐速運", price: "HKD$ 100",isToggled: false),ShippingFee(id: 2, title: "", price: "",isToggled: false)]), productCategory: .constant(ProductCategory(category: ConvertedMainCategory(id: 1, selected_img: UIImage(), unselected_img: UIImage(), title: "", seq: 1, hex: "000000"), sub_category: ConvertedSubCategory(id: 1, selected_img: UIImage(), title: "", seq: 1))),QulityAndPrice:.constant([AddProductSpec(id: 0, spec_desc_1: "", spec_desc_2: "", spec_dec_1_items: "", spec_dec_2_items: "", price: 0, quantity: 0)]), productSize: ProductSize(ProductWeight: 100, ProductLong: 40, ProductWidth:30))
//    }
//}


private struct GeometryGetterView: View {
    
    //@Binding var ViewHeightKey:CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            let value = geometry.frame(in: .local).size.height
            
            Color.clear.preference(key: ViewHeightKey.self, value: value  )
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
struct ViewSizeKey: PreferenceKey{
    typealias Value = CGSize
    static var defaultValue = CGSize.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let size = nextValue()
        let width = size.width
        let height = size.height
        print(width)
        print(height)
        value = CGSize(width: value.width + width, height: value.height + height)
        
    }
}
struct StatusElementView: View {
    
    let width: CGFloat
    let height: CGFloat
    let title: String
    
    var body: some View {
        Text(title)
            .background(Rectangle().frame(width: width, height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
    }
}
struct TextViewGeometryGetterView: View {
    
    //@Binding var ViewHeightKey:CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            let value = geometry.frame(in: .local).size.height
            
            Color.clear.preference(key: ViewHeightKey.self, value: value  )
        }
    }
}
struct AddproductNavigationBar: View {
    @Binding var dimiss: Bool
    //@State var showInfo = false
    
    let context: String
    var body: some View {
            HStack{
                Button(action:{
                    dimiss.toggle()
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
            }
    }
}
