//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR",
                         "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$",
                           "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var selectedIndex = -1
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        print(currencyArray[selectedIndex])
        finalURL = baseURL + currencyArray[selectedIndex]
        print(finalURL)
        self.getBitcoinData(url: finalURL)
    }

    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got Bitcoin data")
                    let bitcoinJSON = response.value as! Dictionary<String, Any>
                    self.updateWeatherData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    func updateWeatherData(json : Dictionary<String, Any>) {
        let model = BitcoinDataModel(json)
        print("price: " + String(model.bidPrice!))
        self.updateUIWithBitcoinData(val: model.bidPrice)
    }
    
    func updateUIWithBitcoinData(val: Double?) {
        var price = ""
        if let priceVal = val {
            price = currencySymbols[self.selectedIndex] + String(priceVal)
        } else {
            price = "Unavailable"
        }
        
        self.bitcoinPriceLabel.text = price
    }
}

