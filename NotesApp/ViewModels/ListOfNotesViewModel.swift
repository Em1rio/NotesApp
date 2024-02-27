//
//  ListOfNotesViewModel.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 26.02.2024.
//

import Foundation

final class ListOfNotesViewModel {
    // MARK: - Variables
    private(set) var databaseManager: DBManagerProtocol
    
    // MARK: - Lifecycle
    init(_ databaseManager: DBManagerProtocol) {
        self.databaseManager = databaseManager
    }
    // MARK: - Actions
    func getAllNotes() -> [NoteModel] {
        return databaseManager.getAllNotes()
    }
    
    
    
    
}


