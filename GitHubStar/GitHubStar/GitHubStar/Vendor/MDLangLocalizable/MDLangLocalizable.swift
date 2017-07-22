//
//  MDLangLocalizable.swift
//
//  Created by midoks on 16/2/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class MDLangLocalizable: NSObject {
    
    private static var instance:MDLangLocalizable?
    private let _userDefaults = UserDefaults.standard
    
    private var bundle:Bundle?
    
    private var table:String = ""
    
    private var debug = false
    
    //Mark: - 实例化 -
    static func singleton() -> MDLangLocalizable {
        if((instance == nil)){
            instance = MDLangLocalizable()
        }
        return instance!
    }
    
    deinit {
        _userDefaults.synchronize()
    }
    
    //是否开启调试模式
    func debug(d:Bool){
        self.debug = d
    }
    
    //初始化系统语言
    func initSysLang(){
        
        var ulang = _userDefaults.value(forKey: "userLanguage")
        
        if ulang == nil {
            
            let slangs = NSLocale.preferredLanguages
            _userDefaults.setValue(slangs[0], forKey: "userLanguage")
            ulang = slangs[0]
        
        }
        
//        print(NSLocale.preferredLanguages())
//        print(ulang)
        
        let ulangStr = ulang as! String
        let langFileName = self.getLangPosName(lang: ulangStr)

        let path = Bundle.main.path(forResource: langFileName, ofType: "lproj")
        self.bundle = Bundle(path: path!)
    }
    
    private func getLangPosName(lang:String) -> String {
        
        let langs = ["en", "zh-Hans"]
        
        for i in langs {
            if lang.hasPrefix(i) {
                return i
            }
        }
        return "en"
    }
    
    //设置取的文件的名字
    func setTable(_table:String){
        if self.debug {
            return
        }
        
        self.table = _table
    }
    
    
    //当前应用语言
    func currentLanguage() -> String {
        if self.debug {
            return "zh-Hans-CN"
        }
        
        return _userDefaults.value(forKey: "userLanguage") as! String
    }
    
    //设置应用语言
    func setCurrentLanguage(lang:String){
        if self.debug {
            return
        }
        
        _userDefaults.setValue(lang, forKey: "userLanguage")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        self.bundle = Bundle(path: path!)
    }
    
    //获取当前对应语言的值
    func stringWithKey(key:String) -> String {
        if self.debug {
            return key
        }
        
        let v = self.bundle?.localizedString(forKey: key, value: "", table: self.table)
        
        if v == nil {
            return key
        }
        
        return v!
    }
    
    
    
    
    

}
