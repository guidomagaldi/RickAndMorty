//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 12/6/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
