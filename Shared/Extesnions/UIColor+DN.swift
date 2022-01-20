//
// Created by Apps AS on 09/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    enum ColorType {
        case light, dark
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized = String(hexSanitized[(hex.index(hex.startIndex, offsetBy: 1))...])
        }
        
        var rgb : UInt64 = 0
        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = 1.0
        
        
        if hexSanitized.count < 6 {
            let padding = Array<Character>(repeating: "0", count: 6 - hexSanitized.count)
            hexSanitized.append(contentsOf: padding)
        }
        
        let length = hexSanitized.count
        let sequenceFound = Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        assert(sequenceFound)
        assert(length == 6 || length == 8)
        
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        }
        
        if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    /// Provides hex string of the color.
    var hexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = .zero
        var g: CGFloat = .zero
        var b: CGFloat = .zero
        var alpha: CGFloat = .zero
        
        self.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        
        return (r, g, b, alpha)
    }
    
    var colorType: ColorType {
        let components = self.colorComponents
        
        let brightness = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000
        
        if brightness < 0.5 {
            return .dark
        }else {
            return .light
        }
    }
    
    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        func lerp(from a: CGFloat, to b: CGFloat, fraction: CGFloat) -> CGFloat {
            return (fraction * b) + ((1 - fraction) * a)
        }
        
        let fromComponents = self.colorComponents
        let toComponents = color.colorComponents
        
        let newRed = lerp(from: fromComponents.red, to: toComponents.red, fraction: fraction)
        let newGreen = lerp(from: fromComponents.green, to: toComponents.green, fraction: fraction)
        let newBlue = lerp(from: fromComponents.blue, to: toComponents.blue, fraction: fraction)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1)
    }
}

extension UIKit.UIColor {
    
    class func grayish() -> UIColor {
        return UIColor(red: 183.0/255, green: 183.0/255, blue: 183.0/255, alpha: 1.0)
    }
    
    class func grayish2() -> UIColor {
        return UIColor(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 1.0)
    }
    
    class func deepOrange() -> UIColor {
        return UIColor(red: 224.0/255, green: 73.0/255, blue: 0, alpha: 1.0)
    }
    
    class func tomato() -> UIColor {
        return UIColor(red: 230.0/255, green: 37.0/255, blue: 36.0/255, alpha: 1.0)
    }
    
    class func investorTimeStamp() -> UIColor {
        return UIColor(red: 222.0/255, green: 74.0/255, blue: 20.0/255, alpha: 1.0)
    }
    
