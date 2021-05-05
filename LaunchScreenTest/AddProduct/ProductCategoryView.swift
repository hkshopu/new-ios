//
//  ProductCategoryView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/31.
//

import SwiftUI

struct ProductCategorySelectView: View {
    
    @Binding var productCategory: ProductCategory
    @Binding var isShowProduceCategory: Bool
    @EnvironmentObject var internetTask: InternetTask
    @State var selectedParentID = 1
    @State var categorys: [ConvertedMainCategory] = []
    @State var subCategorys: [ConvertedSubCategory] = []
    //@State var test = ""
    let domain = "https://hkshopu-20700.df.r.appspot.com"
    private let grid :[GridItem] = Array(repeating: .init(.fixed(0.2*UIScreen.screenWidth)), count: 3)
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.bgColor)
            VStack {
                BasicNavigationBar( context: "分類總覽", showRingView: false, buttonAction: {withAnimation{isShowProduceCategory = false}}).padding()
                HStack{
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            ForEach(categorys, id: \.self.seq){ category in
                                MainCategoryElement(selectedCategoryID: self.$selectedParentID, category: category)
                                    .frame(width: 90)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedParentID = category.id
                                            DispatchQueue.main.async {
                                                getSubCategory(id: category.id)
                                            }
                                                
                                        }
                                        
                                    }
                            }
                        }
                        .padding(.vertical, 20)
                        .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.white))
                        .shadow(color: Color(hex: 0x1DBCCF, alpha: 0.1), radius: 10, x: 0.0, y: 0.0 )
                        //.frame(width: 80)
                    }
                    .onAppear{
                        // load main category
                        getCategory()
                        getSubCategory(id: selectedParentID)
                    }
                    Spacer()
                    
                    
                    VStack {
                        LazyVGrid(columns: grid, spacing: 30){
                            ForEach(subCategorys, id: \.self.seq){ subCat in
                                SubCategoryElement(productCategory: self.$productCategory,
                                                   isShowProductCategory: self.$isShowProduceCategory,
                                                   categorys: self.$categorys,
                                                   selectedParentID: self.$selectedParentID,
                                                   subCategory: subCat)
                            }
                        }
                        
                        Spacer()
                    }.padding(.vertical, 25)
                    Spacer()
                }
            }
            .padding(.top, 20)
        }
        .ignoresSafeArea(.all)
    }
    private func getCategory(){
        var semaphore = DispatchSemaphore (value: 0)
        
        let decoder = JSONDecoder()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)
        
        var apiCatReturn: APIProductMainCatReturn?
        
        var request = URLRequest(url: URL(string: "\(internetTask.domain)product_category/index/")!,timeoutInterval: Double.infinity)
        request.addValue("sessionid=b0y5zslqpg96891vzi8xd7d6fw3qq7d4", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        request.httpBody = postData
        
        let task = internetTask.session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            do{
                apiCatReturn = try decoder.decode(APIProductMainCatReturn.self, from: data)
            }catch{
                print("Error in Data Decoding!!")
            }
            //print(String(data: data, encoding: .utf8)!)
            
            if (apiCatReturn?.status == 0){
                print("retrieve category Successfull")
                ConvertCategory(categorys: apiCatReturn!.product_category_list)
                //print("c_category = \(categorys[0].c_shop_category)")
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    private func getSubCategory(id: Int){
        subCategorys = []
        var semaphore = DispatchSemaphore (value: 0)
        
        let decoder = JSONDecoder()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)
        
        var apiCatReturn: APIProductSubCatReturn?
        
        var request = URLRequest(url: URL(string: "\(internetTask.domain)product_category/\(String(id))/product_sub_category/")!,timeoutInterval: Double.infinity)
        request.addValue("sessionid=b0y5zslqpg96891vzi8xd7d6fw3qq7d4", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        request.httpBody = postData
        
        let task = internetTask.session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            do{
                apiCatReturn = try decoder.decode(APIProductSubCatReturn.self, from: data)
            }catch{
                print("Error in Data Decoding!!")
            }
            //print(String(data: data, encoding: .utf8)!)
            
            if (apiCatReturn?.status == 0){
                print("retrieve category Successfull")
                ConvertSubCategory(categorys: apiCatReturn!.product_sub_category_list)
                //print("c_category = \(categorys[0].c_shop_category)")
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    private func ConvertCategory(categorys: [ProductMainCategory]){
        for category in categorys{
            
            let id = category.id
            
            var s1 = domain
            let path1 = category.unselected_product_category_icon
            s1.append(path1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
            
            
            let unselectedImg = s1.loadImgFromURL()
            
            //print("\(category.shop_category_background_color)")
            
            var s2 = domain
            let path2 = category.selected_product_category_icon
            s2.append(path2.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
            let selectedImg = s2.loadImgFromURL()
            
            // TODO: Change accrding to region
            let title = category.c_product_category
            let seq = category.product_category_seq
            let hex = category.product_category_background_color
            
            self.categorys.append(ConvertedMainCategory(id: id, selected_img: selectedImg, unselected_img: unselectedImg, title: title, seq: seq, hex: hex))
        }
        
        print(self.categorys.count)
        self.categorys.sort { (cat1, cat2) -> Bool in
            return cat1.seq < cat2.seq
        }
    }
    private func ConvertSubCategory(categorys: [ProductSubCategory]){
        var temp: [ConvertedSubCategory] = []
        for category in categorys{
            
            let id = category.id
            
            var s1 = domain
            let path1 = category.unselected_product_sub_category_icon
            s1.append(path1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
            
            
            let unselectedImg = s1.loadImgFromURL()
            
            
            // TODO: Change accrding to region
            let title = category.c_product_sub_category
            let seq = category.product_sub_category_seq
            
            temp.append(ConvertedSubCategory(id: id, selected_img: unselectedImg, title: title, seq: seq))
        }
        self.subCategorys = temp
        
        self.subCategorys.sort { (cat1, cat2) -> Bool in
            return cat1.seq < cat2.seq
        }
    }
}

private struct MainCategoryElement: View{
    
    
    @Binding var selectedCategoryID: Int
    let category: ConvertedMainCategory
    var body: some View{
        
        let iconHeight :CGFloat = 40
        let elementHeight: CGFloat = 80
        let hexInString = category.hex
        let intVal = UInt(hexInString, radix: 16)
        
        ZStack {
            VStack{
                if selectedCategoryID == category.id{
                    Image(uiImage: category.selected_img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: iconHeight)
                    
                    
                    
                    Text(category.title)
                        .foregroundColor(Color(hex:intVal!))
                        .font(.custom("SFNS", size: 12))
                    
                    
                }
                else{
                    Image(uiImage: category.unselected_img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: iconHeight)
                    Text(category.title)
                        .foregroundColor(Color(hex:0xC4C4C4))
                        .font(.custom("SFNS", size: 12))
                }
            }.frame(height: elementHeight)
            
            Circle()
                .frame(width: 4, height: 4)
                .foregroundColor((selectedCategoryID == category.id ) ? Color(hex:intVal!) : .clear)
                .offset(y: iconHeight )
                
        }
        
    }
}
private struct SubCategoryElement: View{
    
    @Binding var productCategory :ProductCategory
    @Binding var isShowProductCategory: Bool
    @Binding var categorys: [ConvertedMainCategory]
    @Binding var selectedParentID: Int
    
    let subCategory: ConvertedSubCategory
    var body: some View{
        
        let subElementHeight:CGFloat = 40
        
        Button(action:{
            
            //TODO: Send product category to parent
            let selectedCategory = categorys.first { (cat) -> Bool in
                return cat.id == selectedParentID
            }
            isShowProductCategory = false
            //test = "\(selectedCategory?.title) > \(subCategory.title)"

            productCategory = ProductCategory(category: selectedCategory!, sub_category: subCategory)
        }) {
            VStack(spacing:10){
                Image(uiImage: subCategory.selected_img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: subElementHeight)
                Text(subCategory.title)
                    .font(.custom("SFNS", size: 12))
            }.foregroundColor(.black)
        }
    }
}
struct ProductCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let cat = ConvertedMainCategory(id: 1, selected_img: UIImage(), unselected_img: UIImage(), title: "", seq: 1, hex: "000000")
        let sub = ConvertedSubCategory(id: 1, selected_img: UIImage(), title: "", seq: 1)
        ProductCategorySelectView(productCategory: .constant(ProductCategory(category: cat, sub_category: sub)), isShowProduceCategory: .constant(false))
            .environmentObject(InternetTask())
        
    }
}

private struct APIProductMainCatReturn: Codable{
    let status: Int
    let ret_val: String
    let product_category_list: [ProductMainCategory]
}

private struct APIProductSubCatReturn: Codable{
    let status: Int
    let ret_val: String
    let product_sub_category_list: [ProductSubCategory]
}

struct ProductCategory{
    let category: ConvertedMainCategory
    let sub_category: ConvertedSubCategory
    init( category: ConvertedMainCategory, sub_category: ConvertedSubCategory){
        self.category = category
        self.sub_category = sub_category
    }
}
private  struct ProductMainCategory: Identifiable, Codable{
    
    let id: Int
    let c_product_category: String
    let e_product_category: String
    let product_category_background_color: String
    let unselected_product_category_icon: String
    let selected_product_category_icon: String
    let product_category_seq: Int
    
    let created_at: String
    let updated_at: String
    
    
}
private struct ProductSubCategory: Identifiable, Codable{
    let id: Int
    let c_product_sub_category: String
    let e_product_sub_category: String
    let unselected_product_sub_category_icon: String
    let product_sub_category_seq: Int
    
    let created_at: String
    let updated_at: String
}
struct ConvertedMainCategory: Identifiable{
    
    let id: Int
    let selected_img: UIImage
    let unselected_img:UIImage
    let title: String
    let seq: Int
    let hex: String
    
    init( id: Int, selected_img: UIImage, unselected_img: UIImage, title: String, seq: Int, hex: String){
        
        self.id = id
        self.selected_img = selected_img
        self.unselected_img = unselected_img
        self.title = title
        self.seq = seq
        self.hex = hex
    }
}
struct ConvertedSubCategory: Identifiable{
    
    let id: Int
    let selected_img: UIImage
    let title: String
    let seq: Int
    
    init( id: Int, selected_img: UIImage, title: String, seq: Int){
        
        self.id = id
        self.selected_img = selected_img
        self.title = title
        self.seq = seq
    }
}
