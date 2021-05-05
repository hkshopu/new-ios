//
//  MyAddressView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct MyAddressView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var internetTask:InternetTask
    @State var apiReturn :APIloginReturn?
    @State var test = ""
    @State var addresslist = [String](repeating:"", count: 7)
    let elementsHeight :CGFloat = 60
    let elementColor :Color = Color(hex: 0xE5E5EA, alpha: 1.0)
    var body: some View {
        VStack(alignment: .leading){
            
        }
        .padding(.leading, 10.0)
        .background(Color(.white))
        .frame(width:UIScreen.screenWidth-50)
        .cornerRadius(20)
    }
}

struct MyAddressView_Previews: PreviewProvider {
    static var previews: some View {
        MyAddressView()
    }
}
