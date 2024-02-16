//
//  TextViewManager.swift
//  Primal
//
//  Created by Pavle Stevanović on 19.9.23..
//

import Combine
import Foundation
import UIKit

struct PostingAsset {
    let id = UUID().uuidString
    var resource: ImagePickerResult
    var state = State.uploading(0)
    
    enum State {
        case uploaded(String)
        case failed
        case uploading(CGFloat)
    }
}

class TextViewManager: NSObject, UITextViewDelegate {
    @Published var isEditing = false
    @Published var isEmpty = true
    
    @Published var media: [PostingAsset] = []
    
    var didChangeEvent = PassthroughSubject<UITextView, Never>()
    
    let textView: UITextView
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(textView: UITextView) {
        self.textView = textView
    }
    
    var postingText: String {
        var text = textView.text ?? ""
        
        for image in media {
            guard case .uploaded(let url) = image.state else { continue }
            text += "\n" + url
        }
        
        return text
    }
    
    var isUploadingImages: Bool {
        for image in media {
            if case .uploading = image.state {
                return true
            }
        }
        return false
    }
    
    var didUploadFail: Bool {
        for image in media {
            if case .failed = image.state {
                return true
            }
        }
        return false
    }
    
    func processSelectedAsset(_ asset: ImagePickerResult) {
        let postingImage = PostingAsset(resource: asset)
        media.append(postingImage)
        uploadSelectedImage(postingImage.id)
    }
    
    func uploadSelectedImage(_ id: String) {
        guard let postingIndex = media.firstIndex(where: { $0.id == id }) else { return }
        
        let postingImage = media[postingIndex]
        
        if case .uploaded = postingImage.state { return }
        
        media[postingIndex].state = .uploading(0)
        
        let upload = UploadAssetRequest(asset: postingImage.resource)
        
        upload.$progress.removeDuplicates().receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.media[postingIndex].state = .uploading(progress)
            }
            .store(in: &cancellables)
        
        upload.publisher().receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] in
                guard case .failure(let error) = $0, let index = self?.media.firstIndex(where: { $0.id == postingImage.id }) else { return }
                
                self?.media[index].state = .failed
                print(error)
            }, receiveValue: { [weak self] urlString in
                guard let index = self?.media.firstIndex(where: { $0.id == postingImage.id }) else { return }
                
                self?.media[index].state = .uploaded(urlString)
            })
            .store(in: &self.cancellables)
    }
    
    func restartFailedUploads() {
        for image in media {
            if case .failed = image.state {
                uploadSelectedImage(image.id)
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.invalidateIntrinsicContentSize() // Necessary for self sizing text field
        didChangeEvent.send(textView)
        
        isEmpty = postingText.isEmpty
    }
}

extension TextViewManager: PostingImageCollectionViewDelegate {
    func didTapImage(resource: PostingAsset) {
        
    }
    
    func didTapDeleteImage(resource: PostingAsset) {
        media = media.filter { $0.id != resource.id }
    }
}
