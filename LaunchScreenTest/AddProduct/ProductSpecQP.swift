//
//  SwiftUIView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/4/9.
//

import Foundation

struct ProductSpecString :Identifiable{
    let id:Int
    var text: String
    init(id: Int){
        self.id = id
        self.text = ""
    }
}
struct AddProductSpec :Identifiable,Encodable{
    let id:Int
    var spec_desc_1: String
    var spec_desc_2: String
    var spec_dec_1_items: String
    var spec_dec_2_items: String
    var price: Int
    var quantity: Int
    init(id:Int ,spec_desc_1:String ,spec_desc_2:String ,spec_dec_1_items:String ,spec_dec_2_items:String ,price:Int ,quantity:Int) {
        self.id = id
        self.spec_desc_1 = spec_desc_1
        self.spec_desc_2 = spec_desc_2
        self.spec_dec_1_items = spec_dec_1_items
        self.spec_dec_2_items = spec_dec_2_items
        self.price = price
        self.quantity = quantity
    }
//    "spec_desc_1": "規格",
//    "spec_desc_2": "尺寸",
//    "spec_dec_1_items": "菊花",
//    "spec_dec_2_items": "高100",
//    "price": 150,
//    "quantity": 20

}
