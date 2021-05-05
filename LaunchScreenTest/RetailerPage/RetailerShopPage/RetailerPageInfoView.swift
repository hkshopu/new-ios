//
//  RetailerPageInfoView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import SwiftUI

struct RetailerPageInfoView: View {
    @EnvironmentObject var shopData: ShopData
    @State var status  = 1
    
    var body: some View {
        
        ZStack{
            
            //
            if let detail = shopData.currentShop.detail{
                
                let s = [String(detail.product_count), String(detail.follower), String(detail.income)]
                Element(number: s)
                    .onAppear{
                        print ("detail got")
                    }
            }else{
                let s = ["-", "-", "-"]
                Element(number: s)
            }
            
            
        }
    }
}
private struct Element:View{
    
    let number : [String]
    
    var body: some View{
        let width = 0.9*UIScreen.screenWidth
        let height = 0.12*UIScreen.screenHeight
        let s = ["我的商品", "關注", "進帳/月"]
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(width:width, height: height)
            HStack(spacing: 0.2*UIScreen.screenWidth){
                if number.count >= 3{
                    ForEach(0 ..< 3) { item in
                        VStack(spacing : 4 ){
                            if number[item] != "0"{
                                Text(number[item])
                            }
                            else{
                                Text("-")
                            }
                            Text(s[item])
                                .font(.custom("SFNS", size: 14))
                            
                        }
                    }
                }
            }
            
        }
    }
}

struct RetailerPageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageInfoView()
    }
}
