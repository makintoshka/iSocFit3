//
//  AbilityProgressViewController.swift
//  iSocFit
//
//  Created by makintosh on 07.03.2021.
//

import UIKit
import Charts

class AbilityProgressViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
        
    private var _abilityKey: String = ""
    
    
    public var abilityKey: String{
        get {
            return _abilityKey
        }
        set {
            _abilityKey = newValue
        }
    }
    
    
    
    @IBOutlet var progressLineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAbilities()
        
        
        
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addValueAction))
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButton]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    //MARK: - API
    
    func getAbilities(){
        
        let manager = ServerManager.sharedManager
        
        manager.getAbilityValues(abilityKey: abilityKey) { [self] (abilityValues, error) in
            if (abilityValues != nil){
                
                var tmp: NSMutableArray = []
                
                for value in abilityValues! {
                    
                    let currentValue = value as! NSDictionary
                    let id = currentValue.object(forKey: "userStatsId")
                    let tmpValue = currentValue.object(forKey: "value")
                    let tmpDate = currentValue.object(forKey: "createdAt")
                    
                    let key = currentValue.object(forKey: "key")
                    let someValue = Ability(id: id as! String, key: key as! String, value: tmpValue as! Int, createdAt: tmpDate as! String)
                    
                    tmp.add(someValue)
                    
                    
                    print("\(someValue)")
                    
                    print("________________-")
                }
                print(tmp)
                UserModel.abilities[abilityKey] = tmp as? NSMutableArray
                tableView.reloadData()
                
                let dataToChart = UserModel.abilities[abilityKey] as! [Ability]
                
                var abilityChangeDate = [String]()
                var abilityValues = [Double]()
                
                dataToChart.forEach { (ability) in
                    abilityChangeDate.append(ability.createdAt)
                    abilityValues.append(Double(ability.value))
                }
                
                customizeChart(dataPoints: abilityChangeDate, values: abilityValues.map({ Double($0)
                    
                }))
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    //MARK: - Actions
    
    @objc func addValueAction(){
        
        let addValueVC = storyboard?.instantiateViewController(identifier: "addAbilityValueVC") as! AddAbilityValueController
        addValueVC.abilityKey = abilityKey
        self.navigationController?.pushViewController(addValueVC, animated: true)
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: true)
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.tableView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        }
        
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addValueAction))
        
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButton]
        
        let indexPaths = tableView.indexPathsForVisibleRows
        
        for indexPath in indexPaths! {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isEditing = editing
        }
        
    }

    //MARK: - Functions
    
    func dataToDictionary(values: [Double], changeDates: [String]) -> NSDictionary{
        
        let valuesWithDate = Dictionary(uniqueKeysWithValues: zip(values, changeDates))
        
        return valuesWithDate as NSDictionary
    }
    
    //MARK: - Chart
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(Int(i)), y: values[i])
          dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "blabla")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        progressLineChart.data = lineChartData
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return UserModel.abilities[abilityKey]?.count ?? 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentAbility = (UserModel.abilities[abilityKey]![indexPath.row]) as! Ability
        
        cell.textLabel?.text = "\(currentAbility.value)"
        cell.textLabel?.textColor = UIColor(red: 48/255.0, green: 49/255.0, blue: 118/255.0, alpha: 1.0)
        cell.detailTextLabel?.text = currentAbility.createdAt
        cell.detailTextLabel?.textColor = UIColor(red: 194/255.0, green: 197/255.0, blue: 213/255.0, alpha: 1.0)
        
        return cell
    }
    

    
}
