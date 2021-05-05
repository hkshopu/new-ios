//
//  ShopData.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/15.
//

import Foundation
import SwiftUI

struct apiShop: Codable , Identifiable{
    let id: Int
    let shop_title : String
    let shop_icon : String
    let product_count: Int
    let rating: Double
    let follower: Int
    let income: Double
    //add more accordingly
}

struct APIGeneralReturn<T:Codable>: Codable{
    let status :Int
    let ret_val : String
    let data : T
}

final class ShopData: ObservableObject{
    @Published var currentShopID: Int?
    @Published var currentShop: CurrentShop
    @Published var shop: [Shop]
    init() {
        self.shop = []
        self.currentShop = CurrentShop()
    }
}
struct CurrentShop{
    var basic: Shop?
    var detail: ShopDetail?
    var categorys: [ShopCategory]
    var shopIMGs: ShopIMGs
    init(){
        categorys = []
        self.shopIMGs = ShopIMGs(ShopIconURL: "", ShopPicURL: "", ShopDescriptionURL: "")
    }
}
struct Shop: Identifiable{
    let id: Int
    let name: String
    var iconURL : String
    var icon: UIImage?
    let product_count: Int
    let rating: Double
    let follower: Int
    let income: Double
    
    init(id: Int, name:String, iconURL: String, product_count: Int, rating: Double, follower: Int, income:Double){
        self.id = id
        self.name = name
        
        //self.icon = UIImage()
        self.iconURL = iconURL
        self.product_count = product_count
        self.rating = rating
        self.follower = follower
        self.income = income
    }
    
}
struct ShopIMGs{
    var shopIcon: UIImage
    var shopPic: UIImage
    var shopDescriptionIMG: UIImage?
    init(ShopIconURL: String, ShopPicURL: String, ShopDescriptionURL: String? ){
        self.shopIcon = ShopIconURL.loadImgFromURL(defaultIMG: UIImage(named: "PsuedoFoto"))
        self.shopPic = ShopPicURL.loadImgFromURL()
        if let url = ShopDescriptionURL {
            self.shopDescriptionIMG = url.loadImgFromURL(defaultIMG: UIImage(named: "PsuedoFoto"))
        }
    }
}
struct ShopDetail: Identifiable, Codable {
    let id: Int
    let shop_title: String
    let shop_icon: String
    let shop_pic: String
    let shop_description: String
    let shop_address: [ShopAddress]
    let shop_bank_account: [ShopBankAccount]
    let shop_category_id: [Int]
    let product_count: Int
    let rating: Double
    let follower: Int
    let income: Double
//
//
//    init( id: Int,
//          shop_title: String,
//          shop_icon: String,
//          shop_pic: String,
//          shop_description: String,
//          bank_code: String,
//          bank_name: String,
//          bank_account: String,
//          bank_account_name: String,
//          address_name: String,
//          address_country_code: String,
//          address_phone: String,
//          address_is_phone_show: String,
//          address_area: String,
//          address_district: String,
//          address_road: String,
//          address_number: String,
//          address_other: String,
//          address_floor: String,
//          address_room: String,
//          shop_category_id: [Int],
//          product_count: Int,
//          rating: Double,
//          follower: Int,
//          income: Double){
//        self.id = id
//
//        self.shop_title = shop_title
//        self.shop_icon = shop_icon.loadImgFromURL(defaultIMG: UIImage(named: "PsuedoFoto"))
//        self.shop_pic = shop_pic.loadImgFromURL(defaultIMG: UIImage(named: "PsuedoFoto"))
//        self.shop_description = shop_description
//        self.bank_code = bank_code
//        self.bank_name = bank_name
//        self.bank_account = bank_account
//        self.bank_account_name = bank_account_name
//        self.address_name = address_name
//        self.address_country_code = address_country_code
//        self.address_phone = address_phone
//        self.address_is_phone_show = address_is_phone_show
//        self.address_area = address_area
//        self.address_district = address_district
//        self.address_road = address_road
//        self.address_number = address_number
//        self.address_other = address_other
//        self.address_floor = address_floor
//        self.address_room = address_room
//        self.shop_category_id = shop_category_id
//        self.product_count = product_count
//        self.rating = rating
//        self.follower = follower
//        self.income = income
//    }

}
struct ShopBankAccount: Codable{
    let code: String
    let name: String
    let account: String
    let account_name: String
}

struct ShopAddress:  Codable{
    //let id : UUID
    let name: String
    let country_code: String
    let phone: String
    let is_phone_show: String?
    let area: String
    let district: String
    let road: String
    let number: String
    let other: String
    let floor: String
    let room: String
}
