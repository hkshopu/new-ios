//
//  ProductSpecFlowControlView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/4/9.
//

import SwiftUI

struct ProductSpecFlowControlView: View {
//    @State var productCategory: ProductCategory
//    @State var isShowProduceCategory: Bool
    
    @Binding var isSpecShow :Bool
    @Binding var QulityAndPrice:[AddProductSpec]
    @State var isQPShow = false
    @Binding var ProductSpec1 :String
    @Binding var ProductSpec2 :String
    @Binding var productSpecString1s: [ProductSpecString]
    @Binding var productSpecString2s: [ProductSpecString]
//    @State var QulityAndPrice: [AddProductSpec] = [AddProductSpec(id: 0, spec_desc_1: "", spec_desc_2: "", spec_dec_1_items: "", spec_dec_2_items: "", price: 0, quantity: 0)]
    //@Binding var QulityAndPrice:AddProductSpec
    @Binding var priceTemp : [[String]]
    @Binding var quntityTemp : [[String]]
    var body: some View {
       
        ZStack{
            if isSpecShow{
                AdddProductSpecView(QPdismiss: $isQPShow, Specdismiss: $isSpecShow, ProductSpec1: $ProductSpec1, ProductSpec2: $ProductSpec2, productSpecString1: $productSpecString1s, productSpecString2: $productSpecString2s,priceTemp: $priceTemp,quntityTemp: $quntityTemp)
            }
            if isQPShow{
//                ForEach (productSpecString1) { SpecString1 in
//                    priceTemp.append([])
//                    ForEach (productSpecString2) { SpecString1 in
//                        print("clom number = \(productSpecString2.count)")
//                        priceTemp[SpecString1.id].append("")
//                            print("我是測試")
//                            print(priceTemp)
//                            print("我是測試")
//                    }
//                }
                
                
                AddProductQ_PView(QPdismiss: $isQPShow, Specdismiss: $isSpecShow, ProductSpec1: $ProductSpec1, ProductSpec2: $ProductSpec2, productSpecString1: $productSpecString1s, productSpecString2: $productSpecString2s,QulityAndPrice:$QulityAndPrice,priceTemp: $priceTemp,quntityTemp: $quntityTemp)
            }
        }
        
    }
}

//struct ProductSpecFlowControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductSpecFlowControlView(isSpecShow: .constant(true),QulityAndPrice:.constant([AddProductSpec(id: 0, spec_desc_1: "", spec_desc_2: "", spec_dec_1_items: "", spec_dec_2_items: "", price: 0, quantity: 0)]))
//        //AddProductFlowControlView(productCategory: $productCategory, isShowProduceCategory: $isShowProduceCategory)
//    }
//}
