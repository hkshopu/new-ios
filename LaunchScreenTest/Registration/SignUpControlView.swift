//
//  SignUpControlView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/2/26.
//
import SwiftUI

struct SignUpControlView: View {
    
    @EnvironmentObject var UserData: UserData
    
    @Binding var dismiss : Bool
    
    @State var step = 0
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .ignoresSafeArea(edges: .all)
            switch (step){
            case 1:
                UserDataView(step: self.$step, dismiss: self.$dismiss)
                    .animation(.default)
                    .transition(.move(edge: .trailing))
            case 2:
                SignAddressView(step: self.$step, dismiss: self.$dismiss)
                
            case 3:
                EmailValidationView(isForgetPassword: false, step: $step, dismiss: self.$dismiss)
            default:
                SignUpView(step: self.$step, dismiss: self.$dismiss)
            }
        }
        
    }
}

//struct SignUpControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpControlView()
//    }
//}
