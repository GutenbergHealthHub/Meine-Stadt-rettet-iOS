//
//  ERImageCaptureViewController.swift
//  EcoRescue
//
//  Created by Birtan on 25.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import AVFoundation

protocol ERImageCaptureViewControllerDelegate: NSObjectProtocol {
    func save(image: UIImage)
}

class ERImageCaptureViewController: UIViewController {
    
    weak var delegate: ERImageCaptureViewControllerDelegate?
    
    private let infoLabel = UILabel.calloutLabel
    
    private let photoButton  = UIButton.button()
    
    var captureSession: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let cameraView = UIView.view()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        view.addSubview(infoLabel)
        view.addSubview(cameraView)
        view.addSubview(photoButton)
        
        
        infoLabel.top().leftright().height(constant: 40).apply()
        cameraView.bottom(of: infoLabel, constant: 0).bottom(constant: 50).leftright().apply()
        photoButton.centerX().bottom(constant: 15).height(constant: 70).widthEqualsHeight().apply()
        
        infoLabel.text = String.TAKE_PICTURE_OF_YOUR_CERTIFICATE
        infoLabel.textAlignment = .center
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPhotoButton()
        addCamera()
    }
    
    private func setPhotoButton()  {
        photoButton.backgroundColor = UIColor.colorPrimaryBlue
        photoButton.tintColor = UIColor.white
        photoButton.layer.cornerRadius = 0.5 * photoButton.bounds.size.width
        photoButton.layer.borderColor = UIColor.white.cgColor
        photoButton.layer.borderWidth = 4
        photoButton.clipsToBounds = true
        photoButton.setImage(UIImage.iconCameraV2(), for: .normal)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton(sender:)), for: .touchUpInside)
    }
    
    private func addCamera() {
        
         // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
         guard let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
         fatalError("No video device found")
         }
         
         do {
         // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
         let input = try AVCaptureDeviceInput(device: captureDevice)
         
         // Initialize the captureSession object
         captureSession = AVCaptureSession()
         
         // Set the input devcie on the capture session
         captureSession?.addInput(input)
         
         // Get an instance of AVCapturePhotoOutput class
         capturePhotoOutput = AVCapturePhotoOutput()
         capturePhotoOutput?.isHighResolutionCaptureEnabled = true
         
         // Set the output on the capture session
         captureSession?.addOutput(capturePhotoOutput!)
         
         //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
         videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
         videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
         videoPreviewLayer?.frame = cameraView.layer.bounds
         cameraView.layer.addSublayer(videoPreviewLayer!)
         
         //start video capture
         captureSession?.startRunning()
         
         } catch {
         print(error)
         return
         }
    }


    
    //MARK: Actions
    
    func didTapPhotoButton(sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

}

extension ERImageCaptureViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            //imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cameraView.frame.width, height: cameraView.frame.height))
            //imageView = UIImageView.imageView()
            
            /*imageView = UIImageView(frame: cameraView.frame)
            view.addSubview(imageView!)
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFit
            imageView?.clipsToBounds = true*/
            
            let vc = ERImagePreviewViewController()
            vc.delegate = self
            vc.image    = image
            navigationController?.pushViewController(vc, animated: false)
            //present(vc, animated: false, completion: nil)
        }
    }
}

extension ERImageCaptureViewController: ERImagePreviewViewControllerDelegate {
    func save(image: UIImage) {
        delegate?.save(image: image)
    }
}
