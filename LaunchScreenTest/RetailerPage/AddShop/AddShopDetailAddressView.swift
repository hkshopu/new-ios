//
//  AddShopDetailAddressView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/21.
//

import SwiftUI

struct AddShopDetailAddressView: View {
    @EnvironmentObject var language: SystemLanguage
    @Binding var isShowAddressDetail: Bool
    @Binding var isShowAddShopView: Bool
    @Binding var allData: [Data]
    @Binding var flow: RetailerPageFlow
    
    @State var isFinish = false
    @State var name = ""
    @State var phone = ""
    @State var countryCode = ""
    @State fileprivate var address = Address()
    @State var currentTF = UITextField()
    var body: some View {
        let context = language.content
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                BasicNavigationBar( context: context["AddShopAddress_1"]!, showRingView: false, buttonAction: {
                    withAnimation{
                        isShowAddressDetail = false
                        
                    }
                    allData.removeLast()
                    
                })
                VStack(spacing:0) {
                    ScrollView(.vertical) {
                        VStack{
                            let tf1 = customTextField(text: self.$name, currentTextField: self.$currentTF, placeholder: context["AddShopAddress_3"]!, tf: UITextField(), tfType: UIKeyboardType.default, completionHandler: completionHandler)
                                .frame(width: 0.9*UIScreen.screenWidth, height: 20, alignment: .center)
                                .offset(x:20)
                            BodyElement(title: context["AddShopAddress_2"]!, view: AnyView(tf1) )
                            
                            
                            BodyElement(title: context["AddShopAddress_4"]!, view: AnyView(PhoneNumberView(currentTF: self.$currentTF, countryCode: self.$countryCode, phone: self.$phone, completionHandler: completionHandler)) )
                            BodyElement(title: context["AddShopAddress_6"]!, view: AnyView(AddressView(currentTF: self.$currentTF, address: self.$address, completionHandler: completionHandler)))
                        }
                        .padding(.bottom,20)
                    }
                    
                    
                    BottomElement(isFinish: self.$isFinish,
                                  name: self.$name,
                                  phone: self.$phone,
                                  countryCode: self.$countryCode,
                                  address: self.$address,
                                  allData: self.$allData,
                                  flow: self.$flow,
                                  isShowAddShop: self.$isShowAddShopView,
                                  title1: context["AddBankAddressBottom_1"]!,
                                  title2: context["AddBankAddressBottom_2"]!,
                                  buttonText: context["AddBankAddressBottom_3"]!,
                                  step: 5)
                }
            }.padding(.top, 40)
        }
        .ignoresSafeArea()
        .onTapGesture {
            //print("hello")
            completionHandler()
        }
    }
    func completionHandler()->Void{
        if (address.region.isEmpty || address.territory.isEmpty || address.street.isEmpty || address.no.isEmpty || address.other.isEmpty || address.floor.isEmpty || address.room.isEmpty){
            
            withAnimation {
                self.isFinish = false
            }
        }else{
            withAnimation{
                self.isFinish = true
            }
            
        }
        currentTF.resignFirstResponder()
    }
}
private struct AddressView: View{
    @EnvironmentObject var language: SystemLanguage
    @Binding var currentTF: UITextField
    @Binding fileprivate var address: Address
    let completionHandler: ()->Void
    var body: some View{
        let context = language.content
        VStack{
            HStack(spacing:8){
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.territory, placeholder: context["AddShopAddress_7"]!,completionHandler: completionHandler, ratio: 0.39, kbType: UIKeyboardType.default)
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.region, placeholder: context["AddShopAddress_8"]!,completionHandler: completionHandler, ratio: 0.39, kbType: UIKeyboardType.default)
            }
            HStack(spacing:8){
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.street, placeholder: context["AddShopAddress_9"]!,completionHandler: completionHandler, ratio: 0.49, kbType: UIKeyboardType.default)
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.no, placeholder: context["AddShopAddress_10"]!,completionHandler: completionHandler, ratio: 0.29, kbType: .numberPad)
            }
            AddressViewElement(currentTF: self.$currentTF, text: self.$address.other, placeholder: context["AddShopAddress_11"]!,completionHandler: completionHandler, ratio: 0.8, kbType: .default)
            HStack(spacing:8){
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.floor, placeholder: context["AddShopAddress_12"]!,completionHandler: completionHandler, ratio: 0.39, kbType: .numberPad)
                AddressViewElement(currentTF: self.$currentTF, text: self.$address.room, placeholder: context["AddShopAddress_13"]!,completionHandler: completionHandler, ratio: 0.39, kbType: .numberPad)
            }
        }
    }
}
private struct PhoneNumberView:View{
    @EnvironmentObject var language: SystemLanguage
    
