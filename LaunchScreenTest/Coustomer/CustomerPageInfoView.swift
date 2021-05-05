//
//  CustomerPageInfoView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct CustomerPageInfoView: View {
    
    @State var status  = 1
    
    @State private var customerInfo = CustomerInfo(productAmount: 0, follow: 0, income: 0)
    
    var body: some View {
        
        ZStack{
            if status == 0{
                //
                let s = [String(customerInfo.productAmount), String(customerInfo.follow), String(customerInfo.incomes)]
                Element(number: s)
            }
            else{
                let s = ["-", "-", "-"]
                Element(number: s)
            }
            
        }.onAppear(){
            //let apiReturn = makeAPICall(url: "https://hkshopu-20700.df.r.appspot.com/user/[id]/shop/", method: "GET", parameters: "")
            //status = apiReturn.status
            
            // initialize retailerinfo
            if status == 0 {
                customerInfo = CustomerInfo(productAmount: 0, follow: 0, income: 0)
            }
        }
    }
}

private struct Element:View{
    
    let number : [String]
    
    var body: some View{
        let width = 0.9*UIScreen.screenWidth
        let height = 0.12*UIScreen.screenHeight
        let s = ["收藏清單", "關注店舖", "足跡"]
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(width:width, height: height)
            HStack(spacing: 0.2*UIScreen.screenWidth){
                if number.count >= 3{
                    ForEach(0 ..< 3) { item in
                        VStack(spacing : 4 ){
                            Text(number[item])
                            Text(s[item])
                            
                        }
                    }
                }
            }
            
        }
    }
}
private struct CustomerInfo{
    let productAmount :Int
    let follow :Int
    let incomes : Int
    
    init (productAmount: Int, follow: Int, income: Int){
        self.productAmount = productAmount
        self.follow = follow
        self.incomes = income
    }
}
struct CustomerPageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageInfoView()
    }
}
