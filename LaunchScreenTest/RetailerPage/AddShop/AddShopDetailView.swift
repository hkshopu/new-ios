//
//  AddShopDetailView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/20.
//

import SwiftUI

struct AddShopDetailView: View {
    @EnvironmentObject var language: SystemLanguage
    @Binding var isShowBankDetail: Bool
    @Binding var isShowNextView: Bool
    @Binding var allData: [Data]
    
    @State var isShowAddressDetail = false
    @State var bankCode: String = ""
    @State var bankName: String = ""
    @State var bankAccountName: String = ""
    @State var bankAccount: String = ""
    
    @State var isFinish = false
    @State var currentTextField = UITextField()
    @State var test:String = ""
    var body: some View {
        let context = language.content
        ZStack {
            Rectangle()
                .foregroundColor(.bgColor)
            VStack(spacing: 20){
                BasicNavigationBar( context: context["AddBankAccount_1"]!, showRingView: false, buttonAction: {withAnimation{isShowBankDetail = false}})
                VStack{
                    TextElement(text: self.$bankCode, currentTextField: self.$currentTextField, placeHolder: context["AddBankAccount_2"]!, completionHandler: completionHandler, kbType: UIKeyboardType.numberPad)
                    
                    TextElement(text: self.$bankName, currentTextField: self.$currentTextField, placeHolder: context["AddBankAccount_3"]!, completionHandler: completionHandler, kbType: UIKeyboardType.default)
                    
                    TextElement(text: self.$bankAccountName, currentTextField: self.$currentTextField, placeHolder: context["AddBankAccount_4"]!, completionHandler: completionHandler,kbType: UIKeyboardType.default)
                    
                    TextElement(text: self.$bankAccount, currentTextField: self.$currentTextField, placeHolder: context["AddBankAccount_5"]!, completionHandler: completionHandler, kbType: UIKeyboardType.numberPad)
                    Text(context["AddBankAccount_6"]!)
                        .foregroundColor(Color(hex:0x8E8E93))
                        .font(.custom("SFNS", size: 12))
                        .lineSpacing(4)
                        .frame(width:0.9*UIScreen.screenWidth)
                }
                
                Spacer()
                BottomElement(isFinish: self.$isFinish, isShowNextView: self.$isShowNextView, allData: self.$allData,title1: context["AddBankAccountBottom_1"]!, title2: context["AddBankAccountBottom_2"]!, buttonText: context["AddBankAccountBottom_3"]!, step: 4, getBody: makeBody)
            }.padding(.top, 40)
        }.ignoresSafeArea()
        .onTapGesture {
            completionHandler()
        }
    }
    func completionHandler() ->Void{
        
        if (bankCode.isEmpty || bankName.isEmpty || bankAccount.isEmpty || bankAccountName.isEmpty){
            
            withAnimation {
                self.isFinish = false
            }
        }else{
            withAnimation{
                self.isFinish = true
            }
            
        }
        currentTextField.resignFirstResponder()
        //test.append("ya")
    }
    func makeBody(boundaries: String) -> Data{
        var body = Data()
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "bank_code", value: bankCode))
        
        //append shop title
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "bank_name", value: bankName))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "bank_account_name", value: bankAccountName))
        
        body.append(makeMultiformParamBody(boundaries: boundaries, key: "bank_account", value: bankAccount))
        
        return body
    }
}

struct AddShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopDetailView(isShowBankDetail: .constant(false), isShowNextView: .constant(false), allData: .constant([]))
            .environmentObject(SystemLanguage())
    }
}

private struct TextElement: View{
    
    @Binding var text: String
    @Binding var currentTextField: UITextField
    let placeHolder: String
    let completionHandler: ()->Void
    let kbType: UIKeyboardType
    
    let textField = UITextField()
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0, y: 4)
            HStack{
                customTextField(text: self.$text, currentTextField: self.$currentTextField, placeholder: placeHolder, tf: textField, tfType: kbType, completionHandler: completionHandler)
                //.font(.custom("SFNS", size: 14))
            }.padding(.horizontal, 20)
        }.frame(width: 0.9*UIScreen.screenWidth, height: 44, alignment: .center)
    }
    
}
private struct BottomElement:View{
    @Binding var isFinish: Bool
    @Binding var isShowNextView:Bool
    @Binding var allData: [Data]
    
    
    let title1: String
    let title2: String
    let buttonText:String
    let step: Int
    
    let getBody: (String)->Data
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
                                let body = getBody("TestBoundaries")
                                allData.append(body)
                                print(String(data: body, encoding: .utf8))
                                isShowNextView = true
                                
                            }){
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.mainTone)
                                        .frame(height: 42)
                                    
                                    Text(buttonText)
                                        .font(.custom("SFNS", size: 14))
                                        .foregroundColor(.white)
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
}
