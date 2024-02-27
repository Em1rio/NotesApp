//
//  NoteModel.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 26.02.2024.
//

import Foundation
import RealmSwift

final class NoteModel: Object {
    @Persisted var id: String
    @Persisted var title: String
    @Persisted var note: String
}
