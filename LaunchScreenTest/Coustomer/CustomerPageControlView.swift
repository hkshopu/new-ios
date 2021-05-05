//
//  CustomerPageControlView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct CustomerPageControlView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var internetTask:InternetTask
    
    @State var userID = ""
    @State var first_name = ""
    @State var last_name = ""
    var body: some View {
        //https://hkshopu-20700.df.r.appspot.com/user/id/show/
        //print(apiReturn)
        VStack{
            CostomerPageTopView()
            CustomerPageProfileView()
            CustomerPageInfoView()
            CustomerPageMainView()
            Spacer()
        }
        .background(Color(hex: 0xF6FBFA, alpha: 1.0))
    }
}

struct CustomerPageControlView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageControlView()
    }
}
