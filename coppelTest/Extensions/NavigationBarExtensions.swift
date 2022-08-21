//
//  NavigationBarExtensions.swift
//  coppelTest
//
//  Created by Tony on 8/20/22.
//

import Foundation
import UIKit

extension UINavigationBar
{
    var largeTitleHeight: CGFloat {
        let maxSize = self.subviews
            .filter { $0.frame.origin.y > 0 }
            .max { $0.frame.origin.y < $1.frame.origin.y }
            .map { $0.frame.size }
        return maxSize?.height ?? 0
    }
}