    @Binding var currentTF: UITextField
    @Binding var countryCode: String
    @Binding var phone: String
    
    let kbType = UIKeyboardType.numberPad
    let completionHandler: ()->Void
    var body :some View{
        let context = language.content
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(hex: 0xF6F6F6))
                
                
                HStack {
                    Text("+852")
                        .font(.custom("SFNS", size: 14))
                    //customTextField(text: self.$countryCode, currentTextField: self.$currentTF, placeholder: context["AddShopAddress_14"]!, tf: UITextField(), tfType: kbType, completionHandler: completionHandler)
                    Spacer()
                }.padding(.horizontal, 16)
            }.frame(width: 0.24*UIScreen.screenWidth, height: 44)
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(hex: 0xF6F6F6))
                
                HStack {
                    customTextField(text: self.$phone, currentTextField: self.$currentTF, placeholder: context["AddShopAddress_5"]!, tf: UITextField(), tfType: kbType, completionHandler: completionHandler)
                }.padding(.horizontal, 16)
            }.frame(width: 0.54*UIScreen.screenWidth, height:44)
        }
    }
}
private struct AddressViewElement:View{
    @Binding var currentTF: UITextField
    @Binding var text: String
    let placeholder: String
    let completionHandler: ()->Void
    let ratio:CGFloat
    let kbType : UIKeyboardType
    
    @State var test = ""
    
    let tf = UITextField()
    
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(hex: 0xF6F6F6))
            
            HStack {
                customTextField(text: self.$text, currentTextField: self.$currentTF, placeholder: placeholder, tf: tf, tfType: kbType, completionHandler: completionHandler)
            }.padding(.horizontal, 16)
        }.frame(width: ratio*UIScreen.screenWidth, height: 44, alignment: .center)
    }
}
private struct BodyElement:View{
    let title :String
    let view: AnyView
    
    @State var viewHeight = CGFloat.zero
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 5, x: 0
                        , y: 4)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }.padding(.horizontal,20)
                view.background(TextViewGeometryGetterView())
            }
            
        }.onPreferenceChange(ViewHeightKey.self){
            viewHeight = $0
        }
        .frame(width: 0.9*UIScreen.screenWidth, height: viewHeight+50, alignment: .center)
    }
}
private struct BottomElement:View{
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    @EnvironmentObject var userStatus: User
    @Binding var isFinish: Bool
    @Binding var name: String
    @Binding var phone: String
    @Binding var countryCode: String
    @Binding var address:Address
    @Binding var allData:[Data]
    @Binding var flow: RetailerPageFlow
    @Binding var isShowAddShop: Bool
    @State var isProgressing = false
    let title1: String
    let title2: String
    let buttonText:String
    let step: Int
    
    
    var body: some View{
        ZStack(alignment: .bottom){
            RoundedRectangle(cornerRadius: 32)
                .foregroundColor(.white)
            VStack(spacing : 20){
                Spacer()
                VStack(alignment: .leading, spacing: 16){
                    HStack (spacing: 12){
                        Text(title1)
                            .font(.body)
                            .fontWeight(.bold)
                        if(isFinish){
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: 0x32D74B))
                                .animation(.easeInOut)
                        }
                    }
                    Text(title2)
                        .font(.custom("SFNS", size: 14))
                        .foregroundColor(Color(hex: 0x48484A))
                }.padding(.horizontal, 36)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.bgColor)
                    HStack(spacing: 8){
                        Text("Step \(String(step))")
                            .font(.body)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 0){
                            if (step == 4){
                                Circle()
                                    .foregroundColor(.mainTone)
                                    .frame(width: 8, height: 8, alignment: .center)
                                Rectangle()
                                    .frame(width: 40, height: 1, alignment: .center)
                                    .foregroundColor(Color(hex:0x8E8E93))
                                Circle()
                                    .stroke()
                                    .foregroundColor(Color(hex:0x8E8E93))
                                    
                                    .frame(width: 8, height: 8, alignment: .center)
                            }
                            else{
                                Circle()
                                    .foregroundColor(Color(hex: 0x8E8E93))
                                    .frame(width: 8, height: 8, alignment: .center)
                                Rectangle()
                                    .frame(width: 40, height: 1, alignment: .center)
                                    .foregroundColor(Color(hex:0x8E8E93))
                                Circle()
                                    .foregroundColor(.mainTone)
                                    .frame(width: 8, height: 8, alignment: .center)
                            }
                        }
                        Spacer()
                        
