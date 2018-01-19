//
//  PermissionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 19.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import AVFoundation
import TOPasscodeViewController

class PermissionViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var passcodeButton: UIButton!
    @IBOutlet weak var goToAppButton: UIButton!
    
    let settingsHandler = SettingsHandler.instance
    let locationManager = CLLocationManager()
    
    var isLocationAuthorized = false
    var isCameraAuthorized = false
    var isGalleryAuthorized = false
    var isPasscodeSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToAppButton.isHidden = true
    }
    
    func setAuthorizedStyle(for button: UIButton) {
        DispatchQueue.main.async {
            button.isEnabled = false
            //TODO: Style
        }
    }
    
    func checkIfCompleted() {
        if isLocationAuthorized, isCameraAuthorized, isGalleryAuthorized, isPasscodeSet {
            settingsHandler.setDefault()
            UIView.animate(withDuration: 0.7, animations: {
                self.goToAppButton.isHidden = false
            })
        }
    }
    
    func presentCodeSettingView() {
        let passcodeSettingsViewController = TOPasscodeSettingsViewController(style: .dark)
        passcodeSettingsViewController.delegate = self
        passcodeSettingsViewController.passcodeType = .sixDigits
        passcodeSettingsViewController.requireCurrentPasscode = false
        self.present(passcodeSettingsViewController, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        //TODO: Observe status value change
        self.isLocationAuthorized = true
        self.setAuthorizedStyle(for: locationButton)
        checkIfCompleted()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            self.isCameraAuthorized = true
            self.setAuthorizedStyle(for: self.cameraButton)
            self.checkIfCompleted()
        }
    }
    
    @IBAction func galleryButtonPressed(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { (granted) in
            self.isGalleryAuthorized = true
            self.setAuthorizedStyle(for: self.galleryButton)
            self.checkIfCompleted()
        }
    }
    
    @IBAction func setPasscodeButtonPressed(_ sender: Any) {
        presentCodeSettingView()
    }
    
}

extension PermissionViewController: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        settingsHandler.passcode = passcode
        passcodeSettingsViewController.dismiss(animated: true) {
            self.isPasscodeSet = true
            self.setAuthorizedStyle(for: self.passcodeButton)
            self.checkIfCompleted()
        }
    }
}
