//
//  CameraViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var cancelPickingPhotoButton: UIButton!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    
    var currentCamera: AVCaptureDevice!
    
    var inputDevice: AVCaptureDeviceInput!
    var photoOutput: AVCapturePhotoOutput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementsVisibility(isCurrentlyPicking: true)
        setupCaptureButtonStyle()
        setupCaptureSession()
        setupDevices()
        setupInputOutput()
        setupPreviewLayer()
        startCaptureSession()
        
    }
    
    func setElementsVisibility(isCurrentlyPicking: Bool) {
        capturedImageView.isHidden = isCurrentlyPicking
        cancelPickingPhotoButton.isHidden = isCurrentlyPicking
        captureButton.isHidden = !isCurrentlyPicking
        flipButton.isHidden = !isCurrentlyPicking
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = .photo
    }
    
    func setupDevices() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: AVCaptureDevice.Position.unspecified)
        let devices = discoverySession.devices
        
        for device in devices {
            if device.position == .back {
                backCamera = device
            }
            
            if device.position == .front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            inputDevice = try AVCaptureDeviceInput(device: currentCamera)
            
            photoOutput  = AVCapturePhotoOutput()
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
            captureSession.addInput(inputDevice)
            captureSession.addOutput(photoOutput)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    func startCaptureSession() {
        captureSession.startRunning()
    }
    
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @IBAction func cancelPickingPhotoButtonPressed(_ sender: Any) {
        startCaptureSession()
        setElementsVisibility(isCurrentlyPicking: true)
    }
    
    @IBAction func flipCameraButtonPressed(_ sender: UIButton) {
        captureSession.stopRunning()
        captureSession.removeInput(inputDevice)
        captureSession.removeOutput(photoOutput)
        currentCamera = currentCamera == backCamera ? frontCamera : backCamera
        setupInputOutput()
        startCaptureSession()
    }
    
    fileprivate func setupCaptureButtonStyle() {
        captureButton.clipsToBounds = true
        captureButton.layer.cornerRadius = captureButton.frame.width/2
        captureButton.layer.borderColor = UIColor.turquoise.cgColor
        captureButton.layer.borderWidth = 6
        captureButton.backgroundColor = UIColor.clear
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            capturedImageView.image = UIImage(data: imageData)
            setElementsVisibility(isCurrentlyPicking: false)
        }
    }
}
