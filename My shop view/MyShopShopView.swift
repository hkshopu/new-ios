//
//  MyShopShopView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/21.
//

import SwiftUI


struct ShopRow: View {

    @EnvironmentObject var environment : MyShopEnvironment

    
    var body: some View {
        
        ScrollView{
            
            LazyVStack{
                ForEach(environment.shops.indices, id:\.self) { index in
                    
                    
                    if !environment.shops.isEmpty {
                        if environment.shopExist[index] {
                            
                        shopElement(index: index)
                            .drawingGroup()
                            .transition(.asymmetric(insertion:.identity , removal: AnyTransition.opacity.combined(with: .slide)))
                            .onTapGesture{
                                // Go to individual shop
                                // TODO: ask database and decode json data here
                                //
                            }
                            
                        }
                        
                    }
                    
                }
                HStack{
                    Button(action:{}){
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:40)
                            .foregroundColor(.gray)
                        
                        
                    }.padding()
                    Text("Add Shop")
                        .padding()
                    Spacer()
                }.padding()
            }.padding()
            
            
        }.onAppear{
            readShops()
        }
    }
    
    
    private func readShops(){
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            print("unavailable url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if (error != nil) {
                print("client error")
                return
            }
            
            let shops = try! JSONDecoder().decode([Shop].self, from: data!)
            
            DispatchQueue.main.async{
                environment.shops = shops
                smallerShop()
                environment.shopExist = Array(repeating: true, count: shops.count)
                for i in 0...environment.shops.count {
                    environment.image.append(shops[i].url.loadImgFromURL())
                }
            }
        }.resume()
    }
    
    private func smallerShop(){
        
        var smallerShop : [Shop] = []
        if !environment.shops.isEmpty{
            for i in 0...19 {
                smallerShop.append(environment.shops[i])
            }
        }
        environment.shops = smallerShop
    }
}

struct shopElement:View{
    
    @State var delete = false
    @State var dragOffset : CGFloat = 0
    @EnvironmentObject var environment : MyShopEnvironment
    var index :Int

    
    
    
    var body: some View{
        
        let myGesture = DragGesture()
            .onChanged { value in
                let distance = value.translation.width
                if distance < 0 {
                    
                        self.dragOffset += distance/100

                }
                
            }
            .onEnded{ value in
                
                DispatchQueue.main.async {
                    withAnimation{
                        if (value.translation.width < -200){

                            self.dragOffset = -30
                            delete = true
                        }
                        else{

                            self.dragOffset = 0

                            delete = false
                        }
                    }
                }
                
            }
        
        
        HStack{
            HStack{
                Image(uiImage: environment.image[index])
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Text(environment.shops[index].title)
                    .frame(width: 0.6*UIScreen.screenWidth)
                Spacer()
            }.offset(x: dragOffset)
            .drawingGroup()
            
            if delete{
                
                //show delete button
            
                Button(action: {
                    //Delete button triggered ...
                    environment.deletedShopIndex = index
                    // show pop up notice view

                    DispatchQueue.main.async {
                        withAnimation{
                            delete = false
                            dragOffset = 0
                            environment.popUp = true
                        }
                    }
                        

  
                }){
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(delete ? 0 : 90))
                        .animation(.easeInOut)
                }
                
            }
        }
        
        .gesture(myGesture)
    }
}
