//
//  UIColor+Entities.swift
//  EcoRescue
//
//  Created by Christoph Erl on 12.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

extension UIColor {
    
    fileprivate struct Cache {
        
        static var defibrillator        = UIColor.colorDarkGreen
        static var emergency            = UIColor.negativ
        static var hospital             = UIColor.colorCarrot
        static var firehouse            = UIColor.colorPuple
        static var doctor               = UIColor.colorCarrot
        static var dentist              = UIColor.colorCarrot
        static var pharmacy             = UIColor.colorCarrot
        
        static var active               = UIColor.cGreen
        static var inactive             = UIColor.cRed
        
        static var colorPrimaryBlue   = UIColor(rgb: 0x314188)
        static var colorPrimaryRedV2    = UIColor(rgb: 0xFF4344)
        static var colorSecondaryGrayV2 = UIColor(rgb: 0x9B9B9B)
        static var colorBackground1V2   = UIColor(rgb: 0xF4F4F4)
        static var colorBackground2V2   = UIColor.white
        static var colorLightPrimaryBlueV2 = UIColor(rgb: 0x717CAC)
        static var colorButtonHoverV2 = UIColor(rgb: 0x475CB7)
        static var colorIntroButtonHoverV2 = UIColor(rgb: 0xE9E9E9)
        static var colorProgressBarV2  = UIColor(rgb: 0x7F8FBD)
        static var colorProgressBarBackgroundV2  = UIColor(rgb: 0xE5E9F3)
        static var colorIntroProgressBarV2  = UIColor(rgb: 0xB3BAD6)
        static var colorIntroProgressBarBackgroundV2 = UIColor(rgb: 0x6271AC)
        
        static var colorPrimaryTextV2 = UIColor.black
    }
    
    //// Colors
    public static var defibrillator:    UIColor { return Cache.defibrillator    }
    public static var emergency:        UIColor { return Cache.emergency        }
    public static var hospital:         UIColor { return Cache.hospital         }
    public static var firehouse:        UIColor { return Cache.firehouse        }
    public static var doctor:           UIColor { return Cache.doctor           }
    public static var dentist:          UIColor { return Cache.dentist          }
    public static var pharmacy:         UIColor { return Cache.pharmacy         }
    
    public static var active:           UIColor { return Cache.active           }
    public static var inactive:         UIColor { return Cache.inactive         }
    
    public static var colorPrimaryBlue:    UIColor { return Cache.colorPrimaryBlue }
    public static var colorPrimaryRedV2:     UIColor { return Cache.colorPrimaryRedV2 }
    public static var colorSecondaryGrayV2:  UIColor { return Cache.colorSecondaryGrayV2 }
    public static var colorBackground1V2:    UIColor { return Cache.colorBackground1V2 }
    public static var colorBackground2V2:    UIColor { return Cache.colorBackground2V2 }
    public static var colorLightPrimaryBlueV2:    UIColor { return Cache.colorLightPrimaryBlueV2 }
    public static var colorButtonHoverV2:    UIColor { return Cache.colorButtonHoverV2 }
    public static var colorIntroButtonHoverV2:    UIColor { return Cache.colorIntroButtonHoverV2 }
    public static var colorPrimaryTextV2: UIColor { return Cache.colorPrimaryTextV2 }
    public static var colorProgressBarV2: UIColor { return Cache.colorProgressBarV2 }
    public static var colorProgressBarBackgroundV2: UIColor { return Cache.colorProgressBarBackgroundV2 }
    public static var colorIntroProgressBarV2: UIColor { return Cache.colorIntroProgressBarV2 }
    public static var colorIntroProgressBarBackgroundV2: UIColor { return Cache.colorIntroProgressBarBackgroundV2 }
    
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        self.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
