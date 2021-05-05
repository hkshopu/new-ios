//
//  CustomerPageProfileView.swift
//  LaunchScreenTest
//
//  Created by LarryHuang on 2021/3/16.
//

import SwiftUI

struct CustomerPageProfileView: View {
    @EnvironmentObject var userData :UserData
    @State var uservaluation:Double = 3.4
    @State var CutomerName = "訪客"
    
    var body: some View {
        VStack{
            //User Image
            ZStack{
            Text("")
                Circle()
                    .fill(Color(.systemGray3))
                    .frame(width: UIScreen.screenWidth*0.4, height: UIScreen.screenHeight*0.2)
            Image("Shape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.clipShape(Circle())
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(width:0.2*UIScreen.screenWidth,height: 0.2*UIScreen.screenHeight)
//                .mask(Text("Test"))
//                    .font(.system(size: 30))
            }
            VStack(alignment:.leading){
                HStack{
                    //User name
                    Text("\(CutomerName)")
                        .font(.title)
                    Button(action:{}){
                        Image(systemName: "pencil")
                            .renderingMode(.original)
                            .opacity(0.8)
                    }
                    
                }
                
            }.padding()
            HStack{
                VStack{
                FiveStarView(rating: uservaluation).frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }.frame(width: 150, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Text(String(format: "%.1f", uservaluation))
                    .font(.title)
            }
            
            //Spacer()
            // Gear Setting Button
//            Button(action:{
//                //Goto Edit View
//            }){
//                Image("ShopGeneral_SettingButtonTriangleIcon")
//                    //systemName: "gearshape.fill")
//                    .resizable()
//                    .foregroundColor(.black)
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 0.1*UIScreen.screenWidth)
//                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
//            }
        }.padding(20.0)
    }
}

struct CustomerPageProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageProfileView()
    }
}

public struct FiveStarView: View {
    var rating: Double
    var color: Color
    var backgroundColor: Color

    public init(
        rating: Double,
        color: Color = .yellow,
        backgroundColor: Color = .gray
    ) {
        self.rating = rating
        self.color = color
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            BackgroundStars(backgroundColor)
            ForegroundStars(rating: rating, color: color)
        }
    }
}


private struct StarImage: View {
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}


private struct BackgroundStars: View {
    var color: Color

    init(_ color: Color) {
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage()
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Double
    var color: Color

    init(rating: Double, color: Color) {
        self.rating = rating
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: self.rating,
                    color: self.color,
                    index: index
                )
            }
        }
    }
}
struct RatingStar: View {
    var rating: CGFloat
    var color: Color
    var index: Int
    
    
    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }


    init(rating: Double, color: Color, index: Int) {
        // Why Double? Decoding floats and doubles is not accurate.
        self.rating = CGFloat(Double(rating.description) ?? 0)
        self.color = color
        self.index = index
    }


    var body: some View {
        GeometryReader { star in
            Image(systemName: "star.fill")
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(
                            width: star.size.width * self.maskRatio,
                            height: star.size.height
                        )
                    
                )
        }
    }
}

