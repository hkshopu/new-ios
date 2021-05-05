//
//  Extensions.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/25.
//

import Foundation
import SwiftUI
import UIKit

//Fetching Screen Size
extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

//Using HEX in UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
//Using HEX in Color
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// For Img Loading
extension String{
    func loadImgFromURL(defaultIMG: UIImage?) -> UIImage{
        
        do{
            guard let url = URL(string: self) else {
                print("unavailable url")
                if let img = defaultIMG{
                    return img
                }else{
                    return UIImage(systemName: "wifi.exclamationmark")!
                }
            }
            let data :Data = try Data(contentsOf: url)
            return (UIImage(data: data) ?? UIImage(systemName: "questionmark.circle.fill")!)
        }catch{
            return UIImage(systemName: "xmark.octagon.fill")!
        }
    }
}
extension String{
    func loadImgFromURL() -> UIImage{
        do{
            guard let url = URL(string: self) else {
                print("unavailable url")
                
                return UIImage()
                
            }
            let data :Data = try Data(contentsOf: url)
            return (UIImage(data: data) ?? UIImage(systemName: "questionmark.circle.fill")!)
        }catch{
            return UIImage(systemName: "xmark.octagon.fill")!
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct APIReturn: Codable{
    let status: Int
    let ret_val: String
    //let user_id: Int
}

struct APIShopReturn: Codable{
    let status: Int
    let ret_val: String
    let shop_id: Int
}
func makeAPICall(internetTask: InternetTask, url: String, method: String, parameters: String) -> APIReturn{
    
    
    let decoder = JSONDecoder()
    var semaphore = DispatchSemaphore (value: 0)
    var apiReturn : APIReturn?
    
    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
    let postData =  parameters.data(using: .utf8)
    
    
    
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpMethod = method
    request.httpBody = postData
    
    let task = internetTask.session.dataTask(with: request) { data, response, error in
        
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        do{
            apiReturn = try decoder.decode(APIReturn.self, from: data)
        }catch{
            print("Error in Data Decoding!!")
        }
        
        internetTask.isInternetProcessing = false
        print("finish processing...")
        print("status = \(apiReturn?.status), ret_val = \(apiReturn?.ret_val)")
        do{
            print(String(decoding:data, as:UTF8.self))
            apiReturn = try decoder.decode(APIReturn.self, from: data)
        }catch{
            print("Error in Data Decoding!!")
        }
        //sleep(2)
        
        semaphore.signal()
    }
    
    internetTask.isInternetProcessing = true
    print("start processing...")
    
    task.resume()
    semaphore.wait()
    
    
    
    
    
    return apiReturn!
}

func makeMultiformParamBody( boundaries:String, key: String, value: String) -> Data{
    var data = Data()
    
    data.append(Data("--\(boundaries)\r\n".utf8))
    data.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
    data.append(Data("\(value)\r\n".utf8))
    
    
    
    return data
}

func makeMultiformPNGBody( boundaries: String, key: String, image: UIImage) -> Data{
    var data = Data()
    let imageData = image.pngData()
    
    data.append(Data("--\(boundaries)\r\n".utf8))
    data.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random()).png\"\r\n".utf8))
    data.append(Data("Content-Type: image/png\r\n\r\n".utf8))
    data.append(imageData!)
    data.append(Data("\r\n".utf8))
    
    
    
    return data
}

func makeMultipartAPICall(internetTask: InternetTask, url: String, boundary: String, body: Data) -> APIShopReturn{
    
    
    let decoder = JSONDecoder()
    var semaphore = DispatchSemaphore (value: 0)
    var apiReturn : APIShopReturn?
    
    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
    
    
    
    
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    
    request.httpMethod = "POST"
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
    //request.httpBody = body
    
    dump(request)
    let task = internetTask.session.uploadTask(with: request, from: body){ data, response, error in
        
        if error != nil{
            print("ERROR")
            print(error)
            print("response as following")
            print(response)
        }
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        do{
            print(String(decoding:data, as:UTF8.self))
            apiReturn = try decoder.decode(APIShopReturn.self, from: data)
        }catch{
            print("Error in Data Decoding!!")
        }
        
        internetTask.isInternetProcessing = false
        print("finish processing...")
        print("status = \(apiReturn?.status), ret_val = \(apiReturn?.ret_val)")
        //sleep(2)
        
        semaphore.signal()
    }
    
    internetTask.isInternetProcessing = true
    print("start processing...")
    
    task.resume()
    semaphore.wait()
    
    
    
    
    
    return apiReturn!
}

extension Color {
    
    static let bgColor = Color(hex: 0xF6FBFA)
    static let mainTone = Color(hex: 0x1DBCCF)
}


final class InternetTask: ObservableObject{
    
    var isInternetProcessing: Bool
    let domain:String
    let session: URLSession
    
    init(){
        isInternetProcessing = false
        session = URLSession(configuration: .default)
        domain = "https://hkshopu.df.r.appspot.com/"
    }
}

func ArrayParameterPacking(paramName: String, List: [String]) -> String{
    
    var string = ""
    
    for s in List{
        string.append(paramName)
        string.append("=")
        string.append(s)
        if s != List.last {
            string.append("&")
        }
    }
    
    
    return string
}