    class func investorGray() -> UIColor {
        return UIColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1.0)
    }
    
    class func stockRed() -> UIColor {
        return UIColor(red: 239.0/255, green: 65.0/255, blue: 48.0/255, alpha: 1.0)
    }
    
    class func stockDivider() ->UIColor {
        return UIColor(red: 53.0/255, green: 53.0/255, blue: 53.0/255, alpha: 1.0)
    }
    
    class func stockLabel() ->UIColor {
        return UIColor(red: 115.0/255, green: 115.0/255, blue: 115.0/255, alpha: 1.0)
    }
    
    class func sunflowerYellow() -> UIColor {
        return UIColor(red: 255.0/255, green: 218.0/255, blue: 0, alpha: 1.0)
    }
    
    class func depressionColor() -> UIColor {
        return UIColor(red: 52.0/255, green: 52.0/255, blue: 52.0/255, alpha: 1.0)
    }
    
    class func gradientBackgroundTopColor() -> UIColor {
        return UIColor(red: 31.0/255, green: 109.0/255, blue: 172.0/255, alpha: 1.0)
    }
    
    class func gradientBackgroundMiddleColor() -> UIColor {
        return UIColor(red: 0, green: 117.0/255, blue: 202.0/255, alpha: 1.0)
    }
    
    class func gradientBackgroundBottomColor() -> UIColor {
        return UIColor(red: 15.0/255, green: 140.0/255, blue: 211.0/255, alpha: 1.0)
    }
    
    class func picturePlaceholderColor() -> UIColor {
        return UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
    }
    
    class func stockColor() ->UIColor {
        return UIColor(red: 34.0/255, green: 34.0/255, blue: 34.0/255, alpha: 1.0)
    }
    
    class func grassyGreen() ->UIColor {
        return UIColor(red: 64.0/255, green: 167.0/255, blue: 0.0/255, alpha: 1.0)
    }
    
    class func topSectionGray() ->UIColor {
        return UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0)
    }
    
    class func stockGray() ->UIColor {
        return UIColor(red: 115.0/255, green: 115.0/255, blue: 115.0/255, alpha: 1.0)
    }
    
    class func commercialHeaderGray() ->UIColor {
        return UIColor(red: 47.0/255, green: 47.0/255, blue: 47.0/255, alpha: 1.0)
    }
    
    class func commercialBackgroundGray() ->UIColor {
        return UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1.0)
    }
    
    class func black50Percent() ->UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    class func black1Percent() ->UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    class func tomato1Percent() -> UIColor {
        return UIColor(red: 230.0/255, green: 37.0/255, blue: 36.0/255, alpha: 0.0)
    }
    
    class func tabItemUnselectedColor() ->UIColor {
        return UIColor(red: 147/255, green: 186/255, blue: 225/255, alpha: 1.0)
    }
    
    class func black30Percent() ->UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    class func grouppedTableViewBackground() -> UIColor {
        return UIColor(red: 247.0/255, green: 247.0/255, blue: 247.0/255, alpha: 1.0)
    }
    
    class func grouppedTableViewGroupHeaderColor() -> UIColor {
        return UIColor(red: 172.0/255, green: 172.0/255, blue: 172.0/255, alpha: 1.0)
    }
    
    class func grouppedTableViewSeparatorColor() -> UIColor {
        return UIColor(red: 234.0/255, green: 234.0/255, blue: 234.0/255, alpha: 1.0)
    }
    
    class func memberPriceBackgroundColor() -> UIColor {
        return UIColor(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)
    }
    
    class func ordinaryPriceBackgroundColor() -> UIColor {
        return UIColor(red: 212.0/255, green: 212.0/255, blue: 212.0/255, alpha: 1.0)
    }
    
    class func fordelButtonBackgroundColor() -> UIColor {
        return UIColor(red: 128.0/255, green: 183.0/255, blue: 213.0/255, alpha: 1.0)
    }
    
    class func fordelValidTilBackgroundColor() -> UIColor {
        return UIColor(red: 70.0/255, green: 191.0/255, blue: 0.0, alpha: 1.0)
    }
    
    class func wineGreenColor() -> UIColor {
        return UIColor(red: 0.0, green: 162.0/255, blue: 87.0/255, alpha: 1.0)
    }
    
    class func recipeGreenColor() -> UIColor {
        return UIColor(red: 91.0/255, green: 163.0/255, blue: 92.0/255, alpha: 1.0)
    }
    
    //MARK: - Mobile Lift Color 2020
    class func dnPrimaryColor() -> UIColor {
        return UIColor.white
    }
    
    class func whiteNavBarItemTintColor() -> UIColor {
        return UIColor(red: 47.0 / 255, green: 47.0 / 255, blue: 47.0 / 255, alpha: 1.0)
    }
    
    
    
    class func primaryColor() -> UIColor {
        return UIColor.white
    }
    
    class func adBackgroundColor() -> UIColor {
        return UIColor(hex: "#DED7CE")
    }
    
    class func feedBackgroundColor() -> UIColor {
        return UIColor(hex: "#F5F1EB")
    }
    
    class func confirmationGreenColor() -> UIColor {
        return UIColor(hex: "#27947A")
    }
    
    class func dropDownListBackgroundColor() -> UIColor {
        return UIColor(hex: "#FBF9F7")
    }
    
    class func breakingColor() -> UIColor {
        return UIColor(hex: "#870056")
    }
    
    class func shadesOfGrey01() -> UIColor {
        return UIColor(hex: "#F0F0F0")
    }
    
    class func shadesOfGrey02() -> UIColor {
        return UIColor(hex: "7B7B7B")
    }
    
    class func shadesOfGrey03() -> UIColor {
        return UIColor(hex: "#ABABAB")
    }
    
    class func shadesOfGrey04() -> UIColor {
        return UIColor(hex: "#A6A6A6")
    }
    
    class func shadesOfGrey05() -> UIColor {
        return UIColor(hex: "#A3A3A3")
    }
    
    class func shadesOfGrey06() -> UIColor {
        return UIColor(hex: "#828282")
    }
    
    class func shadesOfGrey07() -> UIColor {
        return UIColor(hex: "#6E6E6E")
    }
    
    class func shadesOfGrey08() -> UIColor {
        return UIColor(hex: "#565755")
    }
    
    class func shadesOfGrey09() -> UIColor {
        return UIColor(hex: "#2F2F2F")
    }
    
    class func shadesOfGrey10() -> UIColor {
        return UIColor(hex: "#7F7F7E")
    }
    
    class func shadesOfGrey11() -> UIColor {
        return UIColor(hex: "#8F8282")
    }
    
    class func shadesOfGrey12() -> UIColor {
        return UIColor(hex: "#4E3533")
    }
    
    class func shadesOfGrey13() -> UIColor {
        return UIColor(hex: "#575655")
    }
    
    class func shadesOfGrey14() -> UIColor {
        return UIColor(hex: "#343434")
    }
    
    class func separatorColor01() -> UIColor {
        return UIColor(hex: "#F2F2F2")
    }
    
    class func separatorColor02() -> UIColor {
        return UIColor(hex: "#F0F0F0")
    }
    
    class func shadesOfBlue01() -> UIColor {
        return UIColor(hex: "#E1F4FC")
    }
    
    class func shadesOfBlue02() -> UIColor {
        return UIColor(hex: "#EAF7FD")
    }
    
    class func shadesOfBlue03() -> UIColor {
        return UIColor(hex: "#B6DDF5")
    }
    
    class func shadesOfBlue04() -> UIColor {
        return UIColor(hex: "#008BD0")
    }
    
    class func shadesOfBlue05() -> UIColor {
        return UIColor(hex: "#5BABDA")
    }
    
    class func shadesOfBlue06() -> UIColor {
        return UIColor(hex: "#006295")
    }
    
    class func shadesOfBlue07() -> UIColor {
        return UIColor(hex: "#004F84") // notification page
    }
    
    class func shadesOfBlue08() -> UIColor {
        return UIColor(hex: "#00335A")
    }
    
    class func shadesOfOlive01() -> UIColor {
        return UIColor(hex: "#827A4F")
    }
    
    class func shadesOfRed01() -> UIColor{
        return UIColor(hex: "#BE3142")
    }
    
    class func shadesOfRed02() -> UIColor{
        return UIColor(hex: "#33111D")
    }
    
    class func shadesOfRed03() -> UIColor{
        return UIColor(hex: "#610E3D")
    }
    
    class func shadesOfGreen01() -> UIColor {
        return UIColor(hex: "#27947A")
    }
    
    class func lightEditionBackgroundColor() -> UIColor {
        return UIColor(hex: "#FFEB80")
    }
    
    class func lightSmakEditionBackgroundColor() -> UIColor {
        return UIColor(hex: "#F4EFEA")
    }
    
    class func smakBorderColor() -> UIColor {
        return UIColor(hex: "#DED2C8")
    }
    
    class func smakLightTextColor() -> UIColor {
        return UIColor(hex: "#FFFEFD")
    }
    
    class func samkFeedCellBacgroundColor() -> UIColor {
        return UIColor(hex: "#FFFCFB")
    }
    
    class func minSamkCarouselBacgroundColor() -> UIColor {
        return UIColor(hex: "#E5E5E5")
    }
    
    class func darkEditionBackgroundColor() -> UIColor {
        return UIColor(hex: "#953253")
    }
    
    class func loadingSpinnercolor() -> UIColor {
        return UIColor(hex: "#DDDBD7")
    }
    
    class func investorHeaderPlaceholderColor() -> UIColor{
        return UIColor(hex: "#323232")
    }
}
