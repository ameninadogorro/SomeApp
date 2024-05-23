//
//  CordelListView.swift
//  FolhetosDeForro
//
//  Created by Ana Guimarães on 23/05/24.
//

import SwiftUI
import CoreData

struct CordelListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Cordel.dataDePublicacao, ascending: true)],
        animation: .default)
    private var cordels: FetchedResults<Cordel>

    var body: some View {
        NavigationView {
            List {
                ForEach(cordels) { cordel in
                    NavigationLink(destination: CordelDetailView(cordel: cordel)) {
                        Text(cordel.titulo ?? "Sem Título")
                    }
                    .contextMenu {
                        Button("Editar") {
                            showEditCordelView(cordel: cordel)
                        }
                        Button("Excluir", role: .destructive) {
                            deleteCordel(cordel: cordel)
                        }
                    }
                }
                .onDelete(perform: deleteCordels)
            }
            .navigationTitle("Cordéis")
            .navigationBarItems(trailing: NavigationLink("Adicionar", destination: CordelFormView()))
        }
    }

    private func deleteCordels(offsets: IndexSet) {
        withAnimation {
            offsets.map { cordels[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Erro não resolvido \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteCordel(cordel: Cordel) {
        viewContext.delete(cordel)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erro não resolvido \(nsError), \(nsError.userInfo)")
        }
    }

    private func showEditCordelView(cordel: Cordel) {
        _ = CordelFormView(cordel: cordel)
        // Apresenta a view de edição
    }
}
