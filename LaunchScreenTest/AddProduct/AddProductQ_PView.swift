//
//  AddProductQ&PView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/4/21.
//
//(QPdismiss: $isQPShow,
// Specdismiss: $isSpecShow,
// ProductSpec1: $ProductSpec1,
// ProductSpec2: $ProductSpec2,
// productSpecString1: $productSpecString1,
// productSpecString2: $productSpecString2,
// QulityAndPrice:$QulityAndPrice)
import SwiftUI

struct AddProductQ_PView: View {
    let width = 0.9*UIScreen.screenWidth
    let height = 0.12*UIScreen.screenHeight
    @Binding var QPdismiss : Bool
    @Binding var Specdismiss : Bool
    @Binding var ProductSpec1 : String
    @Binding var ProductSpec2 : String
    @Binding var productSpecString1 : [ProductSpecString]
    @Binding var productSpecString2 : [ProductSpecString]
    @Binding var QulityAndPrice: [AddProductSpec]
    @Binding var priceTemp : [[String]]
    @Binding var quntityTemp : [[String]]
    @State var currentTextField = UITextField()
    @State var isEdited = false
    @State var i = 0
    @State var price = 0
    @State var quntity = 0
    @State var showalert = false
    @State var isAnyempty = false
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.bgColor)
            VStack{
                Q_PNavigationBar(dimiss: $QPdismiss, context: "設定庫存與價格")
                    .padding()
                        .frame(width:UIScreen.screenWidth*0.95)
                HStack{
                    ScrollView{
                            ForEach (productSpecString1) { SpecString1 in //規格
                                    HStack{
                                        Text("\(ProductSpec1)：")
                                            .font(.custom("SFNS", size: 14))
                                            .foregroundColor(.gray)
                                        Text(SpecString1.text)
                                            .font(.custom("SFNS", size: 14))
                                            .foregroundColor(.black)
                                        Spacer()
                                        //Text()
                                    }.padding()
                                    VStack{
                                        HStack{
                                            Text(ProductSpec2)
                                                .font(.custom("SFNS", size: 14))
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("價格")
                                                .font(.custom("SFNS", size: 14))
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("數量")
                                                .font(.custom("SFNS", size: 14))
                                                .foregroundColor(.gray)
                                        }.padding().frame(width: UIScreen.screenWidth*0.80)
                                        
//                                        customTextField(text: self.$text, currentTextField: self.$currentTextField, placeholder: "輸入規格", tf:
//                                        UITextField(), tfType: .default, completionHandler: completionHandler, alignment: .center , textColr: .white,
//                                        font: UIFont(name: "SFNS", size: 14))
//                                            .multilineTextAlignment(.center)
//                                            .disabled(isSpecEditOn)
                                        
                                        
                                        ForEach (productSpecString2) { SpecString2 in // 尺寸
                                                VStack{
//                                                    Text(SpecString2.text)
                                                    ProductQ_PView1(id1: SpecString1.id, id2: SpecString2.id,Tittle: SpecString2.text, currentTextField: $currentTextField
                                                                    , pricetemp: $priceTemp ,quntityTemp: $quntityTemp)
//                                                    TextField("HKD$0", text: $priceTemp[SpecString1.id][SpecString2.id],onEditingChanged:{flag in
//                                                        if flag{
//                                                            priceTemp[SpecString1.id][SpecString2.id] = ""
//                                                        }
//                                                    }, onCommit:{
//                                                        isEdited = true
//                                                        let prefix = "HKD$ "
//                                                        let s = prefix + String(priceTemp[SpecString1.id][SpecString2.id])
//
//                                                        if priceTemp[SpecString1.id][SpecString2.id].isEmpty{
//                                                            isEdited = false
//                                                        }else{
//                                                            priceTemp[SpecString1.id][SpecString2.id] = s
//                                                        }
//                                                    })
                                                    //.keyboardType(.numberPad)
//                                                    .multilineTextAlignment(.trailing)
//
//                                                    TextField("0", text: $quntityTemp[SpecString1.id][SpecString2.id],onEditingChanged:{flag in
//                                                        if flag{
//                                                            quntityTemp[SpecString1.id][SpecString2.id] = ""
//                                                        }
//                                                    })
//                                                    //.keyboardType(.numberPad)
//                                                    .multilineTextAlignment(.trailing)

                                                    
                                                }
                                                
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(20)
                                            
                                        
                                    }//.frame(width: width)
                                }
                            }
                        //Spacer()
                    }
                }
                .padding()
                .frame(width:UIScreen.screenWidth*0.95)
                //Spacer()
                HStack{
                    Button(action:{
                        isAnyempty = false
                        i = 0
                        price = 0
                        quntity = 0
                        print(priceTemp)
                        print(quntityTemp)
                        for productSpecString1 in productSpecString1{ //規格
                            for productSpecString2 in productSpecString2{ // 尺寸
                                //var price = Int(priceTemp[productSpecString1.id][productSpecString2.id])
                                if priceTemp[productSpecString1.id][productSpecString2.id].isEmpty || quntityTemp[productSpecString1.id][productSpecString2.id].isEmpty{
                                    isAnyempty = true
                                }

                            }
                        }
                        if isAnyempty{
                            showalert = true
                        }else{
                            for productSpecString1 in productSpecString1{ //規格
                                for productSpecString2 in productSpecString2{ // 尺寸
                                    print("開始產生資料 ")
                                    print("id===",productSpecString1.id,productSpecString2.id)
                                    print("text===",productSpecString1.text,productSpecString2.text)
                                    if !productSpecString1.text.isEmpty && !productSpecString2.text.isEmpty {
                                        print(productSpecString1.id,productSpecString2.id)
                                        print(priceTemp[productSpecString1.id][productSpecString2.id].dropFirst(5),quntityTemp[productSpecString1.id][productSpecString2.id])
                                        price = Int(priceTemp[productSpecString1.id][productSpecString2.id].dropFirst(5))!
                                        quntity = Int(quntityTemp[productSpecString1.id][productSpecString2.id])!
                                        self.QulityAndPrice.append(AddProductSpec(id: i, spec_desc_1: ProductSpec1,
                                                                                               spec_desc_2: ProductSpec2,
                                                                                               spec_dec_1_items: productSpecString1.text,
                                                                                               spec_dec_2_items: productSpecString2.text,
                                                                                               price: price,quantity: quntity))
                                        i=i+1
                                        print("產品規格書",self.QulityAndPrice)
                                    }
                                }
                            }
                            Specdismiss.toggle()
                            QPdismiss.toggle()
                        }
                        print(QulityAndPrice)
                    })
                    {
                        let buttonHeight = 0.08*UIScreen.screenHeight
                        ZStack{
                            if priceTemp.contains([""]) || quntityTemp.contains([""]){
                                RoundedRectangle(cornerRadius: buttonHeight/2)
                                    .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                    .foregroundColor(Color(hex: 0x1DBCCF))
                                RoundedRectangle(cornerRadius: buttonHeight/2-2)
                                    .frame(width : 0.7*UIScreen.screenWidth-4, height:buttonHeight-4)
                                    .foregroundColor(.bgColor)
                                Text("儲存")
                                    .foregroundColor(Color(hex: 0x1DBCCF))
                                    .fontWeight(.bold)
                            }else{
                                //let isAnyEmpty = true
                                RoundedRectangle(cornerRadius: buttonHeight/2)
                                    .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                    .foregroundColor(.mainTone)
                                Text("儲存")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }.disabled(priceTemp.isEmpty || quntityTemp.isEmpty )
                    .alert(isPresented: $isAnyempty)  { () -> Alert in
                        Alert(title: Text("錯誤"), message: Text("必填資訊不能為空或0"))
                    }
                }.padding()
            }.padding(.top, 40)
        }
        .ignoresSafeArea(.all)

    }
}

