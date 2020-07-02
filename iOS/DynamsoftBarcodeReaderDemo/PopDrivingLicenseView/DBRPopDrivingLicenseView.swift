//
//  DBRPopDrivingLicenseView.swift
//  AwesomeBarcode
//
//  Created by Dynamsoft on 2018/11/25.
//  Copyright © 2018 Dynamsoft. All rights reserved.
//

import UIKit

@objc protocol CompleteDelegate: NSObjectProtocol {
    func complete()
    func clickFinishBtn()
    @objc optional func clickRestartBtn()
}

class DBRPopDrivingLicenseView: UIView {

    var frontView:DBRDrivingLicenseView!
    var completeDelegate: CompleteDelegate?
    private let _viewBG = UIView()
    private var _bgRect = CGRect(x: 0, y: 0, width: FullScreenSize.width, height: FullScreenSize.height)
    private var isFirstHide = true
    
    // MARK: - init
    init(frame: CGRect,barcodeResults:BarcodeData) {
        super.init(frame: frame)
        initialFromXib(frame: frame,barcodeResult:barcodeResults)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialFromXib(frame: CGRect,barcodeResult:BarcodeData){
        
        self.backgroundColor = UIColor.clear
        self._viewBG.frame = _bgRect
        self._viewBG.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let tapViewBG  = UITapGestureRecognizer(target: self, action: #selector(onViewBG(aGes:)))
        let swipViewBG = UISwipeGestureRecognizer(target: self, action:#selector(onViewBG(aGes:)))
        let panViewBG  = UIPanGestureRecognizer(target: self, action: #selector(onViewBG(aGes:)))
        _viewBG.addGestureRecognizer(tapViewBG)
        _viewBG.addGestureRecognizer(swipViewBG)
        _viewBG.addGestureRecognizer(panViewBG)
        self.addSubview(_viewBG)
        frontView = DBRDrivingLicenseView(frame: frame,barcodeResult: barcodeResult)
        self.addSubview(frontView)
        frontView.footView.continueBtn.addTarget(self, action: #selector(onViewBG(aGes:)), for: .touchUpInside)
    }
    
    // MARK: - Gesture
    
    @objc func onViewBG(aGes:Any){
        hide(animate: false)
    }
    
    open func show(animate:Bool){
        KeyWindow?.addSubview(self)
        if(animate){
            self.frontView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.2,animations: { [unowned self] in
                self.frontView.alpha = 1
                self.frontView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                },completion: nil)
        }
    }
    
    open func hide(animate:Bool){
        if(isFirstHide)
        {
            isFirstHide = false
            UIView.animate(withDuration: 0.2,animations: { [unowned self] in
                self.frontView.alpha = 0
                if animate == true {
                    self.frontView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }
                },completion: { [unowned self] _ in
                    self.removeFromSuperview()
                    self.completeDelegate?.complete()
            })
        }
    }
}
