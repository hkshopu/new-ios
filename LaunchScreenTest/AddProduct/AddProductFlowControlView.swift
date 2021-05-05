//
//  AddProductFlowControlView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/22.
//

import SwiftUI

enum AddProductFlow{
    case def
    case spec
    case category
    case shippingFee
}
struct AddProductFlowControlView: View {
//    @State var productCategory: ProductCategory
//    @State var isShowProduceCategory: Bool
    let cat = ConvertedMainCategory(id: 1, selected_img: UIImage(), unselected_img: UIImage(), title: "", seq: 1, hex: "000000")
    let sub = ConvertedSubCategory(id: 1, selected_img: UIImage(), title: "", seq: 1)
    @State var flow = AddProductFlow.def
    @State var isSpecShow = false
    @State var isCategoryShow = false
    @State var isShippingfeeShow = false
    //@State var shippingFee: ShippingFee
    @State var shippingFees: [ShippingFee] = [ShippingFee(id: 0, title: "郵政", price: "HKD$100", isToggled: false), ShippingFee(id: 1, title: "順豐速運", price: "HKD$100",isToggled: false),ShippingFee(id: 2, title: "", price: "",isToggled: false)]
    @State var isShippingFeeEdited = false
    @State var productSize: ProductSize = ProductSize(ProductWeight: 0, ProductLong: 0, ProductWidth: 0, ProductHeight: 0)
    @State var productCategory: ProductCategory = ProductCategory(category: ConvertedMainCategory(id: 1, selected_img: UIImage(), unselected_img: UIImage(), title: "", seq: 1, hex: "000000"), sub_category: ConvertedSubCategory(id: 1, selected_img: UIImage(), title: "", seq: 1))
    @State var QuantityAndPrice: [AddProductSpec] = [AddProductSpec(id: 0, spec_desc_1: "", spec_desc_2: "", spec_dec_1_items: "", spec_dec_2_items: "", price: 0, quantity: 0)]
    @Binding var isShowAddprodut:Bool
    @State var productSpecString1s: [ProductSpecString] = []
    @State var productSpecString2s: [ProductSpecString] = []
    @State var priceTemp = [[String]]()
    @State var quntityTemp = [[String]]()
    @State var ProductSpec1 = ""
    @State var ProductSpec2 = ""
    
    var body: some View {
        ZStack{
            AddProductView(isShowAddprodut: $isShowAddprodut, isSpecShow: $isSpecShow, isCategoryShow: $isCategoryShow, isShippingFeeEdited: $isShippingFeeEdited, isShippingFeeShow: $isShippingfeeShow, productSize: $productSize, shippingFee: $shippingFees, productCategory: $productCategory,QulityAndPrice: $QuantityAndPrice)
            
            if isSpecShow {
                ProductSpecFlowControlView(isSpecShow: $isSpecShow, QulityAndPrice: $QuantityAndPrice,isQPShow: false,ProductSpec1:$ProductSpec1,ProductSpec2:$ProductSpec2,productSpecString1s:$productSpecString1s,productSpecString2s:$productSpecString2s,priceTemp: $priceTemp,quntityTemp: $quntityTemp)
            }
            if isCategoryShow{
                ProductCategorySelectView(productCategory: $productCategory, isShowProduceCategory: $isCategoryShow)
                    .environmentObject(InternetTask())
            }
            if isShippingfeeShow{
                AddProductShipping(productSize: $productSize, isShippingfeeShow: $isShippingfeeShow, shippingFees: $shippingFees, isShippingfeeEdit: $isShippingFeeEdited)
            }
            
            
        }
        //.ignoresSafeArea(.all)
        
    }
}

//struct AddProductFlowControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddProductFlowControlView()
//        //AddProductFlowControlView(productCategory: $productCategory, isShowProduceCategory: $isShowProduceCategory)
//    }
//}
