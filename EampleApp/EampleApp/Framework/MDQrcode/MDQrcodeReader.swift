//
//  MDQrcodeReader.swift
//
//  Created by midoks on 15/11/14.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import AVFoundation


public final class MDQrcodeReader: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var defaultDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    var frontDevice: AVCaptureDevice? = {
        for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
            if let _device = device as? AVCaptureDevice where _device.position == AVCaptureDevicePosition.Front {
                return _device
            }
        }
        return nil
    }()
    
    lazy var defaultDeviceInput: AVCaptureDeviceInput? = {
        return try? AVCaptureDeviceInput(device: self.defaultDevice)
    }()
    
    lazy var frontDeviceInput:AVCaptureDeviceInput? = {
        if let _frontDevice = self.frontDevice {
            return try? AVCaptureDeviceInput(device: _frontDevice)
        }
        return nil
    }()
    
    
    public lazy var previewLayer: AVCaptureVideoPreviewLayer = { return AVCaptureVideoPreviewLayer(session: self.session) }()
    public var completionBlock: ((String?) -> ())?

    var metadataOutput = AVCaptureMetadataOutput()
    var session       = AVCaptureSession()
    
    public let metadataObjectTypes: [String]
    
    public init(metadataObjectTypes types: [String]) {
        metadataObjectTypes = types
        super.init()
    
        configureDefaultComponents()
    }
    
    /// 初始化组件
    private func configureDefaultComponents() {
        session.addOutput(metadataOutput)
        
        if let _defaultDeviceInput = defaultDeviceInput {
            session.addInput(_defaultDeviceInput)
        }
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        metadataOutput.metadataObjectTypes = metadataObjectTypes
        previewLayer.videoGravity          = AVLayerVideoGravityResizeAspectFill
        
    }
    
    /// 开始扫描
    public func startScanning() {
        if !session.running {
            session.startRunning()
        }
    }
    
    /// 停止扫描
    public func stopScanning() {
        if session.running {
            session.stopRunning()
        }
    }
    
    //检测是二维码读取是否有效
    public class func isAvailable()->Bool{
        if AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio).count == 0 {
            return false
        }
        
        do {
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let _ = try AVCaptureDeviceInput(device: captureDevice)
            
            return true
        } catch _ {
            return false
        }
    }
    
    //安装
    public class func isCanRun(metadataTypes: [String]? = nil) -> Bool {
        
        if !isAvailable() {
            return false
        }
        
        //初始化组件
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let deviceInput   = try! AVCaptureDeviceInput(device: captureDevice)
        let output        = AVCaptureMetadataOutput()
        let session       = AVCaptureSession()
        
        session.addInput(deviceInput)
        session.addOutput(output)
        
        var metadataObjectTypes = metadataTypes
        
        if metadataObjectTypes == nil || metadataObjectTypes?.count == 0 {
            // 默认QRCode meta
            metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        
        for metadataObjectType in metadataObjectTypes! {
            if !output.availableMetadataObjectTypes.contains({ $0 as! String == metadataObjectType }) {
                return false
            }
        }
        
        return true
    }
    
    
    //MARK: - AVCaptureMetadataOutputObjectsDelegate -
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for current in metadataObjects {
            if let _readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
                if metadataObjectTypes.contains(_readableCodeObject.type) {
                    stopScanning()
                    
                    let scannedResult = _readableCodeObject.stringValue
                    
                    completionBlock?(scannedResult)
                }
            }
        }
    }
    
    
}
