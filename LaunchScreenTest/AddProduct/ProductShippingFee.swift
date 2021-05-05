//
//  ProductShippingFee.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/26.
//

import Foundation

struct ShippingFee: Identifiable ,Encodable{
    
    
    let id: Int
    var title: String
    var price: String
    var isToggled: Bool
    
    init(id: Int, title: String, price: String, isToggled: Bool){
        self.id = id
        self.title = title
        self.price = price
        self.isToggled = false
    }
}
struct ProductSize {
    var ProductWeight : Int
    var ProductLong: Int
    var ProductWidth: Int
    var ProductHeight: Int
    
    internal init(ProductWeight: Int, ProductLong: Int, ProductWidth: Int, ProductHeight: Int) {
        self.ProductWeight = 0
        self.ProductLong = 0
        self.ProductWidth = 0
        self.ProductHeight = 0
    }
}
struct ProductSpecQP: Identifiable {
    let id: Int
    var spec_name : String
    var price : String
    var quantity : String
    var size : String
    init(id: Int,spec_name: String ,price: String,quantity: String,size: String) {
        self.id = id
        self.spec_name = spec_name
        self.price = price
        self.quantity = quantity
        self.size = size
    }
}
//"product_spec_list": [
//    {
//        "product_id": 1,
//        "spec_name": "玫瑰花",
//        "price": 500,
//        "quantity": 10,
//        "size": "高100"
//    },
