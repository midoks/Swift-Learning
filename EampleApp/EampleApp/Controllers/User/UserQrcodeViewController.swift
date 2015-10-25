//
//  UserQrcodeViewController.swift
//
//  Created by midoks on 15/8/24.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import AVFoundation

class UserQrcodeViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "二维码识别"
        self.view.backgroundColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("close:"))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        NSLog("二维码识别")
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        //let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        //var error:NSError?
        //let input = AVCaptureDeviceInput().device.
        
//        if (error != nil) {
//            print("\(error?.localizedDescription)")
//            return
//        }
        
//    
//        captureSession = AVCaptureSession()
//        captureSession?.addInput(input as AVCaptureInput)
        
        setupCamera()
    }
    
    
    //安装相机
    func setupCamera(){
    
        
        
        
        
    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            //print("close")
        }
    }

}
