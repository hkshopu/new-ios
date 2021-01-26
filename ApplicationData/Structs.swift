//
//  Structs.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/19.
//

import Foundation
import UIKit
import SwiftUI


struct Shop : Hashable, Codable, Identifiable{
    var id : Int
    var title: String
    var url: String
    //let shopName: String
    //let shopImg: String
}

struct ShopInfo : Hashable, Codable, Identifiable{
    var id : Int
    var title: String // Shop description
    var url: String // Shop Image
    var paymentMethod: [Bool] // Payment Methods
}



class ShopData {
    
    var shopImg : UIImage
    var description: String
    var paymentMethods: [Bool]
    
    init(shopInfo : ShopInfo){
        
        if( shopInfo.url != ""){
            self.shopImg = shopInfo.url.loadImgFromURL()
        }
        else{
            let emptyImg = UIImage()
            self.shopImg = emptyImg
        }
        
        self.description = shopInfo.title
        
        self.paymentMethods = shopInfo.paymentMethod
        
    }
}
class UserData:ObservableObject{
    
    let userImage: String
    let userName: String
    let joinDate: String
    
    init(image:String, name:String, timestamp: String){
        self.userImage = image
        self.userName = name
        self.joinDate = timestamp
    }
}
