//
//  Copyright (C) DB Systel GmbH.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import DiffedArrayDataProvider
import Sourcing

class DiffedArrayDataProviderTests: XCTestCase {
    
    var arrayDataProvider: ArrayDataProvider<Person>!
    var diffedArrayDataProvider: DiffedArrayDataProvider<Person>!
    
    override func setUp() {
        super.setUp()
        arrayDataProvider = ArrayDataProvider(rows: [Person(id: "1", age: 30), Person(id: "2", age: 32)])
        diffedArrayDataProvider = DiffedArrayDataProvider(dataProvider: arrayDataProvider)
    }
    
    func testInsertDelete() {
        //Prepare
        var captuerdUpdates: [DataProviderChange] = []
        _ = diffedArrayDataProvider.observable.addObserver { change in
            captuerdUpdates.append(change)
        }
        
        //When
        arrayDataProvider.reconfigure(with: [Person(id: "1", age: 30), Person(id: "3", age: 32)])
        
        //Then
        XCTAssertEqual(captuerdUpdates, [.changes([.delete(IndexPath(row: 1, section: 0)),
                                                   .insert(IndexPath(row: 1, section: 0))])])
    }
    
    func testUpdate() {
        //Prepare
        var captuerdUpdates: [DataProviderChange] = []
        _ = diffedArrayDataProvider.observable.addObserver { change in
            captuerdUpdates.append(change)
        }
        
        //When
        arrayDataProvider.reconfigure(with: [Person(id: "1", age: 30), Person(id: "2", age: 33)])
        
        //Then
        XCTAssertEqual(captuerdUpdates, [.changes([.update(IndexPath(row: 1, section: 0))])])
    }
    
    func testMove() {
        //Prepare
        var captuerdUpdates: [DataProviderChange] = []
        _ = diffedArrayDataProvider.observable.addObserver { change in
            captuerdUpdates.append(change)
        }
        
        //When
        arrayDataProvider.reconfigure(with: [Person(id: "2", age: 32), Person(id: "1", age: 30)])
        
        //Then
        XCTAssertEqual(captuerdUpdates, [.changes([.move(IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)),
                                                   .move(IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0))])])
    }
    
    func testUpdateViewUnrelatedChanges() {
        //Prepare
        var captuerdUpdates: [DataProviderChange] = []
        _ = diffedArrayDataProvider.observable.addObserver { change in
            captuerdUpdates.append(change)
        }

        //When
        arrayDataProvider.reconfigure(with: [Person(id: "1", age: 30), Person(id: "2", age: 33)], change: .viewUnrelatedChanges([]))

        //Then
        XCTAssertEqual(captuerdUpdates, [.viewUnrelatedChanges([])])
    }

}
