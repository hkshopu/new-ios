//
//  AdddProductSpecView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/22.
//

import SwiftUI

struct AdddProductSpecView: View {
    let width = 0.9*UIScreen.screenWidth
    let height = 0.12*UIScreen.screenHeight
    @Binding var QPdismiss : Bool
    @Binding var Specdismiss : Bool
    @Binding var ProductSpec1 :String
    @Binding var ProductSpec2 :String
    @Binding var productSpecString1: [ProductSpecString]
    @Binding var productSpecString2: [ProductSpecString]
    @State var isSpec1EditOn = false
    @State var isSpec2EditOn = false
    @Binding var priceTemp : [[String]]
    @Binding var quntityTemp : [[String]]
    @State var ButtonCheck = false
    @State var currentTextField = UITextField()
    @State var isTriggeredByButton = false
    @State var isAnyEmpty = true
    @State var isString1Empty = false
    @State var isString2Empty = false
    //@State var QulityAndPrice:[[Int]]
    //@Binding var flow :AddProductFlow
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            VStack{
                SpecNavigationBar(dimiss: $Specdismiss, QPdissmiss: $QPdismiss, context: "新增規格")
                        .padding()
                            .frame(width:UIScreen.screenWidth*0.95)
                Spacer()
                HStack{
                    VStack{
                        //Spacer()
                        VStack(alignment: .leading){
                            HStack(spacing: 0.2*UIScreen.screenWidth){
                                TextField("請輸入商品規格", text: $ProductSpec1)
                                    .padding(.leading)
                                Button(action: {
                                    isSpec1EditOn.toggle()
                                    if isSpec2EditOn{
                                        isSpec2EditOn.toggle()
                                    }
                                }){
                                    if isSpec1EditOn {
                                        Text("完成")
                                    }else{
                                        Text("編輯")
                                    }
                                    
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:15)
                                        .foregroundColor(Color(hex: 0x979797))
                                }.foregroundColor(.gray)
                                
                            }
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color(hex:0xC4C4C4))
                            
                            HStack{
                                AddButton(currentTextField: self.$currentTextField, isTriggeredByButton: self.$isTriggeredByButton, productSpecString: self.$productSpecString1)
                                ScrollView(.horizontal){
                                    HStack(spacing : 4 ){
                                        
                                        ForEach(productSpecString1, id:\.self.id){ Item in
                                            ProductSpecView1(id: Item.id, productSpecString1s: self.$productSpecString1,isSpecEditOn: $isSpec1EditOn, isTriggeredByButton: self.$isTriggeredByButton, currentTextField: self.$currentTextField, isString1Empty: $isString1Empty)
                                        }
                                    }
                                }.onAppear{
                                    isString1Empty = false
                                }
                            }.padding(.horizontal, 8)
                            .frame(height:40, alignment: .center)
                            HStack(spacing: 0.2*UIScreen.screenWidth){
                                TextField("請輸入商品規格", text: $ProductSpec2)
                                    .padding(.leading)
                                Button(action: {
                                    isSpec2EditOn.toggle()
                                    if isSpec1EditOn{
                                        isSpec1EditOn.toggle()
                                    }
                                }){
                                    if isSpec2EditOn {
                                        Text("完成")
                                    }else{
                                        Text("編輯")
                                    }
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:15)
                                        .foregroundColor(Color(hex: 0x979797))
                                }.foregroundColor(.gray)
                                
                            }
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color(hex:0xC4C4C4))
                            
