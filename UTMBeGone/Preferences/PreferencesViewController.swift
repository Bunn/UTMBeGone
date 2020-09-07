//
//  PreferencesViewController.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Query Items"
    }
    
    @objc private func textDidChange(_ sender: NSTextField) {
        print("HI \(sender.stringValue)")
        let row = tableView.row(for: sender)
        print("row\(row)")
    }
    
}

extension PreferencesViewController: NSTableViewDelegate {
    
}

extension PreferencesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DefaultTableCell"), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = "Test"
        cell?.textField?.target = self
        cell?.textField?.action = #selector(PreferencesViewController.textDidChange)
        return cell
    }
    
}
