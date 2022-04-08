//
//  ListarProfessoresTableViewController.swift
//  ProfessoresAPI
//
//  Created by user216592 on 4/4/22.
//

import UIKit

class ListarProfessoresTableViewController: UITableViewController {
    
    var professores : [ProfessorModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Professores")
        
        if let url = URL(string: "https://cors.grandeporte.com.br/cursos.grandeporte.com.br:8080/professores"){
            
            let tarefa = URLSession.shared.dataTask(with: url){
                (dados, requisicao, erro) in
                                           
                    if erro == nil{
                        print("Dados capturados da API com sucesso")
                        //print(dados)
                        
                        let jDecoder = JSONDecoder()
                        
                        if let dadosRetornados = dados{
                            do {
                                self.professores  = try jDecoder.decode([ProfessorModel].self, from: dadosRetornados)
                                //print(self.professores)
                                self.tableView.reloadData()
                            }
                            catch {
                                print("Erro ao converter Professor Model")
                            }
                        }
                    }else{
                        print("Erro ao consultar a API")
                    }
            }
            tarefa.resume()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = self.professores[indexPath.row].nome
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // pegar o id (API) que queremos deletar
            let id = professores[indexPath.row].id!
            // montar a URL que devemos fazer a requisicao
            let urlStr = "https://cors.grandeporte.com.br/cursos.grandeporte.com.br:8080/professores/\(id)"
            let url = URL(string :urlStr)!
            
            
            var requisicao = URLRequest(url: url)
            requisicao.httpMethod = "DELETE"
            
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // criar tarefa assincrona que permite fazer a requisicao a API
            let tarefa = URLSession.shared.dataTask(with: requisicao){ (dados, resposta, erro) in
                //senao houver erros, removemos o profesor do array e depois da tabela (tela)
                if (erro == nil){
                    print("Professor removido com sucesso")
                    self.professores.remove(at: indexPath.row)
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else{
                    print("Erro ao remover o professor")
                }
                
            }
            tarefa.resume()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pegando o professor que gostariamos de alterar
        let professorAlterado = professores[indexPath.row]
        
        performSegue(withIdentifier: "professorCrudSegue", sender: professorAlterado)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "professorCrudSegue" ){
            
            let controller = segue.destination as! ViewController
            
            // Somente no caso de edicao
            if let p = sender as? ProfessorModel{
                controller.professorAlterado = p
            }
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
