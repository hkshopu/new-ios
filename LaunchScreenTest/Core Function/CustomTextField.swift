//
//  CustomTextField.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/3/12.
//

import Foundation
import SwiftUI


struct customTextField: UIViewRepresentable{
    typealias UIViewType = UITextField
    
    @Binding var text :String
    @Binding var currentTextField: UITextField
    let placeholder: String
    let tf: UITextField
    let tfType: UIKeyboardType
    let completionHandler: ()->Void
    var alignment: NSTextAlignment?
    var textColr: UIColor?
    var font: UIFont?
    
    func makeUIView(context: Context) -> UITextField {
        tf.text = text
        tf.borderStyle = .none
        tf.autocorrectionType = .no
        //tf.becomeFirstResponder()
        tf.delegate = context.coordinator
        tf.placeholder = self.placeholder
        tf.keyboardType = tfType
        tf.textColor = .black
        
        if let alignment = self.alignment{
            tf.textAlignment = alignment
        }
        if let color = textColr{
            
            tf.textColor = color
        }else{
            tf.textColor = .black
        }
        if let font = self.font{
            tf.font = font
        }else{
            tf.font = UIFont(name: "SFNS", size: 14)
        }
        return tf
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $text, completionHandler: completionHandler)
    }
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: customTextField
        var text: Binding<String>
        
        let completionHandler: ()->Void
        
        init(_ parent: customTextField, _ text: Binding<String>, completionHandler: @escaping ()->Void) {
            self.parent = parent
            self.text = text
            self.completionHandler = completionHandler
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.currentTextField = textField
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.text.wrappedValue = textField.text ?? ""
            // user press return, close the editview
            completionHandler()
            textField.resignFirstResponder()
            return !textField.isEditing
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
            textField.resignFirstResponder()
            
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            self.text.wrappedValue = textField.text ?? ""
            
            return true
        }
        
    }
}
