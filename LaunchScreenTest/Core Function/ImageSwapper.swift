

//
//  ImageSwapper.swift
//  HKShopU
//
//  Created by 林亮宇 on 2021/5/5.
//

import SwiftUI

private struct ImageSwapper: View{
    @EnvironmentObject var language: SystemLanguage
    
    let imageURLSet: [String]
    
    @State var dragOffset :CGFloat = 0
    @State var imageIndex = 0
    @State var forward = true
    @State var percentage :[CGFloat] = [100.0]
    
    
    var body: some View{
        
        let maxIndex = imageURLSet.count-1
        let myGesture = DragGesture()
            .onChanged { value in
                let distance = value.translation.width
                
                self.dragOffset += distance/100
                if distance < 0 {
                    forward = true
                }
                else{
                    forward = false
                }
                withAnimation{
                    percentage[imageIndex] -= abs(distance)/200
                    if forward {
                        if imageIndex != maxIndex {
                            percentage[imageIndex+1] += abs(distance)/200
                        }
                        
                    }
                    else{
                        if imageIndex != 0 {
                            percentage[imageIndex-1] += abs(distance)/200
                        }
                    }
                }
                
            }
            .onEnded{ value in
                
                DispatchQueue.main.async {
                    withAnimation{
                        
                        if (value.translation.width < -100){
                            
                            percentage [imageIndex] = 0
                            if (imageIndex != maxIndex){
                                imageIndex += 1
                            }
                            percentage [imageIndex] = 100
                            self.dragOffset = 0
                            
                        }
                        if (value.translation.width>100){
                            
                            percentage[imageIndex] = 0
                            if (imageIndex != 0){
                                imageIndex -= 1
                                
                            }
                            percentage[imageIndex] = 100
                            
                            self.dragOffset = 0
                            
                        }
                        
                        else{
                            
                            percentage[imageIndex] = 100.0
                            if forward {
                                if imageIndex != maxIndex {
                                    percentage[imageIndex+1] = 0
                                }
                                
                            }
                            else{
                                if imageIndex != 0 {
                                    percentage[imageIndex-1] = 0
                                }
                                
                            }
                            self.dragOffset = 0
                            
                        }
                    }
                }
                
            }
        
        let myTransition = AnyTransition.asymmetric(insertion: AnyTransition.move(edge: forward ? .trailing : .leading), removal: AnyTransition.move(edge: forward ? .leading : .trailing))
        
        let size = 0.3*UIScreen.screenHeight
        
        VStack{
            switch(imageIndex){
            case 0:
                VStack(alignment: .center, spacing: 3){
                    Image("介紹_1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)

                }.gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
                
            case 1:
                VStack{
                    Image("介紹_2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)
                }
                .gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
            case 2:
                
                VStack (spacing: 16){
                    Image("介紹_3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size)
                    
                }
                .gesture(myGesture)
                .offset(x:dragOffset)
                .transition(myTransition)
                .drawingGroup()
                
            default:
                EmptyView()
            }
            Spacer()
                .frame(height:16)
            HStack{
                let focusColor = Color(hex:0x8E8E93)
                let normalColor = Color(hex:0xC4C4C4)
                ForEach( 0 ..< imageURLSet.count){ index in
                    dotView(percentage: self.$percentage[index], imageIndex: self.$imageIndex, index: index, focusColor: focusColor, normalColor: normalColor)
                }
                                
            }
        }
        .onAppear{
            for _ in 2 ..< imageURLSet.count{
                percentage.append(0.0)
            }
        }
        .padding(.top, 40)
    }
}
private struct dotView : View{
    @Binding var percentage: CGFloat
    @Binding var imageIndex: Int
    
    let index: Int
    let focusColor: Color
    let normalColor: Color
    
    var body: some View{
        Capsule()
            .frame(width:10+0.4*percentage, height:10)
            .foregroundColor(imageIndex==index ? focusColor : normalColor)
    }
}
struct ImageSwapper_Previews: PreviewProvider {
    static var previews: some View {
        ImageSwapper( imageURLSet: ["https://storage.googleapis.com/hkshopu.appspot.com/images/product_test/d5406452_20210504142655_1620109615_076290287673_img.jpeg", "https://storage.googleapis.com/hkshopu.appspot.com/images/product_test/%E8%98%8B%E6%9E%9C_20210426202257_1619439777_712508527429_img.jpg","https://storage.googleapis.com/hkshopu.appspot.com/images/product_test/image0_20210504160424_1620115464_240080293439_img.jpg"])
    }
}


