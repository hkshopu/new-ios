//
//  ImageEditingView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/11.
//

import SwiftUI
import UIKit

struct ImageEditingView: View {
    
    //@Binding var saved: Bool
    @State var offset :CGSize = CGSize.zero
    @State var image = UIImage()
    @State var cropViewSize = CGSize.zero
    @State var imageViewSize = CGSize.zero
    @GestureState var multiply :CGFloat = 1
    
    var body: some View {
        
        
        let myDragGesture =
            DragGesture()
            .onChanged { distance in
                offset =
                    CGSize(width: offset.width + distance.translation.width / 100, height: offset.height + distance.translation.height / 100)
            }
        let myMagnificationGesture = MagnificationGesture()
            .updating($multiply, body: { (value, scale, transcation) in
                scale = value.magnitude
            })
            .simultaneously(with: myDragGesture)
        
        let mask = ZStack{
            let width = UIScreen.screenWidth
            Rectangle()
                .foregroundColor(Color(hex: 0x8E8E8E))
            Circle()
                .foregroundColor(.black)
        }.compositingGroup()
        .luminanceToAlpha()
        
        
        
        VStack {
            Button(action:{}){
                Text("+")
            }
            ZStack {
                Image("testimage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(CGFloat(multiply))
                    .offset(x: offset.width, y: offset.height)
                    .mask(Rectangle().frame(width: cropViewSize.width, height: cropViewSize.height, alignment: .center))
                    .background(
                        GeometryReader{ geometry in
                            let size = geometry.size
                            Rectangle()
                                .foregroundColor(.clear)
                                .preference(key: ImageSizePreferenceKey.self, value: size)
                            
                        })
                    
                    
                Rectangle()
                    .frame(width: cropViewSize.width, height: cropViewSize.height, alignment: .center)
                    .mask(mask)
                
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth/16*9, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(GeometryReader{ geometry in
                let size = geometry.size
                Rectangle()
                    .foregroundColor(.black)
                    .preference(key: SizePreferenceKey.self, value: size)
            })
            .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                cropViewSize = value
            })
            .onPreferenceChange(ImageSizePreferenceKey.self, perform: { value in
                print(value)
                if imageViewSize == CGSize.zero {
                    imageViewSize = value
                }
            })
            .gesture(myMagnificationGesture)
        }
        
    }
}
private struct SizePreferenceKey: PreferenceKey{
    typealias Value = CGSize
    
    static var defaultValue: CGSize  = CGSize.zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
private struct ImageSizePreferenceKey: PreferenceKey{
    typealias Value = CGSize
    
    static var defaultValue: CGSize  = CGSize.zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct ImageEditingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditingView()
    }
}
