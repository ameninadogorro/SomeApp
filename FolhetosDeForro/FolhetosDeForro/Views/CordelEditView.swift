//
//  CordelEditView.swift
//  FolhetosDeForro
//
//  Created by Ana Guimarães on 23/05/24.
//

import SwiftUI
struct CordelEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var cordel: Cordel
    
    @State private var titulo: String
    @State private var autor: String
    @State private var genero: String
    // Adicione mais propriedades de estado para os outros detalhes do cordel, se necessário
    
    init(cordel: Cordel) {
        self.cordel = cordel
        // Inicialize as propriedades de estado com os valores atuais do cordel
        _titulo = State(initialValue: cordel.titulo ?? "")
        _autor = State(initialValue: cordel.autor ?? "")
        _genero = State(initialValue: cordel.genero ?? "")
        // Inicialize mais propriedades de estado conforme necessário
    }
    
    var body: some View {
        Form {
            TextField("Título", text: $titulo)
            TextField("Autor", text: $autor)
            TextField("Gênero", text: $genero)
            // Adicione mais campos de entrada conforme necessário
            
            Button("Salvar") {
                // Atualize as propriedades do cordel com os novos valores
                cordel.titulo = titulo
                cordel.autor = autor
                cordel.genero = genero
                // Atualize mais propriedades do cordel conforme necessário
                
                // Salve as alterações no contexto do CoreData
                do {
                    try viewContext.save()
                    // Feche a tela de edição após salvar as alterações
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    // Trate erros de salvamento, se necessário
                    print("Erro ao salvar: \(error.localizedDescription)")
                }
            }
        }
        .navigationTitle("Editar Cordel")
    }
}
