//
//  MDQrcodeReaderViewController.swift
//
//  Created by midoks on 15/11/14.
//  Copyright © 2015年 midoks. All rights reserved.
//


import UIKit
import AVFoundation


class MDQrcodeReaderViewViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    lazy var rdQrcode : MDQrcodeReader = {
        return MDQrcodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    }()
    
    deinit {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        rdQrcode.stopScanning()
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("close:")))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        if MDQrcodeReader.isCanRun() {
            self.modalPresentationStyle = .formSheet
        
            /// print(view.frame.size)
            /// print(self.view.bounds)
            rdQrcode.previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            rdQrcode.startScanning()
            
            self.view.layer.insertSublayer(rdQrcode.previewLayer, at: 0)
            
            
            rdQrcode.completionBlock = { (result: String?) in

                let alert = UIAlertController(title: "识别成功", message: result, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
            
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    

    //关闭
    func close(button: UIButton){
        self.dismiss(animated: true) { () -> Void in
            print("close")
        }
    }
    
    
    
    
    
}
