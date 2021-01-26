//
//  AddShopBodyView.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/22.
//

import SwiftUI
import UIKit

extension AddShopMainView {
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        private(set) var sourceType: ImagePicker.SourceType = .camera
        
        func choosePhoto() {
            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }
        
        func takePhoto() {
            sourceType = .camera
            isPresentingImagePicker = true
        }
        
        func didSelectImage(_ image: UIImage?) {
            selectedImage = image
            isPresentingImagePicker = false
        }
    }
}

struct AddShopInfoView: View {
    
    //@Binding var shopData: ShopData
    @State var imageSelected = false
    @State var descriptionEntered = false
    @State var isEditing = false
    @State var description = ""
    @State var shopCategorySelected = false
    @State var paymentMethodSelected = false
    @State var shippingFeeSelected = false
    //@State var description : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ex dui, interdum vitae pellentesque sit amet, aliquam nec dui. Praesent et magna quis nisl tincidunt feugiat in quis mi. Sed euismod ullamcorper lacus ac ultrices. Suspendisse egestas ante id bibendum molestie. Nunc et nibh bibendum, efficitur dolor non, elementum augue. In lacinia, ipsum non rhoncus scelerisque, justo sem pharetra risus, quis consequat lectus quam id mauris. Donec laoreet leo nec ipsum tincidunt pulvinar. Quisque et quam sit amet est viverra consectetur eget a mauris. Nulla ullamcorper tristique enim non mollis."

    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                VStack{
                    ZStack{
                        //shop title
                        EmptyView()
                    }
                    HStack{
                        Text("Shop Category")
                        Spacer()
                        if true {
                            //button trigger
                            //show selected category
                        }
                        Button(action: {
                            
                            withAnimation{
                                
                                shopCategorySelected.toggle()
                                
                            }
                            
                        }){
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                                .foregroundColor(.black)
                                .rotationEffect()
                        }
                    }.padding(.horizontal, 40.0)
                    
                    if shopCategorySelected {
                        //button trigger
                        //show PaymentMethodView
                        ShopCategoryView()
                    }
                    
                    ZStack{
                        
                        ShopImageView(imageSelected: self.$imageSelected,
                                      descriptionEntered: self.$descriptionEntered,
                                      isEditing: self.$isEditing,
                                      description: self.$description)
                    }
                    
                    VStack(alignment: .leading){
                        Text("Payment Method")
                            .padding(.vertical)
                        HStack{
                            Image(systemName: "applelogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.gray)
                            Image(systemName: "applelogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.gray)
                            Image(systemName: "applelogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.gray)
                            Image(systemName: "applelogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "banknote.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundColor(.gray)
                            Text("Bank In")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical)
                    }.padding(.horizontal, 40.0)
                    
                    HStack{
                        Text("Payment Method")
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                
                                paymentMethodSelected.toggle()
                                
                            }
                            
                        }){
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                                .foregroundColor(.black)
                        }
                    }.padding(.horizontal, 40.0)
                    if paymentMethodSelected {
                        //button trigger
                        //show PaymentMethodView
                        PaymentMethodView()
                    }
                    Spacer().frame(height:30)
                    HStack{
                        Text("Shipping Fee Setting")
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                
                                shippingFeeSelected.toggle()
                                
                            }
                        }){
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20)
                                .foregroundColor(.black)
                        }
                    }.padding(.horizontal, 40.0)
                    if shippingFeeSelected {
                        //button trigger
                        //show ShippingFeeView
                        ShippingFeeView()
                    }
                }
            }.onAppear{
                //description = shopData.description
                if description != ""{
                    descriptionEntered = true
                }
            }
            
            if isEditing{
                TextEditView(originalDescription: self.$description,
                             isEditing: self.$isEditing,
                             descriptionEntered: self.$descriptionEntered)
                    .transition(AnyTransition.scale)
            }
        }
    }
}


struct ShopImageView: View{
    
    @Binding var imageSelected: Bool
    @Binding var descriptionEntered: Bool
    @Binding var isEditing : Bool
    @Binding var description : String
    
