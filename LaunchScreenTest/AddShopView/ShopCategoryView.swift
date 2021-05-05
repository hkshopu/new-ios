//
//  ShopCategoryView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/22.
//

import SwiftUI

struct ShopCategoryView: View {
    @EnvironmentObject var ShopSettings: ShopSettings
    @State var CategorySelectindex = 0
    @State var CategorySelect = ""
    let Categorylist = ["護膚保健","護理保健","母嬰育兒","寵物用品","電子電器","傢俱用品","吃喝玩樂","運動旅行","時尚服飾"]
    var body: some View {
        VStack{

            Picker(selection:$CategorySelectindex, label: Text("Category"), content: {
                ForEach(0 ..< Categorylist.count){ index in
                    Text(self.Categorylist[index]).tag(index)
                    
                }
                
            })
            .padding()
            Text("目前選擇的是 \(Categorylist[CategorySelectindex])")
            
        }.onAppear(){
            CategorySelect = Categorylist[CategorySelectindex]
            ShopSettings.ShopCategorySelect = Categorylist[CategorySelectindex]
            print("CategoryList = .\(Categorylist[CategorySelectindex])")
        }
        //ShopSettings.$ShopCategorySelect = Categorylist[CategorySelect]
    }
    
    
}

struct ShopCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ShopCategoryView()
    }
}

