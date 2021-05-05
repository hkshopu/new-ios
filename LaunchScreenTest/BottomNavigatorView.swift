//
//  BottomNavigatorView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/10.
//

import SwiftUI

struct BottomNavigatorView: View {
    
    @EnvironmentObject var internetTask: InternetTask
    @EnvironmentObject var shopData: ShopData
    @EnvironmentObject var userStatus: User
    @Binding var mainFlow : MainFlow
    @Binding var previous: MainFlow
    @Binding var animationControl: Bool
    @Binding var middleAnimationControl: Bool
    
    @State var touchedElement = 0
    @State var tic = 0
    @State var tapped = false
    @State var isElementTapped :[Bool] = [false, false, false]
    @State var flowQueue: [MainFlow] = [.home]
    @State var barWidth :CGFloat = 70
    @State var offset :CGFloat = 0
    
    //@State var test = ""
    
    let distance = 0.2*UIScreen.screenWidth
    let threshold :CGFloat = 22
    
    let timer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
    
    var body: some View {
        
        let barHeight = 0.06*UIScreen.screenHeight
        let myColor = Color(hex: 0x1DBCCF)
        
        
        ZStack{
            Rectangle()

                .frame(height: 2*barHeight)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: barHeight/2)
                .frame(width: tapped ? 20 : barWidth , height: barHeight)
                .foregroundColor(myColor)
                .offset(x:offset)
            
            HStack(spacing: distance){
                Element(touchedElement: $touchedElement, id: 0, image: "home", text: "首頁")
                    .onTapGesture {
                        tapped = true
                        isElementTapped[0] = true
                        elementTapped(id: 0)
                        
                        mainFlow = MainFlow.home
                        flowQueue.append(.home)
                        if flowQueue.count>2{
                            flowQueue.removeFirst()
                        }
                        previous = flowQueue.first!
                    }
                    .onReceive(timer, perform: { _ in
                        if isElementTapped[0]{
                            animate(id: 0)
                        }
                    })
                Element(touchedElement: $touchedElement, id: 1, image: "customer", text: "我的")
                    .onTapGesture {
                        tapped = true
                        isElementTapped[1] = true
                        elementTapped(id: 1)
                        mainFlow = .customer
                        flowQueue.append(.customer)
                        if flowQueue.count>2{
                            flowQueue.removeFirst()
                        }
                        previous = flowQueue.first!
                        
                        
                        print("previous=\(previous)")
                        print("mainflow=\(mainFlow)")
                        if previous == .home{
                            middleAnimationControl = true
                        }
                        else{
                            middleAnimationControl = false
                        }
                        print(middleAnimationControl)
                    }
                    .onReceive(timer, perform: { _ in
                        if isElementTapped[1]{
                            animate(id: 1)
                        }
                    })
                Element(touchedElement: $touchedElement, id: 2, image: "retailer", text: "我的店舖")
                    .onTapGesture {
                        
                        tapped = true
                        isElementTapped[2] = true
                        elementTapped(id: 2)
                        mainFlow = .retailer
                        flowQueue.append(.retailer)
                        if flowQueue.count>2{
                            flowQueue.removeFirst()
                        }
                        previous = flowQueue.first!
                        if previous != mainFlow{
                            if let id = userStatus.id{
                                getList()
                            }
                            
                        }
                        
                        
                    }
                    .onReceive(timer, perform: { _ in
                        if isElementTapped[2]{
                            animate(id: 2)
                        }
                    })
            }
            
            
        }
        .onAppear{
            offset = -(distance+threshold)
        }
        
    }
    private func elementTapped(id : Int) {
        switch id {
        case 0:
            withAnimation{
                offset = -(distance+threshold)
                barWidth = 70
                mainFlow = .home
            }
        case 1:
            withAnimation{
                offset = 0
                barWidth = 70
                mainFlow = .customer
            }
        case 2:
            withAnimation{
                offset = distance+threshold
                barWidth = 95
                mainFlow = .retailer
            }
        default:
            withAnimation{
                offset = -(distance+threshold)
            }
        }
        
    }
    private func animate( id : Int ){
        if tapped{
            
            
            
            tic += 1
            if (tic == 2){
                //test.append("triggered! ")
                withAnimation{
                    touchedElement = id
                }
            }
            if (tic == 3){
                withAnimation{
                    tapped = false
                    isElementTapped [id] = false
                }
                
                tic = 0
            }
        }
        
    }
    private func getList(){
        var list: [Shop] = []
        var apiReturn : Data?
        
        //
        let id = userStatus.id.unsafelyUnwrapped
        
        //DispatchQueue.global(qos: .utility).async{
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
        //}
    }
}


private struct Element: View{
    
    
    
    let height :CGFloat = 40
    let color = Color(hex: 0x979797)
    
    @Binding var touchedElement: Int
    let id :Int
    let image :String
    let text :String
    
    var body: some View{
        HStack(spacing: 3){
            
            if touchedElement == id {
                Group{
                    Image("\(image)_w")
                    Text(text)
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.bold)
                }.drawingGroup()
            }else{
                Image(image)
            }
        }
        
    }
}
