//
//  ViewController.swift
//  Qr-Reader
//
//  Created by Victor Adrian Reyes on 31/07/18.
//  Copyright © 2018 Victor Adrian Reyes. All rights reserved.
//

import UIKit
import AVFoundation

class ScanerController:  UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    
   
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var viewCamara: UIView!
    @IBOutlet weak var btnNuevaCaptura: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReaderBarcode()

    }
 
    @IBAction func alClickNuevaCaptura(_ sender: UIButton) {
        ReaderBarcode();
    }
    
    func ReaderBarcode()
    {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr , .ean13 ,.ean8 ,.code128]
        } else {
            failed()
            return
        }
        
        qrCodeFrameView = UIView()
        

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.viewCamara.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.viewCamara.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        if  let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            self.viewCamara.addSubview(qrCodeFrameView)
            self.viewCamara.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    func failed() {
        
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            
            guard let stringValue = readableObject.stringValue else { return }
            
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            self.lblResultado.text  = self.lblResultado.text!+" "+stringValue
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
