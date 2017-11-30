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
    @IBOutlet weak var gridButton: UIButton!
    
    var gridView: GridView?
    var didJustTakePhoto: Bool = false
    
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
        
        setupGridView()
        setElementsVisibility(isCurrentlyPicking: true)
        setupCaptureButtonStyle()
        setupCaptureSession()
        setupDevices()
        setupInputOutput()
        setupPreviewLayer()
        startCaptureSession()
        addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focus(on:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(on:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDismiss(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func focus(on gesture: UITapGestureRecognizer) {
        let touchPoint: CGPoint = gesture.location(in: self.view)
        guard setFocus(on: touchPoint) else { return }
        
        let focusPointViewSize: CGSize = CGSize(width: 30.0, height: 30.0)
        let focusPointView: UIView = UIView(frame: CGRect(origin: CGPoint.init(x: 0, y: 0) , size: focusPointViewSize))
        
        focusPointView.backgroundColor = UIColor.white
        focusPointView.center = touchPoint
        focusPointView.layer.cornerRadius = focusPointView.frame.size.height/2
        focusPointView.isHidden = false
        focusPointView.alpha = 0.5
        
        self.view.addSubview(focusPointView)
        print(focusPointView.frame)
        
        focusPointView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                focusPointView.alpha = 0.5
                focusPointView.transform = CGAffineTransform.identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                focusPointView.alpha = 0
                focusPointView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            
        }) { (finished) in
            if finished {
                focusPointView.isHidden = true
            }
        }
    }
    
    @objc func zoom(on gesture: UIPinchGestureRecognizer) {
        guard let device = currentCamera else { return }
        
        let velocity = gesture.velocity
        let velocityMultiplier: CGFloat = 2.0
        let finalZoom = device.videoZoomFactor + atan2(velocity, velocityMultiplier)
        let finalScale = min(max(finalZoom, 1), device.activeFormat.videoMaxZoomFactor)
        
        if gesture.state == .began || gesture.state == .changed {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = finalScale
            } catch {
                //TODO: Alert provider
                print("Error occured while zooming")
            }
        }
        
    }
    
    @objc func swipeToDismiss(gesture: UISwipeGestureRecognizer) {
        print(gesture.debugDescription)
        if gesture.direction == .right {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupGridView() {
        let offset: CGFloat = (self.view.frame.height - self.view.frame.width)/2
        let gridFrame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: self.view.frame.width)
        gridView = GridView(frame: gridFrame, columns: 3)
        gridView?.isHidden = true
    }

    
    func setElementsVisibility(isCurrentlyPicking: Bool) {
        capturedImageView.isHidden = isCurrentlyPicking
        cancelPickingPhotoButton.isHidden = isCurrentlyPicking
        
        captureButton.isHidden = !isCurrentlyPicking
        flipButton.isHidden = !isCurrentlyPicking
        gridView?.isHidden = !isCurrentlyPicking
        gridButton.isHidden = !isCurrentlyPicking
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
    
    func setFocus(on touchPoint: CGPoint) -> Bool {
        guard let device = currentCamera, currentCamera.position == .back, device.isFocusModeSupported(.continuousAutoFocus) else { return false }
        
            let viewSize = self.view.bounds.size
            let x = touchPoint.y / viewSize.height
            let y = 1.0 - touchPoint.x / viewSize.width
            let focusPoint = CGPoint(x: x, y: y)
        
            do {
                try device.lockForConfiguration()
            
                device.focusPointOfInterest = focusPoint
                device.focusMode = .continuousAutoFocus
                device.autoFocusRangeRestriction = .far
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .continuousAutoExposure
                device.unlockForConfiguration()
            } catch {
                //TODO: AlertProvider
                print("Cannot set autofocus!")
            }
        
        return true
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
    
    @IBAction func gridButtonPressed(_ sender: Any) {
        let currentVisibilityState: Bool = gridView!.isHidden
        gridView?.isHidden = !currentVisibilityState
        self.view.addSubview(gridView!)
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