func makeAPIGeneralCall(internetTask: InternetTask, url: String, method: String, parameters: String) -> Data{
    
    
    let decoder = JSONDecoder()
    var semaphore = DispatchSemaphore (value: 0)
    var returnData : Data?
    
    
    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
    let postData =  parameters.data(using: .utf8)
    
    
    
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpMethod = method
    request.httpBody = postData
    
    let task = internetTask.session.dataTask(with: request) { data, response, error in
        
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        //sleep(2)
        
        returnData = data
        semaphore.signal()
    }
    
    internetTask.isInternetProcessing = true
    print("start processing...")
    
    task.resume()
    semaphore.wait()
    
    
    
    
    
    return returnData!
}

struct APIloginReturn: Codable{
    let status: Int
    let ret_val: String
    let user_id: Int
}

//func makeAPICall(internetTask: InternetTask, url: String, method: String, parameters: String) -> APIReturn{
//
//
//    let decoder = JSONDecoder()
//    var semaphore = DispatchSemaphore (value: 0)
//    var apiReturn : APIReturn?
//
//    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
//    let postData =  parameters.data(using: .utf8)
//
//
//
//    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
//    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//    request.httpMethod = method
//    request.httpBody = postData
//
//    let task = internetTask.session.dataTask(with: request) { data, response, error in
//
//      guard let data = data else {
//        print(String(describing: error))
//        semaphore.signal()
//        return
//      }
//        do{
//            apiReturn = try decoder.decode(APIReturn.self, from: data)
//        }catch{
//            print("Error in Data Decoding!!")
//        }
//
//        internetTask.isInternetProcessing = false
//        print("finish processing...")
//        print("status = \(apiReturn?.status), ret_val = \(apiReturn?.ret_val)")
//        //sleep(2)
//
//      semaphore.signal()
//    }
//
//    internetTask.isInternetProcessing = true
//    print("start processing...")
//
//    task.resume()
//    semaphore.wait()
//
//
//
//
//
//    return apiReturn!
//}
func emailcheck(email: String) -> String {
    
    if (email != nil && email.contains("Optional")){
        let Getemail = String(email)
        //let startGetemail = advance(string.startIndex, Getemail.startIndex)
        let start = Getemail.index(Getemail.startIndex, offsetBy: 10)
        let end = Getemail.index(Getemail.endIndex, offsetBy: -3)
        let range = start..<end
        Getemail[range]
            //10,Getemail.count
        //print(email,Getemail)
        return Getemail
    }else{
        return email
    }
    
}
func optioanlInt(int: Int) -> Int {
    let email = String(int)
    print("optioanlInt Start ",email)
    if (email != nil && email.contains("Optional")){
        let Getemail = String(email)
        //let startGetemail = advance(string.startIndex, Getemail.startIndex)
        let start = Getemail.index(Getemail.startIndex, offsetBy: 10)
        let end = Getemail.index(Getemail.endIndex, offsetBy: -3)
        let range = start..<end
        Getemail[range]
            //10,Getemail.count
        //print(email,Getemail)
        return Int(Getemail)!
    }else{
        return int
    }
    
}
func makeloginAPICall(internetTask: InternetTask, url: String, method: String, parameters: String) -> APIloginReturn{
    //@EnvironmentObject private var user = User()
    //var user: User?
    let decoder = JSONDecoder()
    var semaphore = DispatchSemaphore (value: 0)
    var apiloginReturn : APIloginReturn?
    //var apiReturn : APIloginReturn?
    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
    let postData =  parameters.data(using: .utf8)
    
    
    
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    request.httpMethod = method
    request.httpBody = postData

    let task = internetTask.session.dataTask(with: request) { data, response, error in
        
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
        do{
            apiloginReturn = try decoder.decode(APIloginReturn.self, from: data)
        }catch{
            print("Error in Data Decoding!!")
        }
        
        internetTask.isInternetProcessing = false
        print("finish processing...")
        print("status = \(apiloginReturn?.status), ret_val = \(apiloginReturn?.ret_val), user_id = \(apiloginReturn?.user_id)")
        //sleep(2)
      semaphore.signal()
    }
//    user?.isLoggedIn = true
//    user?.id = apiloginReturn?.user_id
//    print("isLoggedIN = \(user?.isLoggedIn) user.id = \(user?.id)")
    internetTask.isInternetProcessing = true
    print("start processing...")
    
    task.resume()
    semaphore.wait()
    
    
    
    
    
    return apiloginReturn ?? APIloginReturn(status: 0, ret_val: "", user_id: 0)
}

func makeNosessionAPICall(url: String, method: String, parameters: String) -> APIloginReturn{

    let decoder = JSONDecoder()
    var semaphore = DispatchSemaphore (value: 0)
    var apiloginReturn : APIloginReturn?
    print("URL= ",url," method= ",method," parameters= ",parameters)
    //let parameters = "account_name=adkoggg&email=brightlin%40gmial.com"
    let postData =  parameters.data(using: .utf8)

    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = method
    request.httpBody = postData
    print("status = \(String(describing: apiloginReturn?.status)), ret_val = \(String(describing: apiloginReturn?.ret_val))")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
        do{
            apiloginReturn = try decoder.decode(APIloginReturn.self, from: data)
        }catch{
            print("Error in Data Decoding!!")
        }
        print("finish processing...")
        print("status = \(apiloginReturn?.status), ret_val = \(apiloginReturn?.ret_val), user_id = \(apiloginReturn?.user_id)")
        //print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    
    return apiloginReturn!
}
