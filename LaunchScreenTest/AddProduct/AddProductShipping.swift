//
//  AddProductShopping.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/25.
//

import SwiftUI

struct AddProductShipping: View {
    @State var ProductWeight = ""
    @State var ProductLong = ""
    @State var ProductWidth = ""
    @State var ProductHeight = ""
    @Binding var productSize: ProductSize
    //@State var customShipping: [CustomShipping] = [CustomShipping(id:0)]
//    @State var shippingFee: [ShippingFee] = [ShippingFee(id: 0, title: "郵政", price: "100", isToggled: false), ShippingFee(id: 1, title: "順豐速運", price: "100", isToggled: false),ShippingFee(id: 2, title: "", price: "0", isToggled: false)]
        //@State var shippingFee: [ShippingFee] //= [ShippingFee(id: Int, title: String, price: Int)]
    
    
    @Binding var isShippingfeeShow : Bool
    @Binding var shippingFees: [ShippingFee]
    @Binding var isShippingfeeEdit : Bool
    @State var isEditOn = false
    
    @State var tittle = "運費"
    
    @State var showalert = false
    
    @State var isShippHasTrue = false
    @State var Tempweight = ""
    @State var Tempwidth = ""
    @State var Tempheight = ""
    @State var Templong = ""
    //view control
    //@Binding var flow :AddProductFlow
    
    var body: some View {
        let Strformatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            return formatter
        }()
        //let shippingfee = [ShippingFee(title: "郵政", price: "0"),ShippingFee(title: "順豐速運", price: "0")]
        let width = 0.9*UIScreen.screenWidth
        let height = 0.12*UIScreen.screenHeight
        //print("start")
        ZStack{
            Rectangle()
                .foregroundColor(.bgColor)
            //.frame(width:width, height: height)
            VStack{
                ProductShippNavigationBar(dimiss: $isShippingfeeShow, isEditOn: $isEditOn, context: tittle)
                    .padding()
                        .frame(width:UIScreen.screenWidth*0.95)
                //Spacer().frame(width: width, height: UIScreen.screenHeight*0.08)
                HStack{
                    VStack{
                        HStack{
                            Text("包裹重量(g)")
                            Text("*")
                                .fontWeight(.light)
                                .baselineOffset(-10)
                                .foregroundColor(.red)
                            Spacer()
                            TextField("設定重量", text: $Tempweight,onEditingChanged:{flag in
                                if flag{
                                    self.Tempweight = ""
                                }
                            })
                            .frame(width: UIScreen.screenWidth*0.3)
                            .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }.padding()
                        .onAppear(){
                            if productSize.ProductWeight > 0{
                                Tempheight = String(productSize.ProductHeight)
                                Templong = String(productSize.ProductLong)
                                Tempweight = String(productSize.ProductWeight)
                                Tempwidth = String(productSize.ProductWidth)
                            }
                            
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        VStack{
                            HStack{
                                Text("包裹尺寸大小")
                                Text("*")
                                    .fontWeight(.light)
                                    .baselineOffset(-10)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color(hex:0xC4C4C4))
                            HStack{
                                Text("長 / 寬 / 高 (cm)")
                                Text("*")
                                    .fontWeight(.light)
                                    .baselineOffset(-10)
                                    .foregroundColor(.red)
                                HStack{
                                    TextField("", text: $Templong,onEditingChanged:{flag in
                                        if flag{
                                            self.Templong = ""
                                        }
                                    })
                                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.914, green: 0.914, blue: 0.922)/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(5)
                                        .keyboardType(.numberPad)
                                    Text("/")
                                    TextField("", text: $Tempwidth,onEditingChanged:{flag in
                                        if flag{
                                            self.Tempwidth = ""
                                        }
                                    }).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.914, green: 0.914, blue: 0.922)/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(5)
                                        .keyboardType(.numberPad)
                                    Text("/")
                                    TextField("", text: $Tempheight,onEditingChanged:{flag in
                                        if flag{
                                            self.Tempheight = ""
                                        }
                                    }).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.914, green: 0.914, blue: 0.922)/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(5)
                                        .keyboardType(.numberPad)
                                }.multilineTextAlignment(.trailing)
                            }
                            .padding(.trailing)
                        }.padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        VStack{
                            ScrollView{
                                ForEach(shippingFees, id:\.self.id){ Item in
                                    CustomShippingView(shippingfee: $shippingFees[shippingFees.firstIndex(where: { (ShippingFee) -> Bool in
                                        ShippingFee.id == Item.id
                                    })!], shippingfees: self.$shippingFees,isEditOn: $isEditOn)
                                }
                            }.frame(height:UIScreen.screenHeight*0.4)
                        }
                        
                    }
                }
                Spacer()
                HStack{
                    Button(action:{
                        //Next Step
                        if Templong.isEmpty || Tempwidth.isEmpty || Tempweight.isEmpty || Tempheight.isEmpty{

                            showalert = true
                        }else{
                            productSize.ProductLong = Int(Templong)!
                            productSize.ProductWidth = Int(Tempwidth)!
                            productSize.ProductWeight = Int(Tempweight)!
                            productSize.ProductHeight = Int(Tempheight)!
                            //                            for i in shippingFees {
                            //                                if i.isToggled == true {
                            //                                    isShippHasTrue = true
                            //                                }
                            //                            }
                            //                            if !isShippHasTrue{
                            //                                showalert = true
                            //                            }else{
                            print(productSize)
                            print(shippingFees)
                            isShippingfeeEdit = true
                            isShippingfeeShow = false
                            //                            }
                        }
                    })
                    {
                        let buttonHeight = 0.08*UIScreen.screenHeight
                        ZStack{
                            if Templong.isEmpty || Tempwidth.isEmpty || Tempweight.isEmpty || Tempheight.isEmpty {
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
                    }.disabled(Templong.isEmpty || Tempwidth.isEmpty || Tempweight.isEmpty || Tempheight.isEmpty)
                    .alert(isPresented: $showalert)  { () -> Alert in
                        Alert(title: Text("錯誤"), message: Text("必填資訊不能為空或0，至少勾選一個運輸方式"))
                    }
                    
                }.padding()
            }.padding(.top, 40)
        }
        //.foregroundColor(.black)
        .ignoresSafeArea(.all)
    }
    
}
struct CustomShippingView: View{
    
