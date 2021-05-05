//
//  ProtocolView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/3/8.
//

import SwiftUI

private enum Options: String{
    case serviceProtocols = "服務條款"
    case privacyPolicies = "隱私條例政策"
    case productPolicies = "商品售後政策"
    case copyrightPolicies = "知識產權保護政策"
    case statement = "免責聲明"
    
}

struct ProtocolView: View {
    
    @Binding var dismiss:Bool
    
    @State private var selectedOptions: Options = Options.serviceProtocols
    @State private var oldOptions: Options = Options.serviceProtocols
    @State var isShowPicker = false
    
    
    var body: some View {
        
        ZStack {
            VStack {
                ZStack {
                    Rectangle().foregroundColor(.gray)
                        .frame(height:40)
                    HStack{
                        Spacer()
                        Button(action:{dismiss.toggle()}){
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }.padding(.horizontal, 20)
                }
                HStack {
                    Text(oldOptions.rawValue)
                    Spacer()
                    Button(action:{
                        withAnimation{
                            isShowPicker.toggle()
                        }
                    }){
                        Image("Chevron_Down")
                    }
                }.padding(.horizontal, 17)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(hex: 0xE5E5E5))
                ScrollView{
                    switch oldOptions{
                    case .serviceProtocols:
                        ServiceProtocolView()
                            .padding()
                    case .privacyPolicies:
                        PrivacyPoliciesView()
                            .padding()
                    case .productPolicies:
                        ProductPoliciesView()
                            .padding()
                    case .copyrightPolicies:
                        CopyrightPoliciesView()
                            .padding()
                    case .statement:
                        StatementView()
                            .padding()
                    
                    }
                    
                }.padding(.bottom, 0.07*UIScreen.screenHeight)
                
                
            }
            .ignoresSafeArea(edges:.top)
            VStack {
                Spacer()
                LogoView()
            }
            if isShowPicker {
                VStack (spacing: 0){
                    Spacer()
                    ZStack{
                        Rectangle()
                            .frame(height: 40)
                            .foregroundColor(Color(hex: 0xF0F0F0))
                        HStack{
                            Spacer()
                            Button(action: {
                                oldOptions = selectedOptions
                                withAnimation{
                                    isShowPicker = false
                                }
                                
                            }, label: {
                                Text("完成")
                            }).padding(.horizontal)
                        }
                    }
                    Picker("Test", selection: $selectedOptions) {
                        Text("服務條款").tag(Options.serviceProtocols)
                        Text("隱私條例政策").tag(Options.privacyPolicies)
                        Text("商品售後政策").tag(Options.productPolicies)
                        Text("知識產權保護政策").tag(Options.copyrightPolicies)
                        Text("免責聲明").tag(Options.statement)
                    }.background(Rectangle().foregroundColor(Color(hex:0xD6D7DC)))
                    
                }.ignoresSafeArea(edges: .bottom)
                .animation(.linear)
                .transition(.move(edge: .bottom))
            }
        }
        
    }
}

struct ProtocolView_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolView(dismiss: .constant(true))
    }
}

struct UIKLabel: UIViewRepresentable {

    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: TheUIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

struct ServiceProtocolView :View{
    var body: some View{
        let textColor = Color(hex: 0x48484A)
        VStack(alignment:.leading){
            Text("服務條款")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .baselineOffset(20)
            SPSubView1().foregroundColor(textColor)
            SPSubView2().foregroundColor(textColor)
        }
        
    }
}


struct PrivacyPoliciesView: View{
    var  body: some View{
        
        let textColor = Color(hex: 0x48484A)
        VStack(alignment:.leading){
            Text("隱私條例政策")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .baselineOffset(20)
            PPSubView().foregroundColor(textColor)
            //SPSubView2().foregroundColor(textColor)
        }
        
    }
}

struct ProductPoliciesView: View{
    var  body: some View{
        
        let textColor = Color(hex: 0x48484A)
        VStack(alignment:.leading){
            Text("商品販售政策")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .baselineOffset(20)
            PSPSubView().foregroundColor(textColor)
            //SPSubView2().foregroundColor(textColor)
        }
        
    }
    
}

struct CopyrightPoliciesView: View{
    var  body: some View{
        
        let textColor = Color(hex: 0x48484A)
        VStack(alignment:.leading){
            Text("知識產權保護政策")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .baselineOffset(20)
            CPSubView().foregroundColor(textColor)
            //SPSubView2().foregroundColor(textColor)
        }
        
    }
    
}

struct StatementView: View{
    var  body: some View{
        
        let textColor = Color(hex: 0x48484A)
        VStack(alignment:.leading){
            Text("免責聲明")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .baselineOffset(20)
            StatementSubView().foregroundColor(textColor)
            //SPSubView2().foregroundColor(textColor)
        }
        
    }
    
}
