//
//  SectionModel.swift
//  RxSwift App
//
//  Created by Hem Poudyal on 31.08.21.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header : String
    var items : [Food]
}

//RxData sources requires us to implment it with extension
extension SectionModel : SectionModelType {
    init(original: SectionModel, items: [Food]) {
        self = original
        self.items = items
    }
}