                            HStack{
                                AddButton(currentTextField: self.$currentTextField, isTriggeredByButton: self.$isTriggeredByButton, productSpecString: self.$productSpecString2)
                                ScrollView(.horizontal){
                                    HStack(spacing : 4 ){
                                        ForEach(productSpecString2, id:\.self.id){ Item in
                                            ProductSpecView2(id: Item.id, productSpecString2s: self.$productSpecString2,isSpecEditOn: $isSpec2EditOn, isTriggeredByButton: self.$isTriggeredByButton, currentTextField: self.$currentTextField, isString2Empty: $isString2Empty)
                                        }
                                    }
                                }.onAppear{
                                    isString2Empty = false
                                }
                            }.padding(.horizontal, 8)
                            .frame(height:40, alignment: .center)
                        }
                        HStack{
                            if isSpec1EditOn || isSpec2EditOn{
                                Button(action:{
                                    if isSpec1EditOn {
                                        productSpecString1.removeSubrange(1..<productSpecString1.count)
                                    }
                                    if isSpec2EditOn{
                                        productSpecString2.removeAll()
                                    }
                                }){
                                    Text("全部清空？")
                                        .foregroundColor(Color(hex: 0x1DBCCF, alpha: 1.0))
                                        .font(.footnote)
                                }
                            }
                        }.padding()
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight*0.2)

                    }
                    .frame(width: UIScreen.screenWidth*0.9, height: UIScreen.screenHeight*0.6, alignment: .center).padding()

                }
                
                Spacer()
                
                HStack{
                    Button(action:{
                        isAnyEmpty = false
                        //Next Step
                        //isAnyEmpty = false
                        //QulityAndPrice = Int([[ProductSpec1.count],ProductSpec2.count])
                        print("colum = \(productSpecString1.count)")
                        print("height =\(productSpecString2.count)")
                        if productSpecString1.isEmpty || productSpecString2.isEmpty{
                            isAnyEmpty = true
                        }else{
                            for productSpecString1 in productSpecString1{
                                if productSpecString1.text.isEmpty  {
                                    isAnyEmpty = true
                                }
                                for productSpecString2 in productSpecString2{
                                    if productSpecString2.text.isEmpty  {
                                        isAnyEmpty = true
                                    }
                                }
                            }
                        }
                        if isAnyEmpty {
                            ButtonCheck = true
                        }else{
                            for productSpecString1 in productSpecString1{
                                self.priceTemp.append([])
                                self.quntityTemp.append([])
                                for productSpecString2 in productSpecString2{
                                    print("productSpecString1= \(productSpecString1.id)"," productSpecString2= \(productSpecString2.id)")
                                    self.priceTemp[productSpecString1.id].append("")
                                    self.quntityTemp[productSpecString1.id].append("")
                                }
                            }
                            
                            QPdismiss.toggle()
                        }
                    }){
                        let buttonHeight = 0.08*UIScreen.screenHeight
                        ZStack{
                            if isString1Empty || isString2Empty || productSpecString1.isEmpty || productSpecString2.isEmpty || ProductSpec1.isEmpty || ProductSpec2.isEmpty{
                                RoundedRectangle(cornerRadius: buttonHeight/2)
                                    .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                    .foregroundColor(Color(hex: 0x1DBCCF))
                                RoundedRectangle(cornerRadius: buttonHeight/2-2)
                                    .frame(width : 0.7*UIScreen.screenWidth-4, height:buttonHeight-4)
                                    .foregroundColor(.bgColor)
                                Text("下一步，設定商品數量與價格")
                                    .foregroundColor(Color(hex: 0x1DBCCF))
                                    .fontWeight(.bold)
                            }else{
                                //let isAnyEmpty = true
                                RoundedRectangle(cornerRadius: buttonHeight/2)
                                    .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                    .foregroundColor(.mainTone)
                                Text("下一步，設定商品數量與價格")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }.alert(isPresented: $ButtonCheck)  { () -> Alert in
                        Alert(title: Text("錯誤"), message: Text("有新增之規格尚未填入任何資訊或是項目為零"))
                    }.disabled(isString1Empty || isString2Empty || ProductSpec1.isEmpty || ProductSpec2.isEmpty)
                }.padding()
            }.padding(.top, 40)
        }
        .ignoresSafeArea(.all)
        .onTapGesture {
            currentTextField.resignFirstResponder()
        }
        
    }
}


struct ProductSpecView1: View{
    
    let id: Int
    @Binding var productSpecString1s: [ProductSpecString]
    @Binding var isSpecEditOn : Bool
    @State var text = ""
    @Binding var isTriggeredByButton :Bool
    @Binding var currentTextField: UITextField
    @Binding var isString1Empty :Bool
    var body: some View{
        
        HStack{
            
            ZStack{
                //                    RoundedRectangle(cornerRadius: 10)
                //                        .stroke(lineWidth: 2)
                //                        .frame(width: 80, height:40, alignment: .center)
                HStack(spacing: 0){
                    if isSpecEditOn{
                        Button(action: {
                            let index = productSpecString1s.firstIndex(where: {$0.id == id})
                            //print(index)
                            productSpecString1s.remove(at: index!)
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                        }).frame(width: 20, height: 20, alignment: .center)
                    }
                    //Text(String(productSpecString1.id))
                    customTextField(text: self.$text, currentTextField: self.$currentTextField, placeholder: "輸入規格", tf: UITextField(), tfType: .default, completionHandler: completionHandler, alignment: .center , textColr: .white, font: UIFont(name: "SFNS", size: 14))
                        .multilineTextAlignment(.center)
                        .disabled(isSpecEditOn)
                        //.frame(width:UIScreen.screenWidth*0.25)
                }
                .padding(.horizontal, 8)
                .frame(height:40, alignment: .center)
                .alert(isPresented: $isString1Empty)  { () -> Alert in
                    Alert(title: Text("錯誤"), message: Text("有新增之規格尚未填入任何資訊"))
                }
            }.background(Color.mainTone)
            .cornerRadius(10)
            //.frame(width: 80, height:40, alignment: .center)
        }.onAppear(){
            text = productSpecString1s[id].text
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
            completionHandler()
        })
        
        
    }
    func completionHandler ()->Void{
        
        let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
        
        serialQueue.sync {
            
            if let index = productSpecString1s.firstIndex(where: {$0.id == id}){
                
                productSpecString1s[index].text = text
                print(productSpecString1s)

            }
        }        
    }
    
}
struct ProductSpecView2: View{
    
