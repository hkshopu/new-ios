import SwiftUI
import Photos
import BSImagePicker


public struct ImagePickerCoordinatorView {
    
    @Binding var images : [UIImage]
    @Binding var assets : [PHAsset]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

extension ImagePickerCoordinatorView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = ImagePickerController
    
    public func makeUIViewController(context: Context) -> ImagePickerController {
        
        var picker = ImagePickerController()
        
        if !assets.isEmpty {
            let pickerWithAssets = ImagePickerController(selectedAssets: assets)
            picker = pickerWithAssets
        }
        
        
        picker.settings.selection.max = 5
        picker.settings.selection.unselectOnReachingMax = false
        picker.settings.theme.selectionStyle = .numbered
        picker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        picker.imagePickerDelegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

extension ImagePickerCoordinatorView {
    public class Coordinator: ImagePickerControllerDelegate {
        private let parent: ImagePickerCoordinatorView
        
        public init(_ parent: ImagePickerCoordinatorView) {
            self.parent = parent
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
            print("Selected: \(asset)")
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
            print("Deselected: \(asset)")
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
            print("Finished with selections: \(assets)")
            
            let astManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            
            var imagesSelected: [UIImage] = []
            
            for asset in assets {
                astManager.requestImage(for: asset,
                                        targetSize: PHImageManagerMaximumSize, contentMode: .default,
                                        options: option,
                                        resultHandler: {(result, _) ->Void in
                                            imagesSelected.append(result ?? UIImage())
                                        })
            }
            
            parent.assets = assets
            parent.images = imagesSelected
            parent.dismiss()
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
            print("Canceled with selections: \(assets)")
            parent.dismiss()
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didReachSelectionLimit count: Int) {
            print("Did Reach Selection Limit: \(count)")
        }
    }
}
