//
//  CordelDetailView.swift
//  FolhetosDeForro
//
//  Created by Ana Guimarães on 23/05/24.
//
import SwiftUI

struct CordelDetailView: View {
    let cordel: Cordel
    @State private var isEditing = false
    var body: some View {
        VStack {
            Button(action: {
                      isEditing = true
                  }) {
                      Text("Editar")
                  }
                  .sheet(isPresented: $isEditing) {
                      CordelEditView(cordel: cordel)
                  }
            if let imageData = cordel.capa, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            Text(cordel.titulo ?? "Título Desconhecido")
                .font(.title)
            Text("Autor: \(cordel.autor ?? "Autor Desconhecido")")
            Text("Gênero: \(cordel.genero ?? "Gênero Desconhecido")")
            Text("Publicado em: \(formattedDate)")
            Text("Lido: \(cordel.lido ? "Sim" : "Não")")
            Text("Progresso: \(cordel.progresso, specifier: "%.0f")%")
            Text("Notas: \(cordel.notas ?? "-")")
        }
        .padding()
        .navigationTitle(cordel.titulo ?? "Cordel")
    }

    var formattedDate: String {
        if let dataDePublicacao = cordel.dataDePublicacao {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: dataDePublicacao)
        } else {
            return "Data Desconhecida"
        }
    }
}
