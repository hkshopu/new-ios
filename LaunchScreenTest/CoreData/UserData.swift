//
//  UserData.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/25.
//

import Foundation

import Combine
class UserData: ObservableObject{
    
    @Published var isLoggedIn :Bool
    
    @Published var parameter : String
    
    @Published var basicData: BasicData?
    @Published var advancedData: AdvancedData?
    @Published var addressData : AddressData?
    
    @Published var haveBasicData :Bool 
    @Published var haveDetailData :Bool
    @Published var haveAddressData :Bool
    
    //@Published var email: KeyPath<User, String> = \User.email
    
    init(){
        
        isLoggedIn = false
        parameter = ""
        haveBasicData = false
        haveDetailData = false
        haveAddressData = false
    }
    
    //    func BasicSignUp (email: String, password: String){
    //
    //        self.User?.email = email
    //        self.User?.password = password
    //
    //        self.haveBasicData = true
    //    }
    //
    //    func DetailSignUp (first_name: String, last_name: String, phone: String, gender: String, birthday: String, address: String){
    //
    //        self.User?.first_name = first_name
    //        self.User?.last_name = last_name
    //        self.User?.phone = phone
    //        self.User?.gender = gender
    //        self.User?.birthday = birthday
    //        self.User?.address = address
    //
    //
    //        self.haveDetailData = true
    //    }
    //
    //    func SendLoginInformaton(){
    //
    ////        var semaphore = DispatchSemaphore (value: 0)
    ////
    ////        let encoder: JSONEncoder = JSONEncoder()
    ////        let encoded = try? encoder.encode(device)
    ////
    ////        //let postData =  parameters.data(using: .utf8)
    ////
    ////        var request = URLRequest(url: URL(string: "https://hkshopu-20700.df.r.appspot.com/user/registerProcess/")!,timeoutInterval: Double.infinity)
    ////        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    ////
    ////        request.httpMethod = "POST"
    ////        request.httpBody = encoded
    ////
    ////        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    ////          guard let data = data else {
    ////            print(String(describing: error))
    ////            semaphore.signal()
    ////            return
    ////          }
    ////          print(String(data: data, encoding: .utf8)!)
    ////          semaphore.signal()
    ////        }
    ////
    ////        task.resume()
    ////        semaphore.wait()
    //
    //    }
}
//
//struct User : Codable{
//
//    var account_name : String?
//    var email : String?
//    var password : String?
//    var first_name : String?
//    var last_name : String?
//    var phone : String?
//    var gender : String?
//    var birthday : String?
//    var address : String?
//
//    init(account_name: String){
//        self.account_name = account_name
//    }
//}
struct BasicData{
    var email: String
    var password: String
    var confirm_password: String
    
    init(email: String, password: String, confirm_password:String){
        self.email = email
        self.password = password
        self.confirm_password = confirm_password
    }
}
struct AdvancedData {
    var first_name: String
    var last_name: String
    var phone: String
    var gender: String
    var birthday: String
    
    init(first_name:String, last_name: String, phone: String, gender:String, birthday: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.phone = phone
        self.gender = gender
        self.birthday = birthday
    }
}

struct AddressData{
    
    var region :String
    var district :String
    var street_name :String
    var street_no :String
    var address :String
    var floor :String
    var room :String
    
    init (region :String, district :String, street_name :String, street_no :String, address :String, floor :String, room :String){
        self.region = region
        self.district = district
        self.street_name = street_name
        self.street_no = street_no
        self.address = address
        self.floor = floor
        self.room = room
    }
}

class User: ObservableObject{
    
    @Published var isLoggedIn: Bool
    @Published var id :Int?
    @Published var password: String?
    @Published var profile :ProfileData?
    @Published var ShopList :ShopList?
    
    init() {
        self.isLoggedIn = false
    }
}
struct ProfileData:Codable {
    let id :Int
    let account_name :String
    let google_account :String
    let facebook_account :String
    let apple_account :String
    let email :String
    let password :String
    let first_name :String
    let last_name :String
    let phone :String
    let gender :String
    let birthday :String
    let address :String
    let region :String
    let district :String
    let street_name :String
    let street_no :String
    let floor :String
    let room :String
    //let forget_password_token :String
    //let activated :String
    //let created_at :String
    //let updated_at:String
}
struct ShopList: Codable {
    
}
