//
//  ViewController.swift
//  ProfessoresAPI
//
//  Created by user216592 on 4/4/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtNome: UITextField!
    
    var professorAlterado : ProfessorModel?
    
    @IBAction func buttonAdd(_ sender: Any) {
        
        // edicao
        if professorAlterado != nil{
            editar()
        }
        // salvar
        else{
            salvar()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // quando e edicao
        if let p = professorAlterado {
            txtNome.text = p.nome
            txtEmail.text = p.email
        }
    }
    
    func editar(){
        let url = URL(string :"https://cors.grandeporte.com.br/cursos.grandeporte.com.br:8080/professores/\(professorAlterado!.id!)")!
        print(url)
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PATCH"
        
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let professor = ProfessorModel()
        professor.nome = txtNome.text
        professor.email = txtEmail.text
        
        let encoder = JSONEncoder()
    
        // Conversao e atribuir JSON para o corpo da requisicao
        do {
            requisicao.httpBody = try encoder.encode(professor)
        }
        catch{
            print("Erro ao converter professor")
        }
        
        // criar a tarefa assincrona que vai fazer a requisicao
        
        let tarefa = URLSession.shared.dataTask(with: requisicao){ (dados, resposta, erro) in
            
            if (erro == nil){
                print("Professor editado com sucesso")
            }
            else{
                print("Erro ao editar o professor")
            }
            
        }
        tarefa.resume()
    }
    
    func salvar(){
        let url = URL(string :"https://cors.grandeporte.com.br/cursos.grandeporte.com.br:8080/professores")!
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let professor = ProfessorModel()
        professor.nome = txtNome.text
        professor.email = txtEmail.text
        
        let encoder = JSONEncoder()
    
        // Conversao e atribuir JSON para o corpo da requisicao
        do {
            requisicao.httpBody = try encoder.encode(professor)
        }
        catch{
            print("Erro ao converter professor")
        }
        
        // criar a tarefa assincrona que vai fazer a requisicao
        
        let tarefa = URLSession.shared.dataTask(with: requisicao){ (dados, resposta, erro) in
            
            if (erro == nil){
                print("Professor criado com sucesso")
            }
            else{
                print("Erro ao criar o professor")
            }
            
        }
        tarefa.resume()
    }


}
