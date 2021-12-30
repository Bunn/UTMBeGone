//
//  PreferencesViewController.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    private static let cellIdentifier = "DefaultTableCell"
    private let itemsManager = QueryItemsManager()
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "UTMBeGone Preferences"
    }
    
    @objc private func textDidChange(_ sender: NSTextField) {
        let row = tableView.row(for: sender)
        if row == -1 {
            return
        }
        itemsManager.item(for: row).value = sender.stringValue
        itemsManager.save()
    }
    
    @IBAction func addItemButtonClicked(_ sender: NSButton) {
        _ = itemsManager.createNewItem()
        tableView.reloadData()
    }
    
    @IBAction func removeItemButtonClicked(_ sender: NSButton) {
        let selectedRow = tableView.selectedRow
        if selectedRow == -1 {
            return
        }
        let item = itemsManager.item(for: selectedRow)
        itemsManager.delete(item)
        tableView.reloadData()
    }
    
    @IBAction func projectWebsiteButtonClicked(_ sender: NSButton) {
        OpenWebsiteHelper.openWebsite()
    }
}

extension PreferencesViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: PreferencesViewController.cellIdentifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = itemsManager.item(for: row).value
        cell?.textField?.target = self
        cell?.textField?.action = #selector(PreferencesViewController.textDidChange)
        return cell
    }
}

extension PreferencesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return itemsManager.numberOfItems
    }
}
