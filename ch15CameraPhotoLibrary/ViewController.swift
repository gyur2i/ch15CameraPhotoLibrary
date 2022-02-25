//
//  ViewController.swift
//  ch15CameraPhotoLibrary
//
//  Created by 김규리 on 2022/01/26.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController() // UIImagePickerController의 인스턴스 변수 생성
    var captureImage: UIImage! // 사진 저장 변수
    var videoURL: URL! // 비디오 URL 저장 변수
    var flagImageSave = false // 이미지 저장 여부 변수
    
    
    @IBOutlet var imgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 사진 촬영
    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) { // 카메라의 사용 가능 여부가 true 이면
            flagImageSave = true // 이미지 저장 허용
            
            imagePicker.delegate = self // 이미지피커의 델리게이트를 self로 설정
            imagePicker.sourceType = .camera // 이미지피커의 소스타입을 카메라로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String] // 미디어타입 설정
            imagePicker.allowsEditing = false // 편집 허용 x
            
            present(imagePicker, animated: true, completion: nil) // 뷰에 imagePicker가 보이도록
        }
        else { // 카메라를 사용할 수 없을 때, 경고창 나타내기
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
        
    }
    
    // 사진 불러오기
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) { // 포토라이브러리의 사용 가능 여부가 true 이면
            flagImageSave = false // 이미지 저장 허용 x
            
            imagePicker.delegate = self // 이미지피커의 델리게이트를 self로 설정
            imagePicker.sourceType = .photoLibrary // 이미지피커의 소스타입을 포토라이브러리로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String] // 미디어타입 설정
            imagePicker.allowsEditing = true // 편집 허용 O
            
            present(imagePicker, animated: true, completion: nil) // 뷰에 imagePicker가 보이도록
        }
        else { // 포토라이브러리를 사용할 수 없을 때, 경고창 나타내기
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
    }
    
    // 비디오 촬영
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) { // 카메라의 사용 가능 여부가 true 이면
            flagImageSave = true // 이미지 저장 허용
            
            imagePicker.delegate = self // 이미지피커의 델리게이트를 self로 설정
            imagePicker.sourceType = .camera // 이미지피커의 소스타입을 카메라로 설정
            imagePicker.mediaTypes = [kUTTypeMovie as String] // 미디어타입 설정
            imagePicker.allowsEditing = false // 편집 허용 x
            
            present(imagePicker, animated: true, completion: nil) // 뷰에 imagePicker가 보이도록
        }
        else { // 카메라를 사용할 수 없을 때, 경고창 나타내기
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // 비디오 불러오기
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) { // 포토라이브러리의 사용 가능 여부가 true 이면
            flagImageSave = false // 이미지 저장 허용 x
            
            imagePicker.delegate = self // 이미지피커의 델리게이트를 self로 설정
            imagePicker.sourceType = .photoLibrary // 이미지피커의 소스타입을 포토라이브러리로 설정
            imagePicker.mediaTypes = [kUTTypeMovie as String] // 미디어타입 설정
            imagePicker.allowsEditing = false // 편집 허용 x
            
            present(imagePicker, animated: true, completion: nil) // 뷰에 imagePicker가 보이도록
        }
        else { // 포토라이브러리를 사용할 수 없을 때, 경고창 나타내기
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
    }
    
    // 델리게이트 메서드 구현
    // 사용자가 사진이나 비디오를 촬영하거나 포토 라이브러리에서 선택이 끝났을 때 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString // 미디어 종류 확인
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) { // 미디어 종류가 사진이면
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage // 사진을 가져와 captureImage에 저장
            
            if flagImageSave { // flagImageSave가 true 이면
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil) // 가져온 사진을 포토 라이브러리에 저장
            }
            
            imgView.image = captureImage
            
        }
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) { // 미디어 종류가 비디오면
            
            if flagImageSave { // flagImageSave가 true이면
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) // 촬영한 비디오를 가져와 포토라이브러리에 저장
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil) //
            }
            
            self.dismiss(animated: true, completion: nil) // 뷰에서 이미지 피커 화면 제거, 초기 뷰 보여줌
        }
    }
    
    
    // 사용자가 사진이나 비디오를 찍지 않고 취소하거나 선택하지 않고 취소 하는 경우
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) // 초기 뷰 보여줌
    }
    
    
    
    
    
    // 경고 표시용 메서드
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}

