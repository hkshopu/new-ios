//
//  CustomerPageUnlogin.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/19.
//

import SwiftUI

struct CustomerPageUnlogin: View {
    var body: some View {
        VStack{
        Text("登入頁面")
            .font(.largeTitle)
            .padding()
            Text("訪客請先登入以開啟買家功能")
                .foregroundColor(.gray)
            
            Image("介紹_2")
            //login
            Button(action:{
                //IntroView()
            }){
                Image("LogIn_CHT")
            }
        }
        
    }
}

struct CustomerPageUnlogin_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageUnlogin()
    }
}
