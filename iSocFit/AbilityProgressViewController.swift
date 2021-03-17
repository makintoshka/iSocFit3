//
//  AbilityProgressViewController.swift
//  iSocFit
//
//  Created by makintosh on 07.03.2021.
//

import UIKit
import Charts

var abilityChangeDate = ["20.01.2021", "21.01.2021", "22.01.2021", "23.01.2021", "24.01.2021", "25.01.2021"]
var abilityValues = [55.5, 56.7, 57.8, 59.0, 60.5, 63.5]

class AbilityProgressViewController: UITableViewController {
        
    @IBOutlet var progressLineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        customizeChart(dataPoints: abilityChangeDate, values: abilityValues.map({ Double($0)
            
        }))
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
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
        
        return abilityChangeDate.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(abilityValues[indexPath.row])
        cell.textLabel?.textColor = UIColor(red: 48/255.0, green: 49/255.0, blue: 118/255.0, alpha: 1.0)
        cell.detailTextLabel?.text = abilityChangeDate[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor(red: 194/255.0, green: 197/255.0, blue: 213/255.0, alpha: 1.0)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
