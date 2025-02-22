import UIKit
import DGCharts  // Changed from Charts to DGCharts

class ViewController: UIViewController, UIDocumentPickerDelegate {
    
    private var csvData: String?
    private var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectFileButton()
        setupChartView()
    }
    
    private func setupSelectFileButton() {
        let selectButton = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
        selectButton.setTitle("Select CSV File", for: .normal)
        selectButton.backgroundColor = .systemBlue
        selectButton.addTarget(self, action: #selector(selectCSVFile), for: .touchUpInside)
        view.addSubview(selectButton)
    }
    
    private func setupChartView() {
        barChartView = BarChartView(frame: CGRect(x: 0,
                                                 y: 170,
                                                 width: view.frame.width,
                                                 height: view.frame.height - 200))
        barChartView.noDataText = "Select a CSV file to display sales data"
        view.addSubview(barChartView)
    }
    
    @objc private func selectCSVFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.comma-separated-values-text"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    // UIDocumentPickerDelegate method
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else { return }
        
        do {
            csvData = try String(contentsOf: selectedFileUrl, encoding: .utf8)
            print("CSV file loaded successfully")
            // Process your CSV data here
            processCSVData()
        } catch {
            print("Error loading CSV file: \(error.localizedDescription)")
        }
    }
    
    private func processCSVData() {
        guard let csvData = csvData else { return }
        
        let rows = csvData.components(separatedBy: .newlines)
                         .filter { !$0.isEmpty }
        
        guard rows.count > 1 else { return }
        
        var entries: [BarChartDataEntry] = []
        
        for (index, row) in rows.dropFirst().enumerated() {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2, let salesValue = Double(columns[1]) {
                let entry = BarChartDataEntry(x: Double(index), y: salesValue)
                entries.append(entry)
            }
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "Sales")
        dataSet.setColor(.systemBlue)
        dataSet.valueTextColor = .black
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let chartData = BarChartData(dataSet: dataSet)
            self.barChartView.data = chartData
            
            self.barChartView.xAxis.labelPosition = .bottom
            self.barChartView.xAxis.setLabelCount(entries.count, force: false)
            self.barChartView.animate(xAxisDuration: 1.0)
            
            if rows.count > 1 {
                let dateLabels = rows.dropFirst().map { $0.components(separatedBy: ",")[0] }
                self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateLabels)
            }
        }
    }
}