//
//  CameraCaptureView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//  SwiftUI에는 아직 네이티브 카메라 캡처 API가 없어서(AVFoundation으로 직접 프리뷰를 그리지 않는 한),
//  UIImagePickerController(.camera)를 최소한으로만 브릿지한다. UIKit 사용이 불가피한 경우에 해당.

import SwiftUI
import UIKit

struct CameraCaptureView: UIViewControllerRepresentable {
    let onCapture: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onCapture: onCapture)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onCapture: (UIImage?) -> Void

        init(onCapture: @escaping (UIImage?) -> Void) {
            self.onCapture = onCapture
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            onCapture(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCapture(nil)
        }
    }
}
