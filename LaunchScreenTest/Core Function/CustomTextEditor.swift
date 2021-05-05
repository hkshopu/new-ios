//
//  CustomTextField.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import Foundation
import SwiftUI


struct customTextEditor: UIViewRepresentable{
    typealias UIViewType = UITextView
    
    @Binding var text :String
    @Binding var isEditing: Bool
    let completionHandler : () -> Void
    let textView: UITextView
    
    func makeUIView(context: Context) -> UITextView {
       
        
        textView.backgroundColor = .clear
        textView.autocorrectionType = .yes
        //tf.becomeFirstResponder()
        textView.returnKeyType = .default
        textView.autocapitalizationType = .sentences
        textView.delegate = context.coordinator
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, self.$text, completionHandler: completionHandler)
    }
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: customTextEditor
        var text: Binding<String>
        var completionHandler: () -> Void
        
        init(_ parent: customTextEditor, _ text: Binding<String>, completionHandler: @escaping () -> Void) {
            self.parent = parent
            self.text = text
            self.completionHandler = completionHandler
        }
        
        func textViewDidChange(_ textView: UITextView) {
                self.text.wrappedValue = textView.text
            }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.textView.resignFirstResponder()
            parent.text = textView.text
            parent.isEditing = false
            parent.completionHandler()
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            
            
            
            DispatchQueue.main.async{
                
//                if (tic > 4){
                    withAnimation{
                        self.parent.isEditing = true
                    }
                }
                
//            }
            
        }
        
    }
}
