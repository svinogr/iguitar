//
//  AckordViewController.swift
//  iguitar
//
//  Created by Up Devel on 23/07/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class AckordViewController: UIViewController {
    public var ackord: Ackord!
    @IBOutlet weak var ackordImage: UIImageView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBAction func cansel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let ackordDao = AckordDao()
        let saveAcckord = getAcckordForSave()
        
        ackordDao.update(oldItem: saveAcckord)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getAcckordForSave() -> Ackord {
        let saveAckord = Ackord()
        saveAckord.imageData = ackordImage.image?.jpegData(compressionQuality: 0.2)
        saveAckord.name = ackord.name
        saveAckord.id = ackord.id
        saveAckord.isUser = true
    
        return saveAckord
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.isEnabled = false
        setStyleApp()
        setupNavigationBar()
        setupAccord()
        // Do any additional setup after loading the view.
    }
    
    private func setupAccord() {
        if (!ackord.isUser) {
            setupTryAppImage()
         } else {
            setupTryAddImage()
        }
    }
    
    private func setupTryAppImage() {
        if (ackord.imageData != nil ){
            if let image = UIImage(data: ackord.imageData!) {
                ackordImage.image = image
            }
        } else {
            setupTryAddImage()
        }
    }
    
    private func setupTryAddImage() {
        if (ackord.imageData != nil ){
            if let image = UIImage(data: ackord.imageData!) {
                ackordImage.image = image
            }
        } else {
            ackordImage.image = UIImage(named: "trash")
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        ackordImage.addGestureRecognizer(tapGesture)
        ackordImage.isUserInteractionEnabled = true
    }
    
    @objc private func imageTapped(gesture: UITapGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
      chooseImage(by: .photoLibrary)
        }
    }
    
    private func setStyleApp() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupNavigationBar() {
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
        navigationItem.leftBarButtonItem = nil
        top?.backBarButtonItem?.tintColor = tintColor
        title = ackord.name.ackordUpCase
    }

}
extension AckordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage(by source: UIImagePickerController.SourceType ) {
        let uIPC = UIImagePickerController()
        uIPC.delegate = self
        uIPC.allowsEditing = true
        uIPC.sourceType = source
        
        present(uIPC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ackordImage.image = info[.editedImage] as? UIImage
        ackordImage.contentMode = .scaleToFill
        ackordImage.clipsToBounds = true
        dismiss(animated: true, completion: nil)
        saveBtn.isEnabled = true
        //isChageImage = true
    }
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
