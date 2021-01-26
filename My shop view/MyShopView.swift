//
//  MyShopView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/15.
//

import SwiftUI

extension String{
    func loadImgFromURL() -> UIImage{
        do{
            guard let url = URL(string: self) else {
                print("unavailable url")
                return UIImage(systemName: "wifi.exclamationmark")!
            }
            let data :Data = try Data(contentsOf: url)
            return (UIImage(data: data) ?? UIImage(systemName: "questionmark.circle.fill")!)
        }catch{
            return UIImage(systemName: "xmark.octagon.fill")!
        }
    }
}


class MyShopEnvironment : ObservableObject{
    
    @Published var popUp : Bool = false
    @Published var shopExist : [Bool] = []
    @Published var deletedShopIndex: Int = -1
    @Published var shops : [Shop] = []
    @Published var image : [UIImage] = []
}

struct MyShopView: View {
    
    @EnvironmentObject var environment : MyShopEnvironment
    
    let user = UserData(
        image:"person.fill.questionmark",
        name: "Test User",
        timestamp:"2021/01/15")
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            ZStack {
                VStack{
                    UserRow(user : self.user)
                    ShopRow()
                    
                }.disabled(environment.popUp)
                .grayscale(environment.popUp ? 0.9 : 0)
                .animation(.default)
                if(environment.popUp){
                    NoticeView().transition(AnyTransition.scale.combined(with: .opacity))
                }
            }
        }
    }
    
}






struct NoticeView: View {
    
    @EnvironmentObject var environment : MyShopEnvironment

    
    var body: some View {
        
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 250, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack {
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30)
                    Text("Do you sure you want to remove this shop?")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(width: 200.0)
                }.padding(.horizontal)
                HStack {
                    Button(action:{
                        
                        
                        DispatchQueue.main.async{
                            withAnimation{
                                environment.popUp = false
                                //print(environment.deletedShopIndex)
                            }
                        }
                            
                       
                    }){
                        Image(systemName: "xmark.rectangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action:{
                        
                        DispatchQueue.main.async{
                            withAnimation{
                                environment.popUp = false
                                /*
                                 TODO:
                                 Send Database the deleted shop
                                 */

                                environment.shopExist[environment.deletedShopIndex] = false
                            }
                        }
                            
                        
                        
                    }){
                        Image(systemName: "checkmark.rectangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.green)
                        
                    }
                    
                }.padding(.horizontal, 50.0)
            }
        }.frame(width: 250)
        
        
    }
}
struct MyShopView_Previews: PreviewProvider {
    static var previews: some View {
        MyShopView().environmentObject(MyShopEnvironment())
    }
}


