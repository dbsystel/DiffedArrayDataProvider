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

import Foundation
import Sourcing
import HeckelDiff

/// A wrapper around any type which implements `ArrayDataProviding`. When the underlying array of the type changes `DiffedArrayDataProvider` calculated a diff to get animated insertions, updates, moves and deletes. The element of the underlying DataProvider must implement `Hashable`.
public final class DiffedArrayDataProvider<Element>: ArrayDataProviding where Element: Hashable {
    private let backingDataProvider: AnyArrayDataProvider<Element>
    
    private var previousContents: [[Element]]
    
    public var contents: [[Element]] {
        return backingDataProvider.contents
    }
    
    /**
     Closure which gets called, when data inside the provider changes and those changes should be propagated to the datasource.
     
     - warning: Only set this when you are updating the datasource by your own.
     */
    public var whenDataProviderChanged: ProcessUpdatesCallback<Element>? {
        didSet {
            backingDataProvider.whenDataProviderChanged = { [weak self] updates in
                self?.executeWhenDataProviderChanged(updates: updates)
            }
        }
    }
    
    private func executeWhenDataProviderChanged(updates: [DataProviderUpdate<Element>]?) {
        defer {
             previousContents = contents
        }
        guard let previousContent = previousContents.first, let actualContent = backingDataProvider.contents.first else {
            DispatchQueue.main.async {
                self.whenDataProviderChanged?(updates)
            }
            return
        }
        let update = ListUpdate(diff(previousContent, actualContent), 0)
        let updates = dataProviderUpdates(for: update)
        DispatchQueue.main.async {
            self.whenDataProviderChanged?(updates.deletions + updates.insertions + updates.moves)
            self.whenDataProviderChanged?(updates.updates)
        }
    }
    
    private func dataProviderUpdates(for update: ListUpdate) -> DataProviderUpdates<Element> {
        let updates = update.updates.map { DataProviderUpdate<Element>.update($0, object(at: $0)) }
        let deletions = update.deletions.map { DataProviderUpdate<Element>.delete($0) }
        let insertions = update.insertions.map { DataProviderUpdate<Element>.insert($0) }
        let moves = update.moves.map { DataProviderUpdate<Element>.move($0.from, $0.to) }
        
        return DataProviderUpdates(insertions: insertions, deletions: deletions, moves: moves, updates: updates)
    }
    
    public var sectionIndexTitles: [String]? {
        return backingDataProvider.sectionIndexTitles
    }
    
    public var headerTitles: [String]? {
        return backingDataProvider.headerTitles
    }
    
    /// Wraps a `ArrayDataProviding` to calculate a diff when the dataprovider changes,
    ///
    /// - Parameter dataProvider: the dataprovider to wrap
    public init<DataProvider: ArrayDataProviding>(dataProvider: DataProvider) where DataProvider.Element == Element {
        self.backingDataProvider = AnyArrayDataProvider(dataProvider)
        self.previousContents = dataProvider.contents
    }
}
