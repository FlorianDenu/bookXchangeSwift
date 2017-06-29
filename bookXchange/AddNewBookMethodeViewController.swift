//
//  AddNewBookMethodeViewController.swift
//  bookXchange
//
//  Created by emily on 2017-05-28.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import BarcodeScanner
import DGActivityIndicatorView

//MARK: Barcode scanner delegate methods
extension AddNewBookMethodeViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        let isbn = String(code)
        GoogleBookApiManager.googleBook(isbn: isbn!) { (jsonResponse) in
            self.jsonResponse = jsonResponse
            self.isbn = isbn
            self.performSegue(withIdentifier: self.addNewBookId, sender: nil)
            controller.dismiss(animated: true, completion: nil)
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}

extension AddNewBookMethodeViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension AddNewBookMethodeViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class AddNewBookMethodeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var isbnTextField: UITextField!
    
    //MARK: - Instance variable
    let addNewBookId = "addNewBook"
    var jsonResponse: [String:Any]!
    var isbn: String!
    var loadingIndicator: DGActivityIndicatorView!

    //MARK: - Application life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isEnabled = true
        isbnTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Button action
    
    @IBAction func didScannBarCodeButtonPressed(_ sender: UIButton) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        present(controller, animated: true, completion: nil)
    }

    @IBAction func didSearchButtonPressed(_ sender: UIButton) {
        if let isbn = isbnTextField.text, !isbn.isEmpty{
            loadingIndicator = getLoadingIndicator()
            self.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            GoogleBookApiManager.googleBook(isbn: isbn) { (jsonResponse) in
                self.loadingIndicator.stopAnimating()
                self.jsonResponse = jsonResponse
                self.isbn = isbn
                self.performSegue(withIdentifier: self.addNewBookId, sender: nil)
            }
        }
    }
    
    //MARK: Textfield methode
    
    func textFieldDidChange(_ textField: UITextField) {
        if (isbnTextField.text?.characters.count)! > 9{
             searchButton.isEnabled = true
        }
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addNewBookId {
            let vc = segue.destination as! AddNewBookViewController
            vc.bookInformation = jsonResponse
            vc.isbn = isbn
        }
        
    }
}
