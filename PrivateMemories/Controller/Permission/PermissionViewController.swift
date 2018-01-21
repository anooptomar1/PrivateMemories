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

    let toAppSegueIdentifier = "toAppSegue"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var passcodeButton: UIButton!

    let settingsHandler = SettingsHandler.instance
    let locationManager = CLLocationManager()
    
    var isLocationAuthorized = false
    var isCameraAuthorized = false
    var isGalleryAuthorized = false
    var isPasscodeSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setup(buttons: [locationButton, cameraButton, galleryButton, passcodeButton], radius: 10.0)
    }
    
    func setAuthorizedStyle(for button: UIButton) {
        DispatchQueue.main.async {
            button.setImage(UIImage(named: "perm_checkmark"), for: .normal)
            button.backgroundColor = UIColor.xPurple
            button.setTitleColor(UIColor.white, for: .normal)
            button.isUserInteractionEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
    }
    
    func setup(buttons: [UIButton], radius: CGFloat) {
        for button in buttons {
            button.layer.cornerRadius = radius
            button.layer.borderColor = UIColor.xPurple.cgColor
            button.layer.borderWidth = 2.0
        }
    }
    
    func checkIfCompleted() {
        if isLocationAuthorized, isCameraAuthorized, isGalleryAuthorized, isPasscodeSet {
            settingsHandler.setDefault()
            performSegue(withIdentifier: toAppSegueIdentifier, sender: self)
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
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            if granted == true {
                print("AUTHORIZED")
                self.isCameraAuthorized = true
                self.setAuthorizedStyle(for: self.cameraButton)
                self.checkIfCompleted()
            }
        }
    }
    
    @IBAction func galleryButtonPressed(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { (granted) in
            if granted.rawValue == 3 {
                print("AUTHORIZED")
                self.isGalleryAuthorized = true
                self.setAuthorizedStyle(for: self.galleryButton)
                self.checkIfCompleted()
            }
        }
    }
    
    @IBAction func setPasscodeButtonPressed(_ sender: Any) {
        presentCodeSettingView()
    }
    
}

extension PermissionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.isLocationAuthorized = true
            self.setAuthorizedStyle(for: locationButton)
            checkIfCompleted()
        }
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
