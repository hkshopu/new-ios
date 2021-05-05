//
//  RetailerPagerProfileView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/11.
//

import SwiftUI
import UIKit

private enum Page{
    case description
    case imgPicker
    case def
}
struct RetailerPageProfileView: View {
    
    @EnvironmentObject var shopData: ShopData
    
    
    //@State var haveImage = false
    @Binding var willShowFullScreenCover :Bool
    @Binding var fcControl: FullScreenCoverControl
    
//    @State var isShowImgPicker = false
//    @State var isShowDetailView = false
    
    
    
    //TBD in future
    //@State var isShowImageEditingView = false
    //@State var renderedImage = UIImage()
    //@State var saveTriggered = false
    
    
    var body: some View {
        ZStack{
            VStack (spacing: 8){
                Group{
                    if let detail = shopData.currentShop.shopIMGs {
                        
                        Image(uiImage: detail.shopIcon)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())

                    }
                    else{
                        Image("PsuedoFoto")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                .onTapGesture {
                    let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                    serialQueue.sync {
                        fcControl = .imgPicker
                    }
                    willShowFullScreenCover = true
                }
                
                HStack{
                    if let shop = shopData.shop.first(where: {
                        return $0.id == shopData.currentShopID
                    }){
                        Text(shop.name)
                            .font(.custom("SFNS", size: 18))
                    }
                    
                        
                    Button(action: {
                        let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
                        serialQueue.sync {
                            fcControl = .shopDetail
                        }
                        willShowFullScreenCover = true
                        
                        
                        
                    }){
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:15)
                            .foregroundColor(Color(hex: 0x979797))
                    }

                }
                StarView(rating: shopData.currentShop.detail?.rating ?? 0) 

//                ImageEditingViewController(saveTriggered: $saveTriggered, renderedImage: self.$renderedImage)
//                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//                Button(action:{saveTriggered.toggle()}){
//                    Text("save")
//                }
                
                //Image(uiImage: renderedImage)
            }
            .padding(.top, 40)
            
            
        }
        
        
        
        
    }
    private func imageHandler( image: UIImage?) -> Void{
        
        
        var img = image ?? UIImage()
        img =  CropRect(img, ratio: 1.0)
        shopData.currentShop.shopIMGs.shopIcon = img
        
        willShowFullScreenCover = false
        SaveIMG2Backend()
        
    }
    private func SaveIMG2Backend(){
        // TODO: Call API To Update IMG Here
    }
}


private struct MaskView : View{
    
    let percentage : CGFloat
    var body: some View{
        GeometryReader{ geometry in
            HStack{
                
                Rectangle()
                    .frame(width: percentage*geometry.size.width)
            }
        }
    }
}


struct RetailerPageProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RetailerPageProfileView(willShowFullScreenCover: .constant(false), fcControl: .constant(.addProduct))
    }
}

struct StarView: View {
    
    let rating: Double
    
    var body: some View {
        HStack(spacing: 3){
            let intRate = Int(rating)
            ForEach (0 ..< intRate){ _ in
                Image("Stars_f")
            }
            if (rating !=  Double (intRate)){
                
                let percentage = rating - Double(intRate)
                
                Image("Stars_f")
                    .clipShape(Rectangle())
                ForEach (intRate + 1  ..< 5 ){ _ in
                    Image("Stars")
                }
            }else{
                ForEach (intRate ..< 5 ){ _ in
                    Image("Stars")
                }
            }
            
            Text(String(rating))
        }
    }
}
private struct halfStarView: View{
    var body: some View{
        ZStack{
            Image("Stars_f")
            Image("Stars")
        }
    }
}