    let id: Int
    @Binding var productSpecString2s: [ProductSpecString]
    @Binding var isSpecEditOn : Bool
    
    @State var text = ""
    @Binding var isTriggeredByButton :Bool
    @Binding var currentTextField: UITextField
    @Binding var isString2Empty:Bool
    var body: some View{
        
        HStack{
            
            
            ZStack{
                //                    RoundedRectangle(cornerRadius: 10)
                //                        .stroke(lineWidth: 2)
                //                        .frame(width: 80, height:40, alignment: .center)
                HStack(spacing: 0){
                    if isSpecEditOn{
                        Button(action: {
                            let index = productSpecString2s.firstIndex(where: {$0.id == id})
                            //print(index)
                            productSpecString2s.remove(at: index!)
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                        }).frame(width: 20, height: 20)
                    }
                    //Text(String(productSpecString2.id))
                    
                    customTextField(text: self.$text, currentTextField: self.$currentTextField, placeholder: "輸入規格", tf: UITextField(), tfType: .default, completionHandler: completionHandler, alignment: .center , textColr: .white, font: UIFont(name: "SFNS", size: 14))
                        .multilineTextAlignment(.center)
                        .disabled(isSpecEditOn)
                        //.frame(width:UIScreen.screenWidth*0.25)
                }
                .padding(.horizontal, 8)
                .frame(height:40, alignment: .center)
                .alert(isPresented: $isString2Empty)  { () -> Alert in
                    Alert(title: Text("錯誤"), message: Text("有新增之規格尚未填入任何資訊"))
                }
            }.background(Color.mainTone)
            .cornerRadius(10)
            
        }.onAppear(){
            text = productSpecString2s[id].text
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
            completionHandler()
        })
        
        
    }
    func completionHandler ()->Void{
        if let index = productSpecString2s.firstIndex(where: {$0.id == id}){
            productSpecString2s[index].text = text
            
        }
    }
}

struct SpecNavigationBar: View {
    @Binding var dimiss: Bool
    @State var showInfo = false
    @Binding var QPdissmiss :Bool
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
                Button(action:{
                    showInfo.toggle()
                })
                {
                    //Back Button
                    Image(systemName: "info.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                        .foregroundColor(Color(hex: 0x1DBCCF, alpha: 1.0))
                }.alert(isPresented: $showInfo)  { () -> Alert in
                    Alert(title: Text(""), message: Text("當您要上架的商品有不同規格（例如：顏色、尺寸）時，則會需要使用商品規格功能，設定詳細商品規格，可以讓買家在購買時更清楚迅速的選擇。")
                          , primaryButton: .default(Text("前往幫助中心"), action: {
                            print("幫助中心")
                          }), secondaryButton: .default(Text("下一步"), action: {
                            print("OK")
                          }))
                }
                
            }
    }
}
func checkstringEmpty(Specstring: [ProductSpecString]) ->Bool{
    print("Check Empty:")
    print(Specstring)
    for item in Specstring {
        if item.text.isEmpty{
            return true
        }
    }
    return false
}

struct AddButton: View {
    
    @Binding var currentTextField: UITextField
    @Binding var isTriggeredByButton : Bool
    @Binding var productSpecString : [ProductSpecString]
    @State var isStringEmpty = false
    @State var disable = false
    
    var body: some View {
        ZStack {
            Button(action: {
                
                
                
                let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                
                serialQueue.sync {
                    
                    currentTextField.resignFirstResponder()
                    
                    if productSpecString.isEmpty{
                        productSpecString.append(ProductSpecString(id: (productSpecString.last?.id ?? -1 )+1))
                    }else{
                        if !checkstringEmpty(Specstring: productSpecString){
                            productSpecString.append(ProductSpecString(id: (productSpecString.last?.id ?? -1 )+1))
                            isStringEmpty = false
                        }else{
                            isStringEmpty = true
                        }
                    }
                    
                }
                isTriggeredByButton = true
                
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .frame(width: 80, height:40, alignment: .center)
                        .foregroundColor(.mainTone)
                    HStack{
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:15)
                            .foregroundColor(.mainTone)
                        Text("新增")
                            .foregroundColor(.black)
                        
                    }
                }
                
            }
            .alert(isPresented: $isStringEmpty)  { () -> Alert in
                Alert(title: Text("錯誤"), message: Text("有新增之規格尚未填入任何資訊"))
            }
            //.disabled(disable)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification), perform: { _ in
                print("kbs")
                disable = true
            })
            EmptyView().onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification), perform: { _ in
                print("kbh")
                disable = false
            })
        }
        
    }
}