struct AddProductQ_PView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductQ_PView(QPdismiss: .constant(false),Specdismiss: .constant(false),ProductSpec1: .constant("spec"),ProductSpec2:.constant("size"),productSpecString1: .constant([ProductSpecString(id:1),ProductSpecString(id:2)]),productSpecString2: .constant([ProductSpecString(id:1),ProductSpecString(id:2)]), QulityAndPrice:.constant([AddProductSpec(id: 0, spec_desc_1: "", spec_desc_2: "", spec_dec_1_items: "", spec_dec_2_items: "", price: 0, quantity: 0)]),priceTemp: .constant([["", "", ""], ["", "", ""], ["", "", ""]]),quntityTemp: .constant([["", "", ""], ["", "", ""], ["", "", ""]]))
    }
}
struct Q_PNavigationBar: View {
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
struct ProductQ_PView1: View{
    let id1: Int
    let id2: Int
    @State var text1 = ""
    @State var text2 = ""
    @State var Tittle: String
    @Binding var currentTextField: UITextField
    @Binding var pricetemp : [[String]]
    @Binding var quntityTemp :[[String]]
    //@Binding var isString1Empty:Bool
    var body: some View{
        HStack{
            Text(Tittle)
            customTextField(text: self.$text1, currentTextField: self.$currentTextField, placeholder: "HKD$0", tf: UITextField(), tfType: .default, completionHandler: completionHandler, alignment: .center , textColr: .black, font: UIFont(name: "SFNS", size: 14))
                .multilineTextAlignment(.center)
            customTextField(text: self.$text2, currentTextField: self.$currentTextField, placeholder: "0", tf: UITextField(), tfType: .default, completionHandler: completionHandler, alignment: .center , textColr: .black, font: UIFont(name: "SFNS", size: 14))
                .multilineTextAlignment(.center)
            //.disabled(isSpecEditOn)
        
        }.onAppear(){
            text1 = pricetemp[id1][id2]
            text2 = quntityTemp[id1][id2]
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
            completionHandler()
        })
    }
    func completionHandler ()->Void{

        if !text1.hasPrefix("HKD$ "){
            text1 = "HKD$ \(text1)"
        }
        for (index, i) in pricetemp.enumerated() {
            for j in i {
                print("index = \(index),i = \(i) , j = \(j)")
//                if index == id1 || j == id2 {
//                    pricetemp[id1][id2] = text1
//                    quntityTemp[id1][id2] = text2
//                }
                print(i.indices,j.indices)
            }
        }
        pricetemp[id1][id2] = text1
        quntityTemp[id1][id2] = text2
        
//        if let index = productSpecString2s.firstIndex(where: {$0.id == id}){
//            productSpecString2s[index].text = text
//
//        }
    }
}

//private static func newArray() -> [[]]
