//
//  GsExtensionGit.swift
//  GitHubStar
//
//  Created by midoks on 16/4/4.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK: - GitHub Private Methods -
extension UIViewController{
    
    func gitTime(time:String) -> String {
        let vTime = time.components(separatedBy: "T")
        return vTime[0]
    }
    
    func gitTimeYmd(ctime:String) -> String{
        let utime = gitTime(time: ctime)
        return utime.replacingOccurrences(of: "-", with: "/")
    }
    
    func gitSize(s:Float, i: Int) -> String {
        let v = ["B","KB","MB","GB", "TB", "PB", "EB","ZB","YB","BB","NB","DB"]
        
        if s > 1024 {
            let ss = s/1024
            let ii = i + 1
            return gitSize(s: Float(ii), i: Int(ss))
            
        }
        return String(format: "%0.2f", s) + String(v[i])
    }
    
    func gitParseLink(urlLink:String) -> GitResponseLink{
        var r = GitResponseLink(nextPage: "", nextNum: 0, lastPage: "", lastNum: 0)
        
        let linkArr = urlLink.components(separatedBy: ",")
        
        
        let nextPageInfo = linkArr[0].trim()
        
        var urlArr = nextPageInfo.components(separatedBy: ";")
        //let pageUrl = urlArr[0].substring(1, end: arrLen-2)
    
        var pageUrl = urlArr[0].replacingOccurrences(of: "<>", with: "")
        var pageNumArr = pageUrl.components(separatedBy: "=")
        var pageNum = pageNumArr[pageNumArr.count - 1]
        
        r.nextPage = pageUrl
        r.nextNum = Int(pageNum)!
        
        if linkArr.count == 2 {
            
            let lastPageInfo = linkArr[1].trim()
            urlArr = lastPageInfo.components(separatedBy: ";")
            pageUrl = urlArr[0].replacingOccurrences(of: "<>", with: "")
            pageNumArr = pageUrl.components(separatedBy: "=")
            pageNum = pageNumArr[pageNumArr.count - 1]
            
            r.lastPage = pageUrl
            r.lastNum = Int(pageNum)!
        }
        
        return r
    }
    
    func gitJsonParse(data:NSData) -> JSON {
        let _data = String(data: data as Data, encoding: String.Encoding.utf8)!
        let _dataJson = JSON.parse(_data)
        return _dataJson
    }
    
    func gitNowBeforeTime(gitTime:String?) -> String {
        //print(gitTime)
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        dfmatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        let date = dfmatter.string(from: NSDate() as Date)
        let nowDateArr = date.components(separatedBy: " ")
        
        var gitTimeArr = gitTime!.components(separatedBy: "T")
        gitTimeArr[1] = gitTimeArr[1].components(separatedBy:"Z")[0]
        
        let nowDateArr1 = nowDateArr[0].components(separatedBy:"-")
        let gitTimeArr1 = gitTimeArr[0].components(separatedBy:"-")
        let nowDateArr2 = nowDateArr[1].components(separatedBy:":")
        let gitTimeArr2 = gitTimeArr[1].components(separatedBy:":")
        //print(nowDateArr1, gitTimeArr1, nowDateArr2, gitTimeArr2)
        
        var value = [Int]()
        value.append(Int(nowDateArr1[0])!-Int(gitTimeArr1[0])!)
        value.append(Int(nowDateArr1[1])!-Int(gitTimeArr1[1])!)
        value.append(Int(nowDateArr1[2])!-Int(gitTimeArr1[2])!)
        value.append(Int(nowDateArr2[0])!-Int(gitTimeArr2[0])!)
        value.append(Int(nowDateArr2[1])!-Int(gitTimeArr2[1])!)
        value.append(Int(nowDateArr2[2])!-Int(gitTimeArr2[2])!)
        if value[0] > 0 {
            return String(value[0]) + "年前"
        }
        
        if value[1] > 0 {
            
            if value[2] < 0 && value[1] == 1{
                return String(value[1]*30 + value[2]) + "天前"
            } else if value[2] < 0 {
                return String(value[1] - 1) + "天前"
            }
            return String(value[1]) + "月前"
        }
        
        if value[2] > 0 {
            if value[2] == 1 {
                if value[3] < 0 {
                    if value[4] < 0 {
                        return String(value[2]*24 + value[3] - 1) + "小时前"
                    } else {
                        return String(value[2]*24 + value[3]) + "小时前"
                    }
                }
                return "昨天"
            } else if value[2] > 2 {
                
                if value[3] < 0 || value[4] < 0 || value[5] < 0  {
                    return String(value[2]-1) + "天前"
                }
            }
            return String(value[2]) + "天前"
        }
        
        if value[3] > 0 {
            if value[4] < 0 && value[3] != 1 {
                return String(value[3] - 1) + "小时前"
            } else if value[4] < 0 && value[3] == 1 {
                return String(value[3]*60 + value[4]) + "分钟前"
            }
            
            return String(value[3]) + "小时前"
        }
        
        if value[4] > 0 {
            if value[5] < 0 && value[4] != 1 {
                return String(value[4] - 1) + "分钟前"
            } else if value[5]<0 && value[4] == 1 {
                return String(value[5] + value[4]*60) + "秒前"
            }
            return String(value[4]) + "分钟前"
        }
        
        if value[5] >= 0 {
            return String(value[5]) + "秒前"
        }
        return "--"
    }
    
    func gitDiffParse(commitData:String){
        
    }
}