    @State var isShowImgPicker = false
    @State var image = UIImage()
    @StateObject var viewModel = ViewModel()
    
    
    var body: some View{
        ZStack {
            VStack{
                
                //Image Picker
                
                ZStack{
                    
                    getImageView(for: viewModel.selectedImage)
                    Button(action:{viewModel.choosePhoto()}){
                        if !imageSelected{
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 0.15*UIScreen.screenWidth)
                                .opacity(1)
                            
                            
                        }
                        else{
                            Image(systemName: "camera.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 0.15*UIScreen.screenWidth)
                                .opacity(0.6)
                            
                        }
                    }.offset(x:0.32*UIScreen.screenWidth,
                             y: 0.14*UIScreen.screenWidth)
                    
                    
                    
                }
                
                .frame(width: 0.8*UIScreen.screenWidth,
                       height: 0.8*9/16*UIScreen.screenWidth)
                
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: imageSelected ? 0 : 1)
                .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker, content: {
                            ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
                        })
                
                // Shop Description
                VStack (alignment: .leading){
                    Text("Shop Description & Information")
                    HStack(alignment: descriptionEntered ? .top : .center
                    ){
                        //
                        //                    if (description != ""){
                        //
                        //                    }
                        if !isEditing{
                            if descriptionEntered {
                                Group{
                                    Text( description).padding(.trailing)
                                    Spacer()
                                    Button(action:{
                                        withAnimation{
                                            isEditing.toggle()
                                        }
                                    }){
                                        
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .foregroundColor(.gray)
                                            .frame(width: 0.1*UIScreen.screenWidth, height: 0.1*UIScreen.screenWidth)
                                            .aspectRatio( contentMode: .fit)
                                        
                                        
                                    }
                                }.drawingGroup()
                                
                            }
                            else{
                                Group{
                                    
                                    Button(action:{
                                        withAnimation{
                                            isEditing.toggle()
                                        }
                                    }){
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .foregroundColor(.gray)
                                            .aspectRatio( contentMode: .fit)
                                            .frame(width: 0.12*UIScreen.screenWidth)
                                    }
                                    Text("Add Description")
                                        .padding()
                                    Spacer()
                                    
                                }.drawingGroup()
                                
                            }
                        }
                        
                        
                    }.frame(width: 0.8*UIScreen.screenWidth)
                    .ignoresSafeArea(edges: .all)
                }
                
                
                
                
            }
            
        }
    }
    
    @ViewBuilder
    func getImageView(for image: UIImage?) -> some View {
        
        let width = 0.8*UIScreen.screenWidth
        
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .mask(Rectangle()
                        .frame(width:width, height: width*9/16))
                .onAppear{
                    imageSelected = true
                }
        }
        else {
            Text("No image selected")
                .onAppear(){
                    imageSelected = false
                }
        }
    }
    

    
}

struct TextEditView: View{
    // Done
    @Binding var originalDescription: String
    @Binding var isEditing :Bool
    @Binding var descriptionEntered: Bool
    
    @State var newDescription: String = ""
    
    var body: some View{
        
        
        VStack(spacing: 0.0) {
            
            TextEditor(text: $newDescription)
                .frame(width: 0.8*UIScreen.screenWidth, height: 0.45*UIScreen.screenWidth, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(10.0)
            
            HStack(spacing: 0.0){
                Button(action:{
                    withAnimation{
                        isEditing.toggle()
                    }
                    
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width:0.4*UIScreen.screenWidth, height: 0.1*UIScreen.screenWidth)
                            .foregroundColor(.red)
                        Text("Decline")
                            .foregroundColor(.white)
                    }
                }
                Button(action:{
                    withAnimation{
                        originalDescription = newDescription
                        if originalDescription != ""{
                            descriptionEntered = true
                        }else{
                            descriptionEntered = false
                        }
                        isEditing.toggle()
                    }
                    
                }){
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width:0.4*UIScreen.screenWidth, height: 0.1*UIScreen.screenWidth)
                            .foregroundColor(.green)
                        Text("Accept")
                            .foregroundColor(.white)
                    }
                }
            }
        }.shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ )
        .onAppear(){
            self.newDescription = self.originalDescription
        }
    }
}

extension ShopImageView {
    
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        
        
        private(set) var sourceType: ImagePicker.SourceType = .camera
        
        func choosePhoto() {
            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }
        
        func takePhoto() {
            sourceType = .camera
            isPresentingImagePicker = true
        }
        
        func didSelectImage(_ image: UIImage?) {
            selectedImage = image
            
            isPresentingImagePicker = false
        }
    }
    
}

struct AddShopInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddShopInfoView()
    }
}
