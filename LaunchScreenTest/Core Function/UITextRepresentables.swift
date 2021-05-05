//
//  ShopNameUIText.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/14.
//

import SwiftUI

struct ShopNameTextField: UIViewRepresentable{
    typealias UIViewType = UITextField
    
    @Binding var isEditing:Bool
    @Binding var text :String
    var completionHandler: () -> Void
    let textField: UITextField
    
    func makeUIView(context: Context) -> UITextField {
        
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator
        
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        //uiView.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $text, completionHandler: completionHandler)
    }
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var text: Binding<String>
        var parent: ShopNameTextField
        var completionHandler: () -> Void
        
        init(_ parent: ShopNameTextField, _ text: Binding<String>, completionHandler: @escaping () -> Void) {
            self.parent = parent
            self.text = text
            self.completionHandler = completionHandler
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isEditing = true
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
 
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField, completionHandelr: @escaping () -> Void ) {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
            
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            self.text.wrappedValue = textField.text ?? ""
            
            return true
        }
        
    }
}

struct NumericTextField: UIViewRepresentable{
    typealias UIViewType = UITextField
    
    @Binding var isEditing:Bool
    @Binding var text :String
    var completionHandler: () -> Void
    let textField: UITextField
    
    func makeUIView(context: Context) -> UITextField {
        
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator
        textField.keyboardType = .phonePad
        
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        //uiView.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $text, completionHandler: completionHandler)
    }
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var text: Binding<String>
        var parent: NumericTextField
        var completionHandler: () -> Void
        
        init(_ parent: NumericTextField, _ text: Binding<String>, completionHandler: @escaping () -> Void) {
            self.parent = parent
            self.text = text
            self.completionHandler = completionHandler
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isEditing = true
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
 
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField, completionHandelr: @escaping () -> Void ) {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
            
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            self.text.wrappedValue = textField.text ?? ""
            
            return true
        }
        
    }
}


struct SecureTextField: UIViewRepresentable{
    typealias UIViewType = UITextField
    
    @Binding var isEditing:Bool
    @Binding var text :String
    @Binding var isSecure:Bool
    var completionHandler: () -> Void
    let textField: UITextField
    
    func makeUIView(context: Context) -> UITextField {
        
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator
        textField.keyboardType = .default
        textField.isSecureTextEntry = isSecure
       
        
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        //uiView.text = text
        uiView.isSecureTextEntry = isSecure
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $text, completionHandler: completionHandler)
    }
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var text: Binding<String>
        var parent: SecureTextField
        var completionHandler: () -> Void
        
        init(_ parent: SecureTextField, _ text: Binding<String>, completionHandler: @escaping () -> Void) {
            self.parent = parent
            self.text = text
            self.completionHandler = completionHandler
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isEditing = true
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
 
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField, completionHandelr: @escaping () -> Void ) {
            self.text.wrappedValue = textField.text ?? ""
            parent.completionHandler()
            
            textField.resignFirstResponder()
            
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            self.text.wrappedValue = textField.text ?? ""
            
            return true
        }
        
    }
}