                        if !isFinish{
                            ZStack {
                                Capsule()
                                    .stroke()
                                    .foregroundColor(.mainTone)
                                    .frame(height: 42)
                                
                                Text(buttonText)
                                    .font(.custom("SFNS", size: 14))
                                    .foregroundColor(.mainTone)
                                
                            }
                            
                        }else{
                            Button(action:{
                                
                                isProgressing = true
                                let body = makeBody(boundaries: "TestBoundaries")
                                
                                allData.append(body)
                                
                                var multiPartBody = Data()
                                print("Detail Start here...")
                                print(allData.count)
                                for data in allData {
                                    
                                    multiPartBody.append(data)
                                }
                                multiPartBody.append(Data("--\("TestBoundaries")--\r\n".utf8))
                                
                                print(String(data: body, encoding: .utf8))
                                let apiReturn = makeMultipartAPICall(internetTask: internetTask, url: "\(internetTask.domain)shop/save/", boundary: "TestBoundaries", body: multiPartBody)
                                if apiReturn.status == 0 {
                                    shopData.currentShopID = apiReturn.shop_id
                                    
                                    
                                    
                                    updateShopList()
                                    getShopDetail()
                                    
                                    flow = .shop
                                    isShowAddShop = false
                                }
                            }){
                                if !isProgressing{
                                    ZStack {
                                        Capsule()
                                            .foregroundColor(.mainTone)
                                            .frame(height: 42)
                                        
                                        Text(buttonText)
                                            .font(.custom("SFNS", size: 14))
                                            .foregroundColor(.white)
                                    }
                                }else{
                                    ProgressView()
                                        
                                }
                            }
                        }
                        
                        
                    }.padding(.horizontal, 36)
                }
                .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: 5, x: 0, y: 2)
                .frame(height:89)
            }
            
            
        }.frame(height: 212)
        .shadow(color: Color(hex: 0x000000, alpha: 0.1), radius: 5, x: 0, y: 2)
    }
    private func updateShopList(){
        
        var list: [Shop] = []
        var apiReturn : Data?
        let id = userStatus.id.unsafelyUnwrapped
        
        apiReturn = makeAPIGeneralCall(internetTask: internetTask, url: "\(internetTask.domain)user/\(String(id))/shop/", method: "GET", parameters: "")
        
        //                        }
        let decoder = JSONDecoder()
        do{
            let response =  try decoder.decode(APIGeneralReturn<[apiShop]>.self, from: apiReturn!)
            let shops = response.data
            
            for shop in shops{
                list.append(Shop(id: shop.id,
                                 name: shop.shop_title,
                                 iconURL: shop.shop_icon,
                                 product_count: shop.product_count,
                                 rating: shop.rating,
                                 follower: shop.follower,
                                 income: shop.income))
            }
            
        }catch{
            print("Error in data decoding!")
        }
        shopData.shop = list
    }
    private func getShopDetail(){
        let data = makeAPIGeneralCall(internetTask: internetTask, url: "\(internetTask.domain)shop/\(String(shopData.currentShopID!))/show/", method: "GET", parameters: "")
        let decoder = JSONDecoder()
        print(String(data: data, encoding: .utf8))
        do{
            let decoded = try decoder.decode(APIGeneralReturn<ShopDetail>.self, from: data)
            if decoded.status == 0{
                shopData.currentShop.detail = decoded.data
                shopData.currentShop.shopIMGs = ShopIMGs(ShopIconURL: decoded.data.shop_icon, ShopPicURL: decoded.data.shop_pic, ShopDescriptionURL: "")
                updateCategory()
            }
        }catch{
            print("Error in ShopDetail Data decoding!!!")
        }
    }
    func makeBody(boundaries: String) -> Data{
        var body = Data()
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_name", value: name))
        
        //append shop title
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_country_code", value: "852"))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_phone", value: phone))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_area", value: address.territory))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_district", value: address.region))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_road", value: address.street))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_number", value: address.no))
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_other", value: address.other))
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_floor", value: address.floor))
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "address_room", value: address.room))
        
        
        return body
    }
    func updateCategory(){
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
            print(temp)
            shopData.currentShop.categorys = temp
        }catch{
            print("Error in decoding Category!!!")
        }
    }
}

private struct Address{
    
    var territory : String
    var region : String
    var street : String
    var no : String
    var other : String
    var floor : String
    var room : String
    
    init(){
        territory = ""
        region = ""
        street = ""
        no = ""
        other = ""
        floor = ""
        room = ""
    }
}

struct AddShopDetailAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopDetailAddressView(isShowAddressDetail: .constant(true), isShowAddShopView: .constant(false), allData: .constant([]), flow: .constant(.shop))
            .environmentObject(SystemLanguage())
    }
}
