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
    static let clearCode = IndexPath(row: 1, section: 0)
    static let codeRequired = IndexPath(row: 2, section: 0)
    static let opensourceLibraries = IndexPath(row: 0, section: 1)
    static let appVersion = IndexPath(row: 1, section: 1)
    static let rateApp = IndexPath(row: 0, section: 2)
    static let reportIssue = IndexPath(row: 1, section: 2)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let settingsCellIdentifier = "SettingsTableViewCell"
    let preferences = SettingsHandler.Defaults
    let sections = ["Code", "About application", " "]
    let rowHeight: CGFloat = 70.0
    let headerHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        footer.backgroundColor = UIColor.lightGray
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        label.center = footer.center
        label.text = "Footer"
        label.textAlignment = .center
        footer.addSubview(label)
        tableView.tableFooterView = footer
    }
    
    @objc func changeCodeRequired(_ sender: UISwitch) {
        let value = sender.isOn
        print("SWITCH IS \(value)")
    }
    
    // - MARK: IBActions

    @IBAction func codeButtonTapped(_ sender: Any) {
        let passcodeViewController = TOPasscodeViewController(style: .translucentDark, passcodeType: .sixDigits)
        passcodeViewController.allowBiometricValidation  = false
        passcodeViewController.accessoryButtonTintColor = UIColor.turquoise
        passcodeViewController.inputProgressViewTintColor = UIColor.turquoise
        passcodeViewController.keypadButtonTextColor = UIColor.turquoise
        passcodeViewController.delegate = self
        self.present(passcodeViewController, animated: true, completion: nil)
    }
    
    @IBAction func editCodeButtonTapped(_ sender: Any) {
        let passcodeSettingsViewController = TOPasscodeSettingsViewController(style: .dark)
        passcodeSettingsViewController.delegate = self
        passcodeSettingsViewController.passcodeType = .sixDigits
        passcodeSettingsViewController.requireCurrentPasscode = true
        self.present(passcodeSettingsViewController, animated: true, completion: nil)
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
        let numberOfRows = (section == 0) ? 3 : 2
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier) as! SettingsTableViewCell
        var content: (description: String, icon: UIImage) = ("", UIImage())
        
        switch indexPath {
            case CellIdentifiers.setCode: content = ("Set new code", UIImage(named: "del")!)
            case CellIdentifiers.clearCode: content = ("Clear code", UIImage(named: "edi")!)
            case CellIdentifiers.codeRequired:
                content = ("Require code", UIImage(named: "hea")!)
                cell.selectionStyle = .none
                let switchCode = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
                cell.accessoryView = switchCode
                switchCode.onTintColor = UIColor.turquoise
                switchCode.isOn = false // TODO: z ustawień
                switchCode.addTarget(self, action: #selector(changeCodeRequired(_:)), for: .valueChanged)
            case CellIdentifiers.opensourceLibraries:
                content = ("Open-source libraries", UIImage(named: "del")!)
                cell.accessoryType = .disclosureIndicator
            case CellIdentifiers.appVersion:
                content = ("Application version", UIImage(named: "edi")!)
                cell.selectionStyle = .none
                let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                cell.accessoryView = versionLabel
                versionLabel.text = "1.0"
                versionLabel.textColor = UIColor.darkGray
            case CellIdentifiers.rateApp: content = ("Rate the app", UIImage(named: "hea")!)
            case CellIdentifiers.reportIssue: content = ("Report bug/Contact", UIImage(named: "del")!)
            default: break
        }
        
        cell.descriptionLabel.text = content.description
        cell.iconImageView.image = content.icon
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //TODO
    }
}

extension SettingsViewController: TOPasscodeViewControllerDelegate {
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        return code == "123456"
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        passcodeViewController.dismiss(animated: true, completion: nil)
    }
    
    func didInputCorrectPasscode(in passcodeViewController: TOPasscodeViewController) {
        passcodeViewController.dismiss(animated: true, completion: nil)
    }
    
    func didPerformBiometricValidationRequest(in passcodeViewController: TOPasscodeViewController) {
        //TODO
    }
}

extension SettingsViewController: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didAttemptCurrentPasscode passcode: String) -> Bool {
        return passcode == "123456"
    }
    
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        passcodeSettingsViewController.dismiss(animated: true, completion: nil)
        //TODO
    }
}
