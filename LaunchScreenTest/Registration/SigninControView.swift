//
//  SigninControView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/10.
//

import SwiftUI


struct SignInControlView: View {
    @EnvironmentObject var UserData: UserData
    
    @Binding var dismiss : Bool
    
    @State var step = 0
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .ignoresSafeArea(edges: .all)
            switch (step){
//            case 0:
//                SignInView
            case 5:
                SignInPassWord(step: self.$step, dismiss: self.$dismiss)
            case 6:
                EmailValidationView(isForgetPassword: true, step: $step, dismiss: self.$dismiss)
            case 7:
                NewPassWord(step: self.$step, dismiss: self.$dismiss)
            default:
                SignInView(step: self.$step, dismiss: self.$dismiss)
                
            }
        }
    }
}
