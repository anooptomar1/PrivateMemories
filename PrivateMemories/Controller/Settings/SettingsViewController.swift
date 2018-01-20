//
//  SettingsViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import TOPasscodeViewController

struct CellIdentifiers {
    static let setCode = IndexPath(row: 0, section: 0)
    static let codeRequired = IndexPath(row: 1, section: 0)
    static let opensourceLibraries = IndexPath(row: 0, section: 1)
    static let appVersion = IndexPath(row: 1, section: 1)
    static let appBuild = IndexPath(row: 2, section: 1)
    static let reportIssue = IndexPath(row: 0, section: 2)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var switchCode: UISwitch!
    
    let settingsCellIdentifier = "SettingsTableViewCell"
    let preferences = SettingsHandler.instance
    let sections = ["Code", "About application", ""]
    
    let rowHeight: CGFloat = 70.0
    let headerHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
    }
    
    func setNewCode() {
        let passcodeSettingsViewController = TOPasscodeSettingsViewController(style: .dark)
        passcodeSettingsViewController.delegate = self
        passcodeSettingsViewController.passcodeType = .sixDigits
        passcodeSettingsViewController.requireCurrentPasscode = true
        self.present(passcodeSettingsViewController, animated: true, completion: nil)
    }
    
    func presentCodeView() {
        let passcodeViewController = TOPasscodeViewController(style: .translucentDark, passcodeType: .sixDigits)
        passcodeViewController.allowBiometricValidation = false //checkIfTouchIDAvailable()
        passcodeViewController.rightAccessoryButton = UIButton()
        passcodeViewController.accessoryButtonTintColor = UIColor.white
        passcodeViewController.inputProgressViewTintColor = UIColor.white
        passcodeViewController.keypadButtonTextColor = UIColor.white
        passcodeViewController.delegate = self
        self.present(passcodeViewController, animated: true, completion: nil)
    }
    
    // - MARK: IBActions

    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeCodeRequired(_ sender: UISwitch) {
        if !sender.isOn {
            presentCodeView()
            switchCode.setOn(true, animated: false)
        } else {
            preferences.isPasscodeRequired = true
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch section {
            case 0: numberOfRows = 2
            case 1: numberOfRows = 3
            case 2: numberOfRows = 1
            default: break
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier) as! SettingsTableViewCell
        var cellContent: (description: String, icon: UIImage) = ("", UIImage())
        
        switch indexPath {
            case CellIdentifiers.setCode:
                cellContent = ("Set new code", UIImage(named: "del")!)
            case CellIdentifiers.codeRequired:
                cell.selectionStyle = .none
                cellContent = ("Require code", UIImage(named: "hea")!)
                addConfiguredSwitch(to: cell)
            case CellIdentifiers.opensourceLibraries:
                cellContent = ("Open-source libraries", UIImage(named: "del")!)
                cell.accessoryType = .disclosureIndicator
            case CellIdentifiers.appVersion:
                cellContent = ("Version", UIImage(named: "edi")!)
                addAccessoryLabel(to: cell, with: preferences.appVersion)
            case CellIdentifiers.appBuild:
                cellContent = ("Build", UIImage(named: "hea")!)
                addAccessoryLabel(to: cell, with: preferences.appBuild)
            case CellIdentifiers.reportIssue:
                cellContent = ("Report bug/Contact", UIImage(named: "del")!)
            default: break
        }
        
        cell.descriptionLabel.text = cellContent.description
        cell.iconImageView.image = cellContent.icon
        return cell
    }
    
    func addAccessoryLabel(to cell: UITableViewCell, with text: String) {
        cell.selectionStyle = .none
        let accessoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cell.accessoryView = accessoryLabel
        accessoryLabel.text = text
        accessoryLabel.textColor = UIColor.darkGray
    }
    
    func addConfiguredSwitch(to cell: UITableViewCell) {
        cell.selectionStyle = .none
        switchCode = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        cell.accessoryView = switchCode
        switchCode.onTintColor = UIColor.xPurple
        switchCode.isOn = preferences.isPasscodeRequired
        switchCode.addTarget(self, action: #selector(changeCodeRequired(_:)), for: .valueChanged)
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case CellIdentifiers.setCode:
                setNewCode()
        case CellIdentifiers.opensourceLibraries:
                print("OPEN SOURCE TAPPED")
        case CellIdentifiers.reportIssue:
            if let url = URL(string: "mailto:hello@iBabis.com)") {
                UIApplication.shared.open(url)
            }
            default: break
        }
    }
}

extension SettingsViewController: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didAttemptCurrentPasscode passcode: String) -> Bool {
        return passcode == preferences.passcode
    }
    
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        preferences.passcode = passcode
        passcodeSettingsViewController.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: TOPasscodeViewControllerDelegate {
    func didInputCorrectPasscode(in passcodeViewController: TOPasscodeViewController) {
        print("CORRECT CODE")
        switchCode.setOn(false, animated: false)
        print("SETTING ON")
        preferences.isPasscodeRequired = false
        print("CHANGED PREFERENCES")
        passcodeViewController.dismiss(animated: true, completion: nil)
    }
    
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        return code == SettingsHandler().passcode
    }
}