    @Binding var shippingfee: ShippingFee
    @Binding var shippingfees: [ShippingFee]
    @Binding var isEditOn: Bool //按下變ture 編輯模式開始
    
    @State var deleteEnable = false
    @State var price = ""
    @State var isEdited = false
    var body: some View{
            let Strformatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .none
                return formatter
            }()
        HStack {
            if isEditOn && shippingfee.id != shippingfees.last!.id{
                Button(action: {
                    let index = shippingfees.firstIndex(where: {$0.id == shippingfee.id})
                    //                  print(index)
                    shippingfees.remove(at: index!)
                }, label: {
                    Text("Delete")
                })
            }
            
//            Text(String(customShipping.id))
//            Text(String(customShippings.last!.id))
            TextField("", text: self.$shippingfee.title)
            //.disabled(!isEditOn)
            TextField("HKD$0", text: self.$shippingfee.price ,onEditingChanged:{flag in
                if flag{
                    shippingfee.price = ""
                }
            }, onCommit:{
                isEdited = true
                let prefix = "HKD$ "
                let s = prefix + String(shippingfee.price)
                
                if shippingfee.price.isEmpty{
                    isEdited = false
                }else{
                    shippingfee.price = s
                }
            })
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
            //.disabled(!isEditOn)
            Toggle(isOn: self.$shippingfee.isToggled) {
                Text("")
            }.onChange(of: self.shippingfee.isToggled, perform: { value in
                
                if shippingfee.id == shippingfees.last!.id{
                    if shippingfee.isToggled {
                        if self.shippingfee.title.isEmpty {
                            shippingfee.isToggled = false
                        }else{
                            self.shippingfees.append(
                                ShippingFee(id: self.shippingfees.last!.id+1,title:"",price:"",isToggled: false))
                            //deleteEnable = !deleteEnable
                        }
                        
                    }
                }else{
                    if self.shippingfee.title.isEmpty {
                        shippingfee.isToggled = false
                    }else{
                        //self.isCustomOn = false
                    }
                }
            }).frame(width: UIScreen.screenWidth*0.15)
            
            
            
        }.padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}


struct AddProductShopping_Previews: PreviewProvider {
    static var previews: some View {
        AddProductShipping(productSize: .constant(ProductSize(ProductWeight: 0, ProductLong: 0, ProductWidth: 0, ProductHeight: 0)), isShippingfeeShow: .constant(true), shippingFees: .constant([ShippingFee(id: 0, title: "郵政", price: "HKD$ 100", isToggled: false), ShippingFee(id: 1, title: "順豐速運", price: "HKD$ 100",isToggled: false),ShippingFee(id: 2, title: "", price: "",isToggled: false)]), isShippingfeeEdit: .constant(false))
//        AddProductShipping(productSize: .constant(ProductSize(ProductWeight: 0, ProductLong: 0, ProductWidth: 0, ProductHeight: 0)), isShippingfeeShow: .constant(false), isShippingfeeEdit: .constant(false), shippingFee: [ShippingFee(id: 0, title: "郵政", price: "HKD$100", isToggled: false), ShippingFee(id: 1, title: "順豐速運", price: "HKD$100",isToggled: false),ShippingFee(id: 2, title: "", price: "",isToggled: false)])
    }
}

struct CustomShipping :Identifiable{
    let id:Int
    var text: String
    var num: String
    init(id: Int){
        self.id = id
        text = ""
        num = ""
    }
}

struct ProductShippNavigationBar: View {
    @Binding var dimiss: Bool
    @Binding var isEditOn:Bool
    
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
                    isEditOn.toggle()
                })
                {
                    if isEditOn{
                        Text("完成")
                            .foregroundColor(.mainTone)
                    }else{
                        Text("編輯")
                            .foregroundColor(.gray)
                    }
                }
            }//.padding(.horizontal, 30)
            //Spacer()
        
    }
}
