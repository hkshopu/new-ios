//
//  CategorySelectView.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/15.
//

import SwiftUI

struct CategorySelectView: View {
    
    @EnvironmentObject var internetTask: InternetTask
    
    
    private let grid :[GridItem] = Array(repeating: .init(.fixed(0.28*UIScreen.screenWidth)), count: 3)
    
    
    @State var categorys: [CustomCategory] = []
    @State var selectedCount = 0
    
    @Binding var selectedCat: [ShopCategory]
    @Binding var isShowShopCategoryView:Bool
    @Binding var isShopCategorySelected: Bool
    
    var shouldCallApi: Bool?
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.bgColor)
                .ignoresSafeArea()
            VStack {
                //Spacer()
                HStack{
                    let arrowGray = Color(hex:0x8E8E93)
                    let TextGray = Color(hex: 0x48484A)
                    Button(action:{
                        isShowShopCategoryView = false
                    }){
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .frame(width:24, height:24)
                            .foregroundColor(arrowGray)
                        
                        
                    }
                    Spacer()
                    Text("分類總覽")
                        .font(.custom("SFNS", size: 18))
                    Spacer()
                }.padding(20)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: grid, alignment: .center, spacing: 0.06*UIScreen.screenWidth){
                        
                        //if categorys.count != 0 {
                        if !categorys.isEmpty {
                            ForEach(categorys, id: \.self.id){ cat in
                                
                                Element(
                                        selectedCount: self.$selectedCount,
                                    category: $categorys[categorys.firstIndex(where: { (CustomCategory) -> Bool in
                                        return cat.id == CustomCategory.id
                                    })!])
                            }
                        }
                        
                    }
                    .onAppear{
                        
                        //call get category api
                        getCategory()
                        //sort category with seq

                        //initialize arrays
                        
                        // read selected Categorys
                        if !selectedCat.isEmpty{
                            for category in selectedCat{
                                
                                for count in 0 ..< self.categorys.count{
                                    if categorys[count].category.id == category.id {
                                        categorys[count].isSelected = true
                                    }
                                }
                                selectedCount += 1
                            }
                            
                        }
                        
                }
                }
                Spacer()
                
                Button(action:{
                    // save selected options
                    if selectedCount != 0{
                        var c:[ShopCategory] = []
                        for count in 0 ..< categorys.count{
                            if categorys[count].isSelected{
                                c.append(categorys[count].category)
                            }
                        }
                        selectedCat = c
                        isShowShopCategoryView = false
                        isShopCategorySelected = true
                    }
                    //print(selectedCatIDs)
                    if let shouldCallApi = self.shouldCallApi{
                        if shouldCallApi{
                            var param = ""
                            for cat in selectedCat {
                                param.append("category_id=\(cat.id)")
                                if cat.id != selectedCat.last!.id {
                                    param.append("&")
                                }
                                
                            }
                            callSaveChangeApi(param: param)
                        }
                    }
                }){
                    let buttonHeight = 0.08*UIScreen.screenHeight
                    
                    if selectedCount == 0{
                        ZStack{
                            RoundedRectangle(cornerRadius: buttonHeight/2)
                                .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                .foregroundColor(Color(hex: 0x1DBCCF))
                            RoundedRectangle(cornerRadius: buttonHeight/2-2)
                                .frame(width : 0.7*UIScreen.screenWidth-4, height:buttonHeight-4)
                                .foregroundColor(.bgColor)
                            Text("未選擇分類")
                                .foregroundColor(Color(hex: 0x1DBCCF))
                                .fontWeight(.bold)
                        }
                    }else{
                        ZStack{
                            RoundedRectangle(cornerRadius: buttonHeight/2)
                                .frame(width : 0.7*UIScreen.screenWidth, height:buttonHeight)
                                .foregroundColor(Color(hex: 0x1DBCCF))
                                
                                .foregroundColor(.bgColor)
                            Text("已選擇\(String(selectedCount))項分類")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
                
            }
            .padding(.vertical, 40)
        }
        .ignoresSafeArea(.all)
        
    }
    private func callSaveChangeApi(param: String){
        print(param)
        //TODO: call update category api here
    }
    private func getCategory(){
        var semaphore = DispatchSemaphore (value: 0)
        
        let decoder = JSONDecoder()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)
        
        var apiCatReturn: APICatReturn?
        
        var request = URLRequest(url: URL(string: "\(internetTask.domain)shop_category/index/")!,timeoutInterval: Double.infinity)
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
                apiCatReturn = try decoder.decode(APICatReturn.self, from: data)
            }catch{
                print("Error in Data Decoding!!")
            }
            //print(String(data: data, encoding: .utf8)!)
            
            if (apiCatReturn?.status == 0){
                print("retrieve category Successfull")
                var tempCategorys = apiCatReturn!.shop_category_list
                for cat in tempCategorys{
                    if cat.is_delete == "Y" {
                        tempCategorys.remove(at: tempCategorys.firstIndex(where: { (Category) -> Bool in
                            return cat.id == Category.id
                        })!)
                    }
                }
                
                tempCategorys.sort { (cat1, cat2) -> Bool in
                    cat1.shop_category_seq < cat2.shop_category_seq
                }
                var id = 0
                for cat in tempCategorys{
                    var s1: String
                    s1 = internetTask.domain
                    let path1 = cat.unselected_shop_category_icon
                    s1.append(path1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
                    let unselectedIMG = s1.loadImgFromURL()
                    
                    //print("\(category.shop_category_background_color)")
                    
                    var s2: String
                    
                    s2 = internetTask.domain
                    let path2 = cat.selected_shop_category_icon
                    s2.append(path2.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
                    let selectedIMG = s2.loadImgFromURL()
                    categorys.append(CustomCategory(id: id, category: cat, isSelected: false,selectedIMG: selectedIMG, unselectedIMG: unselectedIMG))
                    id += 1
                }
                //print("c_category = \(categorys[0].c_shop_category)")
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(selectedCat: .constant([]), isShowShopCategoryView: .constant(true), isShopCategorySelected: .constant(true))
            .environmentObject(InternetTask())
    }
}
struct APICatReturn: Codable{
    let status: Int
    let ret_val: String
    let shop_category_list: [ShopCategory]
}
struct ShopCategory: Identifiable, Codable{
    
    let id: Int
    let c_shop_category: String
    let e_shop_category: String
    let shop_category_background_color: String
    let unselected_shop_category_icon: String
    let selected_shop_category_icon: String
    let shop_category_seq: Int
    let is_delete:String
    
    let created_at: String
    let updated_at: String
    
    
}
struct CustomCategory : Identifiable{
    let id: Int
    let category: ShopCategory
    var isSelected: Bool
    var selectedIMG :UIImage
    var unselectedIMG: UIImage
    init(id: Int, category: ShopCategory, isSelected:Bool, selectedIMG:UIImage, unselectedIMG:UIImage){
        self.category = category
        self.isSelected = isSelected
        self.selectedIMG = selectedIMG
        self.unselectedIMG = unselectedIMG
        self.id = id
    }
}
private struct Element:View {
    
    
    @Binding var selectedCount: Int
    
    @Binding var category: CustomCategory
    
    
    var body: some View{
        Button(action:{
            if category.isSelected{
                category.isSelected.toggle()
                selectedCount -= 1
            }else{
                if selectedCount<3{
                    category.isSelected.toggle()
                    selectedCount += 1
                }
            }
        }){
            VStack{
                Group{
                    if (category.isSelected) {
                        Image(uiImage: category.selectedIMG)
                            //Image(uiImage: selectedIMG)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height:80)
                            .foregroundColor(.green)
                    }
                    else{
                        
                        
                        Image(uiImage: category.unselectedIMG)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height:80)
                            .foregroundColor(.red)
                    }
                }
                
                Text(category.category.c_shop_category)
                    .foregroundColor(.black)
                
            }
        }
    }
}
