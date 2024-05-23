//
//  CordelFormView.swift
//  FolhetosDeForro
//
//  Created by Ana Guimarães on 23/05/24.
//
import SwiftUI
import PhotosUI

struct CordelFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titulo: String = ""
    @State private var autor: String = ""
    @State private var genero: String = ""
    @State private var dataDePublicacao: Date = Date()
    @State private var lido: Bool = false
    @State private var progresso: Double = 0
    @State private var notas: String = ""
    @State private var imagemCapa: UIImage? = nil
    @State private var avaliacao: Double = 0
    @State private var comentarios: String = ""
    
    @State private var isImagePickerPresented = false
    
    var cordel: Cordel?
    
    init(cordel: Cordel? = nil) {
        self.cordel = cordel
        _titulo = State(initialValue: cordel?.titulo ?? "")
        _autor = State(initialValue: cordel?.autor ?? "")
        _genero = State(initialValue: cordel?.genero ?? "")
        _dataDePublicacao = State(initialValue: cordel?.dataDePublicacao ?? Date())
        _lido = State(initialValue: cordel?.lido ?? false)
        _progresso = State(initialValue: cordel?.progresso ?? 0)
        _notas = State(initialValue: cordel?.notas ?? "")
        _imagemCapa = State(initialValue: cordel?.capa.flatMap { UIImage(data: $0) })
    }
    
    var body: some View {
        Form {
            Section(header: Text("Detalhes")) {
                TextField("Título", text: $titulo)
                TextField("Autor", text: $autor)
                TextField("Gênero", text: $genero)
                DatePicker("Data de Publicação", selection: $dataDePublicacao, displayedComponents: .date)
            }
            Section(header: Text("Capa")) {
                if let imagemCapa = imagemCapa {
                    Image(uiImage: imagemCapa)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                Button("Escolher Imagem") {
                    isImagePickerPresented = true
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $imagemCapa)
                }
            }
            Section(header: Text("Status de Leitura")) {
                Toggle(isOn: $lido) {
                    Text("Lido")
                }
                Slider(value: $progresso, in: 0...100, step: 1) {
                    Text("Progresso")
                }
                TextField("Notas", text: $notas)
            }
            Section(header: Text("Avaliação")) {
                Slider(value: $avaliacao, in: 0...5, step: 0.5) {
                    Text("Avaliação")
                }
                TextField("Comentários", text: $comentarios)
            }
            Section {
                Button("Salvar") {
                    saveCordel()
                }
            }
        }
        .navigationTitle(cordel == nil ? "Novo Cordel" : "Editar Cordel")
    }
    
    private func saveCordel() {
        withAnimation {
            if let cordel = cordel {
                // Editar cordel existente
                cordel.titulo = titulo
                cordel.autor = autor
                cordel.genero = genero
                cordel.dataDePublicacao = dataDePublicacao
                cordel.lido = lido
                cordel.progresso = progresso
                cordel.notas = notas
                if let imagemCapa = imagemCapa, let imageData = imagemCapa.jpegData(compressionQuality: 1.0) {
                    cordel.capa = imageData
                }
            } else {
                // Adicionar novo cordel
                let novoCordel = Cordel(context: viewContext)
                novoCordel.titulo = titulo
                novoCordel.autor = autor
                novoCordel.genero = genero
                novoCordel.dataDePublicacao = dataDePublicacao
                novoCordel.lido = lido
                novoCordel.progresso = progresso
                novoCordel.notas = notas
                if let imagemCapa = imagemCapa, let imageData = imagemCapa.jpegData(compressionQuality: 1.0) {
                    novoCordel.capa = imageData
                }
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Erro não resolvido \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
