

import Foundation

extension String {
    
    //MARK: Helper methods
    
    /**
    Returns the length of the string.
    
    :returns: Int length of the string.
    */
    
    var length: Int {
        return self.characters.count//count(self)
    }
    
    
    
    //MARK: - Linguistics
    
    /**
    Returns the langauge of a String
    
    NOTE: String has to be at least 4 characters, otherwise the method will return nil.
    
    :returns: String! Returns a string representing the langague of the string (e.g. en, fr, or und for undefined).
    */
    func detectLanguage() -> String? {
        if self.length > 4 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeLanguage], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
    Returns the script of a String
    
    :returns: String! returns a string representing the script of the String (e.g. Latn, Hans).
    */
    func detectScript() -> String? {
        if self.length > 1 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagSchemeScript], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeScript, tokenRange: nil, sentenceRange: nil)
        }
        return nil
    }
    
    /**
    Check the text direction of a given String.
    
    NOTE: String has to be at least 4 characters, otherwise the method will return false.
    
    :returns: Bool The Bool will return true if the string was writting in a right to left langague (e.g. Arabic, Hebrew)
    
    */
    var isRightToLeft : Bool {
        let language = self.detectLanguage()
        return (language == "ar" || language == "he")
    }
    
    
    //MARK: - Usablity & Social
    
    /**
    Check that a String is only made of white spaces, and new line characters.
    
    :returns: Bool
    */
    func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        return false
    }
    
    
    
    
    /**
    :returns: Base64 encoded string
    */
    func encodeToBase64Encoding() -> String {
        let utf8str = self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return utf8str.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    /**
    :returns: Decoded Base64 string
    */
    func decodeFromBase64Encoding() -> String {
        /*let base64data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return NSString(data: base64data!, encoding: NSUTF8StringEncoding)! as String*/
        /*let base64Decoded = NSData(base64EncodedString: self, options:   NSDataBase64DecodingOptions(rawValue: 0))
        .map({ NSString(data: $0, encoding: NSUTF8StringEncoding) })
        return base64Decoded as! String*/
        
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        
    }
    
    func contains (substring:String)->Bool{
        return self.range(of: substring) != nil
    }
    
    
    
    // MARK: Subscript Methods
    
    /*subscript (i: Int) -> String {
    //return String(Array(self)[i])
    return self[advance(self.startIndex, i)]
    }*/
    subscript (i: Int) -> Character {
        return self[self.startIndex]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        
        
        
//        return substring(
//            with: Range(startIndex.advancedBy( r.lowerBound) ..< endIndex.advancedBy( r.upperBound))
//        )
        
        return ""
    }
    
    subscript (range: NSRange) -> String {
        let end = range.location + range.length
        return self[Range(range.length ..< end)]
        //return self[Range(start: range.location, end: end)]
    }
    
//    subscript (substring: String) -> Range<String.Index>? {
//        return self.rangeOfString(substring, options: NSString.CompareOptions.LiteralSearch, range: Range(startIndex ..< endIndex), locale: NSLocale.currentLocale())
//    }
    
    func substring(begin:Int, end:Int)->String {
        return ""
        //return self.substring(with: Range(startIndex.advancedBy(begin) ..< startIndex.advancedBy(end)))
    }
    
    func stringByDecodingURLFormat() ->String {
        return self.replacingOccurrences(of: "+", with: "")
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func trim() ->String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func indexOf(toFind:String)->Int{
        
        if self.range(of: toFind) != nil {
            return -1
            //return  self.startIndex.distanceTo( range.lowerBound)
        } else {
            return -1
        }
    }
    
    func contains3PlusandOnlyChars( char:String)-> Bool{
        return self.length >= 3
            && self.indexOf(toFind: char) == 0
            && self.replacingOccurrences(of: char, with: "").length == 0
    }
    
    func replaceAll(target:String, toStr: String)->String{
        return self.replacingOccurrences(of: target, with: toStr)
    }
}
