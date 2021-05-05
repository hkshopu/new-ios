//
//  ImageEditingViewController.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/11.
//

import SwiftUI

struct ImageEditingViewController: UIViewControllerRepresentable{
    
    @Binding var saveTriggered: Bool
    @Binding var renderedImage: UIImage
    
    @State var saved = false
    let vc = UIHostingController(rootView: ImageEditingView())
    //@State var vc :UIViewController?
   
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
//        let view = vc.view
//        let renderer = UIGraphicsImageRenderer(size: (view!.bounds.size))
//        let image = renderer.image{ ctx in
//            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
//        }
//        renderedImage = image
    }
}
