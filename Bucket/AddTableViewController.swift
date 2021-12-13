//
//  AddTableViewController.swift
//  Bucket
//
//  Created by administrator on 12/12/2021.
//

import UIKit

class AddTableViewController: UIViewController {

    
    @IBOutlet weak var bucketItem: UITextField!
    var saveItemDeleagte: SaveItemDelegate?
    var item: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bucketItem.text = item
    }

    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        guard let item = bucketItem.text else { return }
        saveItemDeleagte?.saveItem(item: item, at: index)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
  

}

protocol SaveItemDelegate {
    func saveItem(item:String, at index: Int?)
}

