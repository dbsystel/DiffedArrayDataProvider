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
public final class DiffedArrayDataProvider<Content>: ArrayDataProviding where Content: Hashable {
    
    public typealias Element = Content
    
    private let backingDataProvider: AnyArrayDataProvider<Element>
    
    private var previousContent: [[Element]]
    
    public var content: [[Element]] {
        return backingDataProvider.content
    }
    
    public var observable: DataProviderObservable {
        return defaultObserver
    }
    
    private let defaultObserver = DefaultDataProviderObservable()
    
    private func executeWhenDataProviderChanged(change: DataProviderChange) {
        defer {
             previousContent = content
        }
        if case .unknown = change {
            guard let previousContent = previousContent.first, let actualContent = backingDataProvider.content.first else {
                self.defaultObserver.send(updates: change)
                return
            }
            let update = ListUpdate(diff(previousContent, actualContent), 0)
            let updates = dataProviderUpdates(for: update)
            let changes = updates.deletions + updates.insertions + updates.moves
            defaultObserver.send(updates: .changes(changes))
            defaultObserver.send(updates: .changes(updates.updates))
        } else {
            defaultObserver.send(updates: change)
        }
    }
    
    private func dataProviderUpdates(for update: ListUpdate) -> DataProviderUpdates {
        let updates = update.updates.map { DataProviderChange.Change.update($0) }
        let deletions = update.deletions.map { DataProviderChange.Change.delete($0) }
        let insertions = update.insertions.map { DataProviderChange.Change.insert($0) }
        let moves = update.moves.map { DataProviderChange.Change.move($0.from, $0.to) }
        
        return DataProviderUpdates(insertions: insertions, deletions: deletions, moves: moves, updates: updates)
    }
    
    private var observer: NSObjectProtocol!
    
    /// Wraps a `ArrayDataProviding` to calculate a diff when the dataprovider changes,
    ///
    /// - Parameter dataProvider: the dataprovider to wrap
    public init<DataProvider: ArrayDataProviding>(dataProvider: DataProvider) where DataProvider.Element == Element {
        self.backingDataProvider = AnyArrayDataProvider(dataProvider)
        self.previousContent = dataProvider.content
        observer = dataProvider.observable.addObserver(observer: { [weak self] update in
            self?.executeWhenDataProviderChanged(change: update)
        })
    }
    
    deinit {
        defaultObserver.removeObserver(observer: observer)
    }
}
