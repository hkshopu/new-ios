//
//  ImagePicker.swift
//  LaunchScreenTest
//
//  Created by 林亮宇 on 2021/1/22.
//

import Foundation
import UIKit
import SwiftUI



struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias SourceType = UIImagePickerController.SourceType
    
    var originalImage: UIImage
    //@Binding var haveImage: Bool
    //@Environment(\.presentationMode) private var presentationMode
    
    let sourceType: SourceType = .photoLibrary
    let completionHandler: (UIImage?) -> Void
    
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.sourceType = sourceType
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parentImagePicker: self, completionHandler: completionHandler)
        //        return Coordinator(parentImagePicker: self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let completionHandler: (UIImage?) -> Void
        var parent : ImagePicker
        
        init(parentImagePicker : ImagePicker, completionHandler: @escaping (UIImage?) -> Void) {
            //        init(parentImagePicker : ImagePicker) {
            self.completionHandler = completionHandler
            self.parent = parentImagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image: UIImage? = {
                if let image = info[.editedImage] as? UIImage {
                    return image
                }
                return info[.originalImage] as? UIImage
            }()
            
            //parent.haveImage = true
            
            //let scaledImage = scaleImage(originalImage: image!)
            
            completionHandler(image!)
            //parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //parent.presentationMode.wrappedValue.dismiss()
            
            completionHandler(parent.originalImage)
            
        }
        
    }
}
func scaleImage(originalImage: UIImage, radius: CGFloat) -> UIImage{
    
    var scaledImage :UIImage
    let originalWidth = originalImage.size.width
    let originalHeight = originalImage.size.height
    
    var scaledWidth: CGFloat
    var scaledHeight: CGFloat
    
    let targetRadius:CGFloat = radius
    
    //preserving aspect ratio
    
    if originalWidth > originalHeight {
        scaledHeight = targetRadius
        scaledWidth = (targetRadius/originalHeight) * originalWidth
    }else{
        scaledWidth = targetRadius
        scaledHeight = (targetRadius/originalWidth) * originalHeight
    }
    
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: scaledWidth, height: scaledHeight))
    
    scaledImage = renderer.image { _ in
        originalImage.draw(in: renderer.format.bounds)
        
    }
    
    return scaledImage
}
func CropSquareImgToCenter(_ uiImage: UIImage) -> UIImage{
    
    if uiImage.size == CGSize.zero{
        return UIImage()
    }
    
    let shorterSide: CGFloat
    let cropSquare: CGRect
    
    if (uiImage.size.width > uiImage.size.height){
        
        shorterSide = uiImage.size.height
        
        let offset = (uiImage.size.width - shorterSide)/2
        
        cropSquare = CGRect(x: offset, y: 0, width: shorterSide-1, height: shorterSide-1)
    }else{
        shorterSide = uiImage.size.width
        let offset = (uiImage.size.width - shorterSide)/2
        cropSquare = CGRect(x: 0 , y: offset, width: shorterSide-1, height: shorterSide-1)
    }
    print(uiImage.size)
    print(cropSquare)
    
    let cgImageRef = uiImage.cgImage?.cropping(to: cropSquare)
    //let orientedCG = cgImageRef.oriented(CGImagePropertyOrientation(uiImage.imageOrientation))
    return UIImage(cgImage: cgImageRef!)
}
func CropRect(_ uiImage: UIImage, ratio: CGFloat) -> UIImage{
    

    let cropRect: CGRect
    
    
    let width = uiImage.size.width
    let height = uiImage.size.height
    
    if (width/height > ratio){
        //crop width
        let croppedSide = height * ratio
        let offset = ( width - croppedSide ) / 2
        cropRect = CGRect(x: offset, y: 0, width: croppedSide-1, height: height-1)
        
    }else{
        //crop shortside
        let croppedSide = width / ratio
        let offset = ( height - croppedSide ) / 2
        cropRect = CGRect(x: 0, y: offset, width: width-1, height: croppedSide-1)
    }
    print(uiImage.size)
    print(cropRect)
    let cgImageRef = uiImage.cgImage?.cropping(to: cropRect)
    return UIImage(cgImage: cgImageRef!)
}
struct customImage{
    var image :UIImage
    var imageSelected :Bool
}
