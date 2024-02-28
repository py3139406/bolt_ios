//
//  RcReportsMapViewController.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GoogleMaps
import DefaultsKit

class CoordinatesCollection : NSObject {

    var path:GMSPath!
    var target:UInt

    init(path: GMSPath) {
        self.path = path
        target = 0
        super.init()
    }

    func next() -> CLLocationCoordinate2D {
        target += 1
        if target == path.count() {
            target = 0
        }
        return path.coordinate(at:target)
    }

}

class ReportMapsViewController: UIViewController, GMSMapViewDelegate {

    var reportMapView:ReportMapView?
    var markerType:Int = 0
    var reportType:Int!
    var summaryReportData: SummaryReportModelData!
    var tripsReportData: TripsReportModelData!
    var stopsReportData: StopsReportModelData!
    var markerImages : [MarkerFirebaseModel] = []

    var endMarker:GMSMarker!
    var startmarker:GMSMarker!
    var coordinateArray:[CLLocationCoordinate2D] = []
    var locationArray:[CLLocation] = []
    var replaySpeed:Double = 1


    var StopsLocationArray: [CLLocation] = []
    var StopsCoordinateArray:[CLLocationCoordinate2D] = []
    var idleTimeDifferenceArray:[Int] = []
    var idleIntervalArray:[String] = []
    var stopMarkerArray:[GMSMarker] = []
    var directionMarkerArray:[GMSMarker] = []
    var directionCounter:Int = 0
    var pathMarker: GMSMarker!
    var animateIndex: Int = 0
    var completePath:[ReportPathModelData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults().set(true,for: Key<Bool>("should_clear_map"))
        completePath.removeAll()
        addContainer()
        addConstraints()
        setUpMap()
        if reportType == 0 {
            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
            reportMapView?.speedsMeterView.alpha = 0.5
            reportMapView?.upperView.isUserInteractionEnabled = false
            reportMapView?.upperView.alpha = 0.5
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        updateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addContainer() -> Void{
        reportMapView = view.createAndAddSubView(view:"ReportMapView") as? ReportMapView
    }

    func addConstraints() -> Void {
        reportMapView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
    }

    func setUpMap() -> Void {
        reportMapView?.mapView.clear()
        reportMapView?.mapView.delegate = self

       // reportMapView?.playRightButton.isHidden = true
        reportMapView?.playLeftButton.addTarget(self, action:#selector(didTapReplayButton(sender:)), for:.touchUpInside)
        reportMapView?.playRightButton.addTarget(self, action: #selector(didTapFastForwardButton(sender:)), for: .touchUpInside)
        reportMapView?.timeSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)

        reportMapView?.optionButton.addTarget(self, action: #selector(optionBtnCall(sender:)), for: .touchUpInside)
        reportMapView?.changeMapTypeBtn.addTarget(nil, action:#selector(changeMapTypeBtnAction(sender:)), for: .touchUpInside)
        reportMapView?.directionBtn.addTarget(nil, action:#selector(directionCall(sender:)), for: .touchUpInside)
        reportMapView?.stopsBtn.addTarget(nil, action:#selector(stopsCall(sender:)), for: .touchUpInside)
    }
    @objc func optionBtnCall(sender:UIButton){
        let isStopsDrawn = Defaults().get(for: Key<Bool>("isShowStops")) ?? false
        if sender.currentImage == #imageLiteral(resourceName: "Asset 148-1") {
            reportMapView?.directionBtn.isHidden = true
            reportMapView?.directionlbl.isHidden = true
            reportMapView?.changeMapTypeBtn.isHidden = true
            reportMapView?.changeMapTypelbl.isHidden = true
            reportMapView?.stopsBtn.isHidden = true
            reportMapView?.stopslbl.isHidden = true
            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"),for: .normal)
        }else {
            reportMapView?.directionBtn.isHidden = false
            reportMapView?.directionlbl.isHidden = false
            if isStopsDrawn {
                reportMapView?.stopsBtn.isHidden = false
                reportMapView?.stopslbl.isHidden = false
            }else {
                reportMapView?.stopsBtn.isHidden = true
                reportMapView?.stopslbl.isHidden = true
            }
            reportMapView?.changeMapTypeBtn.isHidden = false
            reportMapView?.changeMapTypelbl.isHidden = false
            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 148-1"),for: .normal)
        }
    }
    @objc func changeMapTypeBtnAction(sender:UIButton){
        if sender.currentImage == #imageLiteral(resourceName: "Asset 67") {
            reportMapView?.mapView.mapType = .satellite
            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 66"), for: .normal)
            reportMapView?.changeMapTypelbl.text = "Normal Map".toLocalize
        } else {
            reportMapView?.mapView.mapType = .normal
            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
            reportMapView?.changeMapTypelbl.text = "Satellite Map".toLocalize
        }
    }
    @objc func directionCall(sender:UIButton){
        if sender.currentImage == #imageLiteral(resourceName: "Asset 93") {
            for item  in directionMarkerArray {
                item.map = nil
            }
            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93 copy"), for: .normal)
            reportMapView?.directionlbl.text = "Show Directions".toLocalize
        } else {
            for item  in directionMarkerArray {
                item.map = reportMapView?.mapView
            }
            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93"), for: .normal)
            reportMapView?.directionlbl.text = "Hide Directions".toLocalize
        }
    }
    @objc func stopsCall(sender:UIButton){
        if sender.currentImage == #imageLiteral(resourceName: "Asset 94") {
            for item  in stopMarkerArray {
                item.map = nil
            }

            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94 copy") ,for: .normal)
            reportMapView?.stopslbl.text = "Show Stops".toLocalize

        } else {
            for item  in stopMarkerArray {
                item.map = reportMapView?.mapView
            }
            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94"), for: .normal)
            reportMapView?.stopslbl.text = "Hide Stops".toLocalize
        }
    }
    func updateMap() -> Void {

        switch reportType {
        case 0:
            plotMarkerOnMap(location: CLLocation(latitude: Double(stopsReportData.latitude!)!, longitude: Double(stopsReportData.longitude!)!).coordinate)
            reportMapView?.playLeftButton.isHidden = true
        case 1:
            reportMapView?.vehiclenameLabel.text = tripsReportData.device_name ?? "Device"
            let startDate = RCGlobals.getDateWithoutConversionFormat(tripsReportData.start_time ?? "", "yyyy-MM-dd HH:mm:ss") as Date
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
            let startDateFormat = RCGlobals.convertISTToUTC(tripsReportData.start_time ?? "", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            let endDateFormat = RCGlobals.convertISTToUTC(tripsReportData.end_time ?? "", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            reportMapView?.dateLabel.text = dateLabel
            getPath(deviceId: tripsReportData.device_id ?? 0, from: startDateFormat, to: endDateFormat)
        case 2:
            reportMapView?.vehiclenameLabel.text = summaryReportData.device_name ?? "Device"
            let startDate = RCGlobals.getDateWithoutConversionFormat(summaryReportData.start_time ?? "", "yyyy-MM-dd HH:mm:ss") as Date
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
            reportMapView?.dateLabel.text = dateLabel
            let startDateFormat = RCGlobals.convertISTToUTC(summaryReportData.start_time ?? "", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            let endDateFormat = RCGlobals.convertISTToUTC(summaryReportData.end_time ?? "", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            getPath(deviceId: summaryReportData.device_id ?? 0, from: startDateFormat, to: endDateFormat)
        default:
            break;
        }

    }
    @objc func didTapReplayButton(sender:UIButton){

        let coordinates = GMSMutablePath()
       // reportMapView?.playRightButton.isHidden = false

        for coordinate in coordinateArray {
            coordinates.add(coordinate)
        }

        if sender.currentImage == #imageLiteral(resourceName: "singlePlayicon") {
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            if pathMarker == nil{
                addPathMarker()
            }

            coordinates.removeAllCoordinates()
            for (index, coordinate) in coordinateArray.enumerated() {
                if index >= animateIndex {
                    coordinates.add(coordinate)
                    print(coordinate.latitude)
                }
            }
            pathMarker.userData = CoordinatesCollection(path:coordinates)

            let gmsPathSlider = GMSMutablePath()
            for cordinate in self.coordinateArray[0...animateIndex] {
                gmsPathSlider.add(cordinate)
            }

            totalDistance = GMSGeometryLength(gmsPathSlider)

            animate(toNextCoordinate: pathMarker)

        }else{
            sender.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
            sender.imageView?.contentMode = .scaleAspectFit
           // reportMapView?.playRightButton.isHidden = false
            coordinates.removeAllCoordinates()
            for (index, coordinate) in coordinateArray.enumerated() {
                if index >= animateIndex {
                    coordinates.add(coordinate)
                }
            }

            totalDistance = GMSGeometryLength(coordinates)
        }
    }

    func addPathMarker() {

        let coordinates = GMSMutablePath()
        // reportMapView?.playRightButton.isHidden = false

         for coordinate in coordinateArray {
             coordinates.add(coordinate)
         }

        pathMarker = GMSMarker(position:coordinates.coordinate(at:UInt(animateIndex)))
        switch markerType {
        case 0:
            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                pathMarker.icon = image
            } else {
                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
            }
            break

        case 1:
            if let image = (RCDataManager.get(objectforKey: "ActiveTruck") as? UIImage)?.resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default) {
                pathMarker.icon = image
            } else {
                pathMarker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default)
            }
            break

        case 2:
            if let image = (RCDataManager.get(objectforKey: "ActiveBike") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                pathMarker.icon = image
            } else {
                pathMarker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
            }

            break

        case 3,6,7,5,8:
            pathMarker.icon = #imageLiteral(resourceName: "car-icon-2")
            pathMarker.rotation = 0
            break

        default:
            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                pathMarker.icon = image
            } else {
                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
            }
            break
        }
     //   let keyValue = "Device_" + "\(selectedDeviceId)"
       // let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        //                var selectedvehiclename = selDevice?.name ?? ""


        // pathMarker.title = selDevice?.name
        pathMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        pathMarker.isFlat = true
        pathMarker.map = reportMapView?.mapView
        pathMarker.userData = CoordinatesCollection(path:coordinates)
    }

    @objc func sliderValueDidChange(_ sender:UISlider!) {

        animateIndex = Int(sender.value)

        if animateIndex == 0 {
            totalDistance = 0
        }

        if pathMarker == nil{
            addPathMarker()
        }

        let gmsPathSlider = GMSMutablePath()
        for cordinate in self.coordinateArray[0...animateIndex] {
            gmsPathSlider.add(cordinate)
        }

        let markerLocation = locationArray[animateIndex]
        let speed = RCGlobals.convertSpeedInt(speed: Float(markerLocation.speed))//changes l to L
        self.reportMapView?.showSpeedLabel.text = speed
        self.pathMarker.position = markerLocation.coordinate
        let time = markerLocation.timestamp
        let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
        reportMapView?.datecalenderLabel.text = timestring
        let currentDistance = GMSGeometryLength(gmsPathSlider)
        totalDistance = currentDistance
        reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000)

        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)

    }

    func getPath(deviceId: Int, from: String, to: String){

        RCLocalAPIManager.shared.getReportPath(with: deviceId, fromDate: from, toDate: to, success: { [weak self] hash in
            guard self != nil else {
                return
            }
            var coordinateArray:[CLLocationCoordinate2D] = []
            var idleTime = "0"
            var prevLocation: CLLocation? = nil
            self?.completePath = hash.data!
            for path in hash.data! {
//                let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromString(path.fixtime!))
                let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromStringWithFormat(path.fixtime ?? "", "yyyy-MM-dd HH:mm:ssZ"))

                if prevLocation == nil {
                    prevLocation = location
                    idleTime = path.fixtime!
                    continue
                }

                if location.distance(from: prevLocation!) > 0 {
                    let first =  RCGlobals.getDateFromString(idleTime)
                    let second =  RCGlobals.getDateFromString(path.fixtime!)

                    let dif =   RCGlobals.getDateDiff(start: first, end:second)
                    print(dif)
                    let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
                    if dif > ( stopDuration * 60 ) {
                        let intervalStart = RCGlobals.convertUTCToIST(idleTime, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")

                        let intervalEnd = RCGlobals.convertUTCToIST(path.fixtime!, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")

                        self!.idleIntervalArray.append("\(intervalStart) - \(intervalEnd)")
                        // append time diff
                        self!.idleTimeDifferenceArray.append(dif)
                        // append location
                        self!.StopsLocationArray.append(prevLocation!)
                        // append coordinate
                        self!.StopsCoordinateArray.append(prevLocation!.coordinate)

                    }
                    idleTime = path.fixtime!
                }

                self?.locationArray.append(location)
                prevLocation = location
                coordinateArray.append(location.coordinate)
                self?.directionCounter += 1
                if (self?.directionCounter ?? 0) % 20 == 0 {
                self?.plotDirectionMarker(location:location)
                }
            }
            if self!.StopsCoordinateArray.count > 0 {
                Defaults().set(true, for: Key<Bool>("isShowStops"))
            }else {
                Defaults().set(false, for: Key<Bool>("isShowStops"))
            }
            self?.reportMapView?.timeSlider.minimumValue = 0
            let sliderMaxValue = Float(coordinateArray.count)
            self?.reportMapView?.timeSlider.maximumValue =  (sliderMaxValue > 0) ? Float(sliderMaxValue - 1) : 0
            self?.plotPathOnMap(points:(self?.locationArray)!, coordinateArray:coordinateArray)
            self?.plotImageMarkerOnMap()
            self?.plotStopMarkersOnMap(coordinateArray: self!.StopsCoordinateArray, diffArray: (self?.idleTimeDifferenceArray)!)

        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("", "no path available", "OK") { (_) in
                self?.navigationController?.popViewController(animated: true)
            }
            print(message)
        }

    }
    func plotDirectionMarker(location:CLLocation){
        let directionMarker = GMSMarker(position: location.coordinate)
        directionMarker.rotation = location.course
        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "direction-arrow")!, deg: 180)
        directionMarker.icon = img.resizedImage(CGSize(width: 15, height: 20), interpolationQuality: .default)
        directionMarker.map = reportMapView?.mapView
        directionMarker.title = "Direction"
        directionMarkerArray.append(directionMarker)
    }
    func plotStopMarkersOnMap(coordinateArray:[CLLocationCoordinate2D] , diffArray:[Int]) -> Void {
        if coordinateArray.count > 0 {
            for index in 1...coordinateArray.count {
                let position = coordinateArray[index-1]
                let diff = diffArray[index-1]
                let stopMarker:GMSMarker = GMSMarker(position: position)
                stopMarker.map = reportMapView?.mapView

                let timeDiff = RCGlobals.secondsToHoursMinutesSeconds(diff)

                let timeGapInHrs:Int = timeDiff.0
                let timeGapInMins:Int = timeDiff.1

                var hrString:String = ""
                var minString:String = ""

                if timeGapInHrs > 1 {
                    hrString = "\(timeGapInHrs) Hr"
                } else {
                    hrString = "\(timeGapInHrs) Hrs"
                }

                if timeGapInMins > 1 {
                    minString = "\(timeGapInMins) min"
                } else {
                    minString = "\(timeGapInMins) mins"
                }

                let idleTime = "\(hrString) \(minString)"

                let markerImage = RCGlobals.textToImage(text: idleTime, inImage: UIImage(named:"ic_idle_marker")!, atPoint: CGPoint(x: 15, y: 15))
                stopMarker.icon = markerImage.resizedImage(CGSize(width: 65, height: 51), interpolationQuality: .default)

                stopMarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
                stopMarker.tracksInfoWindowChanges = true
                stopMarker.snippet = ""
                let interval = idleIntervalArray[index-1]
                stopMarker.userData = interval
                stopMarkerArray.append(stopMarker)
            }
        }

    }

    func plotImageMarkerOnMap() {
        for markerModel in markerImages {
            let coordinates = CLLocationCoordinate2D(latitude: markerModel.deviceLat!, longitude: markerModel.deviceLng!)
            let imageMarker = GMSMarker(position: coordinates)
            imageMarker.map = reportMapView?.mapView
            imageMarker.icon = #imageLiteral(resourceName: "ic_camera_icon").resizedImage(CGSize.init(width: 35, height: 48), interpolationQuality: .default)
            imageMarker.title = "Image_Title"

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            do {
                let jsonData = try encoder.encode(markerModel)

                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    imageMarker.snippet = jsonString
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func plotMarkerOnMap(location: CLLocationCoordinate2D) -> Void {

        //  reportMapView?.replayButton.isHidden = true

        startmarker = GMSMarker(position: location)
        startmarker.map = reportMapView?.mapView
        startmarker.icon = GMSMarker.markerImage(with:.red)
        startmarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
        startmarker.snippet = stopsReportData.address ?? "No address"
        startmarker.userData = RCGlobals.convertUTCToIST(stopsReportData.startTime ?? "0", "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy HH:mm:ss")
        coordinateArray.append(location)
        fitMapToBounds(coordinates:coordinateArray)
    }

    func plotPathOnMap(points:[CLLocation],coordinateArray:[CLLocationCoordinate2D]) -> Void {
        let _ = RCPolyLine().drawpolyLineFrom(points: coordinateArray,color: UIColor.blue,title: "", map: (reportMapView?.mapView)!)

        if coordinateArray.count == 0 {
            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
            reportMapView?.speedsMeterView.alpha = 0.5
            reportMapView?.upperView.isUserInteractionEnabled = false
            reportMapView?.upperView.alpha = 0.5
            self.view.makeToast("no data found", duration: 2.0, position: ToastPosition.bottom)
            return
        }
        startmarker = GMSMarker(position:coordinateArray.first!)
        startmarker.map = reportMapView?.mapView
        startmarker.icon = GMSMarker.markerImage(with:.green)
        startmarker.title = NSLocalizedString("Start Location", comment: "Start Location")

        //        startmarker.snippet =   RCGlobals.getFormattedData(date:(pathData.first?.tstamp)!)

        endMarker = GMSMarker(position:coordinateArray.last!)
        endMarker.map = reportMapView?.mapView
        endMarker.icon = GMSMarker.markerImage(with:.red)
        endMarker.title = NSLocalizedString("End Location", comment: "End Location")


        switch reportType {
        case 1:
            if let tripData = tripsReportData {
                let startDate = RCGlobals.convertUTCToIST(tripData.start_time ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
                let endDate = RCGlobals.convertUTCToIST(tripData.end_time ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
                startmarker.title = "Start time: \(startDate) \n" + "Start Address: \(tripData.startAddress ?? "")"
                endMarker.title = "End time: \(endDate) \n" + "End Address: \(tripData.endAddress ?? "")"
            }

        case 2:
            if startmarker != nil && endMarker != nil{
                let startDate = RCGlobals.convertUTCToIST(summaryReportData.start_time ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
                let endDate = RCGlobals.convertUTCToIST(summaryReportData.end_time ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
                startmarker.snippet = "Start time: \(startDate) \n" + "Start Address: \(summaryReportData.startAddress ?? "")"
                endMarker.snippet = "End time: \(endDate) \n" + "End Address: \(summaryReportData.endAddress ?? "")"
            }
        default:
            break
        }
        //        endMarker.snippet =   RCGlobals.getFormattedData(date:(pathData.last?.tstamp)!)
        fitMapToBounds(coordinates:coordinateArray)
    }

    func fitMapToBounds(coordinates:[CLLocationCoordinate2D]) -> Void {
        coordinateArray = coordinates
        DispatchQueue.main.async(execute: {() -> Void in
            var bounds = GMSCoordinateBounds(coordinate:coordinates.first!, coordinate:coordinates.last!)
            for marker in coordinates {
                bounds = bounds.includingCoordinate(marker)
            }
            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding:20)
            self.reportMapView?.mapView.animate(with:cameraUpdate)
        })
    }



    @objc func didTapFastForwardButton(sender:UIButton) {
        replaySpeed = replaySpeed + 1
        if replaySpeed > 4
        {
            replaySpeed = 1
        }
        let speed = String(format: "%.0f", (replaySpeed))
        reportMapView?.replayspeed.text = speed + "x"
    }
    func animate(toNextCoordinate marker: GMSMarker) {
        if animateIndex >= coordinateArray.count {
            self.animateIndex = 0
            self.reportMapView?.showSpeedLabel.text = "0"
            self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
            self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
            self.reportMapView?.currentkmLabel.text = ""
            self.reportMapView?.datecalenderLabel.text = ""
            self.reportMapView?.timeSlider.value = 0
            totalDistance = 0
            return
        }
        let coordinates: CoordinatesCollection? = marker.userData as? CoordinatesCollection
        let coord: CLLocationCoordinate2D? = coordinates?.next()
        let previous: CLLocationCoordinate2D = marker.position
        let heading: CLLocationDirection = GMSGeometryHeading(previous, coord!)
        let distance: CLLocationDistance = GMSGeometryDistance(previous, coord!)
        // Use CATransaction to set a custom duration for this animation. By default, changes to the
        // position are already animated, but with a very short default duration. When the animation is
        // complete, trigger another animation step.
        CATransaction.begin()
        let animationSpeed:Double = 3 * (replaySpeed * 100)
        CATransaction.setAnimationDuration((distance / animationSpeed))
        // custom duration, 5km/sec

        if locationArray.count > 0 {
            CATransaction.setCompletionBlock({() -> Void in
                let gmsPathSlider = GMSMutablePath()
                for cordinate in self.coordinateArray[0...self.animateIndex] {
                    gmsPathSlider.add(cordinate)
                }
                // speed:-
                let speed = RCGlobals.convertSpeedInt(speed: Float(self.locationArray[self.animateIndex].speed))
                self.reportMapView?.showSpeedLabel.text = speed
                //   :- time
//                let timestring = RCGlobals.convertUTCToIST(self.completePath[self.animateIndex].fixtime ?? "", "yyyy-MM-dd HH:mm:ss", "hh:mm a")
//                self.reportMapView?.datecalenderLabel.text = timestring
                let time = self.locationArray[self.animateIndex].timestamp
                let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
                self.reportMapView?.datecalenderLabel.text = timestring

                // :- current distance
                let currentDistance = GMSGeometryLength(gmsPathSlider)
                self.reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000) + "Km"
                //:-slider
                self.reportMapView?.timeSlider.value = Float(self.animateIndex)

                if self.coordinateArray.last?.latitude == coord?.latitude && self.coordinateArray.last?.longitude
                    == coord?.longitude {
                    //that means we have the last animation here
                    //we have to stop the recursive calls here
                    //change the button title if not changed
                    marker.map = nil
                    if (self.reportMapView?.playLeftButton.currentImage == #imageLiteral(resourceName: "pause")) {
                        self.animateIndex = 0
                        self.reportMapView?.showSpeedLabel.text = "0"
                     //   self.reportMapView?.playRightButton.isHidden = true
                        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
                        self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
                        self.pathMarker = nil
                    }


                }
                else {

                    if self.reportMapView?.playLeftButton.currentImage != #imageLiteral(resourceName: "singlePlayicon") {
                        //add a recursive call here to animate the markers
                        self.animateIndex += 1
                        self.animate(toNextCoordinate: marker)
                    }
                }
            })
        }else{
            self.prompt("Check your internet connection".toLocalize)
        }


        marker.position = coord!
        CATransaction.commit()
        // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
        if marker.isFlat {
            marker.rotation = heading
        }
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        if  marker.title == "Image_Title" {
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
            view.backgroundColor = UIColor.black
            view.layer.cornerRadius = 8
            view.alpha = 0.6

            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
            lbl1.textColor = UIColor.white
            lbl1.textAlignment = .center
            lbl1.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            lbl1.adjustsFontForContentSizeCategory = true
            lbl1.adjustsFontSizeToFitWidth = true

            let lbl2 = UILabel(frame: CGRect.zero)
            lbl2.textColor = UIColor.white
            lbl2.textAlignment = .center
            lbl2.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            lbl2.adjustsFontForContentSizeCategory = true
            //            lbl2.adjustsFontSizeToFitWidth = true
            lbl2.layer.cornerRadius = 4
            lbl2.layer.masksToBounds = true
            lbl2.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)

            if let jsonData = marker.snippet!.data(using: .utf8)
            {
                let decoder = JSONDecoder()

                do {
                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
                    lbl1.text = markerModel.title
                    lbl2.text = "\(markerModel.imagePathList?.count ?? 0) photos"
                } catch {
                    print(error.localizedDescription)
                }
            }

            view.addSubview(lbl1)
            view.addSubview(lbl2)

            lbl2.snp.makeConstraints{(make) in
                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
                make.centerX.equalToSuperview()
                make.width.equalTo(0.2 * kscreenwidth)
            }

            return view
        } else if marker.title == "Stop Location" {
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 100))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 2

            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 35))
            lbl1.textColor = UIColor.appGreen
            lbl1.textAlignment = .center
            lbl1.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            lbl1.numberOfLines = 2

            let lbl2 = UILabel(frame: CGRect.zero)
            lbl2.textColor = UIColor.darkGray
            lbl2.textAlignment = .center
            lbl2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lbl2.numberOfLines = 4

            let time = marker.userData ?? ""

            lbl1.text = time as? String

            var addressText: String = ""

            let geocoder = GMSGeocoder()
            marker.tracksInfoWindowChanges = true
            geocoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
                guard let address = response?.firstResult(), let lines = address.lines else { return }
                addressText = lines.joined(separator: " ")
                print(addressText)
                lbl2.text = addressText
            }

            view.addSubview(lbl1)
            view.addSubview(lbl2)

            lbl2.snp.makeConstraints{(make) in
                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.6)
            }

            return view


        }  else {
            return nil
        }
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if  marker.title == "Image_Title" {
            if let jsonData = marker.snippet!.data(using: .utf8)
            {
                let decoder = JSONDecoder()

                do {
                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
                    Defaults().set(markerModel, for: Key<MarkerFirebaseModel> ("particularMarkerInfo"))
                    let markerphotoVC = MarkerPhotoViewController()
                    let controller = UINavigationController(rootViewController: markerphotoVC)
                    self.present(controller, animated: true, completion: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
//
//
//  RcReportsMapViewController.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

//import UIKit
//import GoogleMaps
//import DefaultsKit
//
//class CoordinatesCollection : NSObject {
//
//    var path:GMSPath!
//    var target:UInt
//
//    init(path: GMSPath) {
//        self.path = path
//        target = 0
//        super.init()
//    }
//
//    func next() -> CLLocationCoordinate2D {
//        target += 1
//        if target == path.count() {
//            target = 0
//        }
//        return path.coordinate(at:target)
//    }
//
//}
//
//class ReportMapsViewController: UIViewController, GMSMapViewDelegate {
//
//    var reportMapView:ReportMapView?
//    var markerType:Int = 0
//    var reportType:Int = 0
//    var summaryReportData: SummaryReportModelData!
//    var tripsReportData: TripsReportModelData!
//    var stopsReportData: StopsReportModelData!
//    var markerImages : [MarkerFirebaseModel] = []
//
//    var endMarker:GMSMarker!
//    var startmarker:GMSMarker!
//    var coordinateArray:[CLLocationCoordinate2D] = []
//    var locationArray:[CLLocation] = []
//    var replaySpeed:Double = 1
//
//
//    var StopsLocationArray: [CLLocation] = []
//    var StopsCoordinateArray:[CLLocationCoordinate2D] = []
//    var idleTimeDifferenceArray:[Int] = []
//    var idleIntervalArray:[String] = []
//    var stopMarkerArray:[GMSMarker] = []
//    var directionMarkerArray:[GMSMarker] = []
//    var directionCounter:Int = 0
//    var pathMarker: GMSMarker!
//    var animateIndex: Int = 0
//    var completePath:[ReportPathModelData] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addContainer()
//        addConstraints()
//        setUpMap()
//
//        if reportType == 0 {
//            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
//            reportMapView?.speedsMeterView.alpha = 0.5
//            reportMapView?.upperView.isUserInteractionEnabled = false
//            reportMapView?.upperView.alpha = 0.5
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        updateMap()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    func addContainer() -> Void{
//        reportMapView = view.createAndAddSubView(view:"ReportMapView") as? ReportMapView
//    }
//
//    func addConstraints() -> Void {
//        reportMapView?.snp.makeConstraints({ (make) in
//            make.edges.equalTo(view)
//        })
//    }
//
//    func setUpMap() -> Void {
//        reportMapView?.mapView.clear()
//        reportMapView?.mapView.delegate = self
//
//       // reportMapView?.playRightButton.isHidden = true
//        reportMapView?.playLeftButton.addTarget(self, action:#selector(didTapReplayButton(sender:)), for:.touchUpInside)
//        reportMapView?.playRightButton.addTarget(self, action: #selector(didTapFastForwardButton(sender:)), for: .touchUpInside)
//        reportMapView?.timeSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
//
//        reportMapView?.optionButton.addTarget(self, action: #selector(optionBtnCall(sender:)), for: .touchUpInside)
//        reportMapView?.changeMapTypeBtn.addTarget(nil, action:#selector(changeMapTypeBtnAction(sender:)), for: .touchUpInside)
//        reportMapView?.directionBtn.addTarget(nil, action:#selector(directionCall(sender:)), for: .touchUpInside)
//        reportMapView?.stopsBtn.addTarget(nil, action:#selector(stopsCall(sender:)), for: .touchUpInside)
//    }
//    @objc func optionBtnCall(sender:UIButton){
//        let isStopsDrawn = Defaults().get(for: Key<Bool>("isShowStops")) ?? false
//        if sender.currentImage == #imageLiteral(resourceName: "Asset 148-1") {
//            reportMapView?.directionBtn.isHidden = true
//            reportMapView?.directionlbl.isHidden = true
//            reportMapView?.changeMapTypeBtn.isHidden = true
//            reportMapView?.changeMapTypelbl.isHidden = true
//            reportMapView?.stopsBtn.isHidden = true
//            reportMapView?.stopslbl.isHidden = true
//            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"),for: .normal)
//        }else {
//            reportMapView?.directionBtn.isHidden = false
//            reportMapView?.directionlbl.isHidden = false
//            if isStopsDrawn {
//                reportMapView?.stopsBtn.isHidden = false
//                reportMapView?.stopslbl.isHidden = false
//            }else {
//                reportMapView?.stopsBtn.isHidden = true
//                reportMapView?.stopslbl.isHidden = true
//            }
//            reportMapView?.changeMapTypeBtn.isHidden = false
//            reportMapView?.changeMapTypelbl.isHidden = false
//            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 148-1"),for: .normal)
//        }
//    }
//    @objc func changeMapTypeBtnAction(sender:UIButton){
//        if sender.currentImage == #imageLiteral(resourceName: "Asset 67") {
//            reportMapView?.mapView.mapType = .satellite
//            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 66"), for: .normal)
//            reportMapView?.changeMapTypelbl.text = "Normal Map".toLocalize
//        } else {
//            reportMapView?.mapView.mapType = .normal
//            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
//            reportMapView?.changeMapTypelbl.text = "Satellite Map".toLocalize
//        }
//    }
//    @objc func directionCall(sender:UIButton){
//        if sender.currentImage == #imageLiteral(resourceName: "Asset 93") {
//            for item  in directionMarkerArray {
//                item.map = nil
//            }
//            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93 copy"), for: .normal)
//            reportMapView?.directionlbl.text = "Show Directions".toLocalize
//        } else {
//            for item  in directionMarkerArray {
//                item.map = reportMapView?.mapView
//            }
//            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93"), for: .normal)
//            reportMapView?.directionlbl.text = "Hide Directions".toLocalize
//        }
//    }
//    @objc func stopsCall(sender:UIButton){
//        if sender.currentImage == #imageLiteral(resourceName: "Asset 94") {
//            for item  in stopMarkerArray {
//                item.map = nil
//            }
//
//            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94 copy") ,for: .normal)
//            reportMapView?.stopslbl.text = "Show Stops".toLocalize
//        } else {
//            for item  in stopMarkerArray {
//                item.map = reportMapView?.mapView
//            }
//            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94"), for: .normal)
//            reportMapView?.stopslbl.text = "Hide Stops".toLocalize
//        }
//    }
//    func updateMap() -> Void {
//
//        switch reportType {
//        case 0:
//            plotMarkerOnMap(location: CLLocation(latitude: Double(stopsReportData.latitude!)!, longitude: Double(stopsReportData.longitude!)!).coordinate)
//            reportMapView?.playLeftButton.isHidden = true
//        case 1:
//            reportMapView?.vehiclenameLabel.text = tripsReportData.deviceName!
//            let startDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
//            reportMapView?.dateLabel.text = dateLabel
//            getPath(deviceId: Int(tripsReportData.deviceId!)!, from: tripsReportData.startTime!, to: tripsReportData.endTime!)
//        case 2:
//            reportMapView?.vehiclenameLabel.text = summaryReportData.deviceName!
//            let startDate = RCGlobals.getDateChinaToLocalFromString((summaryReportData.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
//            reportMapView?.dateLabel.text = dateLabel
//            getPath(deviceId: Int(summaryReportData.deviceId!)!, from: summaryReportData.startTime!, to: summaryReportData.endTime!)
//        default:
//            break;
//        }
//    }
//    @objc func didTapReplayButton(sender:UIButton){
//
//        let coordinates = GMSMutablePath()
//       // reportMapView?.playRightButton.isHidden = false
//
//        for coordinate in coordinateArray {
//            coordinates.add(coordinate)
//        }
//
//        if sender.currentImage == #imageLiteral(resourceName: "singlePlayicon") {
//            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
//            if pathMarker == nil{
//                addPathMarker()
//            }
//
//            coordinates.removeAllCoordinates()
//            for (index, coordinate) in coordinateArray.enumerated() {
//                if index >= animateIndex {
//                    coordinates.add(coordinate)
//                    print(coordinate.latitude)
//                }
//            }
//            pathMarker.userData = CoordinatesCollection(path:coordinates)
//
//            let gmsPathSlider = GMSMutablePath()
//            for cordinate in self.coordinateArray[0...animateIndex] {
//                gmsPathSlider.add(cordinate)
//            }
//
//            totalDistance = GMSGeometryLength(gmsPathSlider)
//
//            animate(toNextCoordinate: pathMarker)
//
//        }else{
//            sender.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
//            sender.imageView?.contentMode = .scaleAspectFit
//           // reportMapView?.playRightButton.isHidden = false
//            coordinates.removeAllCoordinates()
//            for (index, coordinate) in coordinateArray.enumerated() {
//                if index >= animateIndex {
//                    coordinates.add(coordinate)
//                }
//            }
//
//            totalDistance = GMSGeometryLength(coordinates)
//        }
//    }
//
//    func addPathMarker() {
//
//        let coordinates = GMSMutablePath()
//        // reportMapView?.playRightButton.isHidden = false
//
//         for coordinate in coordinateArray {
//             coordinates.add(coordinate)
//         }
//
//        pathMarker = GMSMarker(position:coordinates.coordinate(at:UInt(animateIndex)))
//        switch markerType {
//        case 0:
//            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
//                pathMarker.icon = image
//            } else {
//                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
//            }
//            break
//
//        case 1:
//            if let image = (RCDataManager.get(objectforKey: "ActiveTruck") as? UIImage)?.resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default) {
//                pathMarker.icon = image
//            } else {
//                pathMarker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default)
//            }
//            break
//
//        case 2:
//            if let image = (RCDataManager.get(objectforKey: "ActiveBike") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
//                pathMarker.icon = image
//            } else {
//                pathMarker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
//            }
//
//            break
//
//        case 3,6,7,5,8:
//            pathMarker.icon = #imageLiteral(resourceName: "car-icon-2")
//            pathMarker.rotation = 0
//            break
//
//        default:
//            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
//                pathMarker.icon = image
//            } else {
//                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
//            }
//            break
//        }
//        let keyValue = "Device_" + "\(selectedDeviceId)"
//        let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
//        //                var selectedvehiclename = selDevice?.name ?? ""
//
//
//        // pathMarker.title = selDevice?.name
//        pathMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
//        pathMarker.isFlat = true
//        pathMarker.map = reportMapView?.mapView
//        pathMarker.userData = CoordinatesCollection(path:coordinates)
//    }
//
//    @objc func sliderValueDidChange(_ sender:UISlider!) {
//
//        animateIndex = Int(sender.value)
//
//        if animateIndex == 0 {
//            totalDistance = 0
//        }
//
//        if pathMarker == nil{
//            addPathMarker()
//        }
//
//        let gmsPathSlider = GMSMutablePath()
//        for cordinate in self.coordinateArray[0...animateIndex] {
//            gmsPathSlider.add(cordinate)
//        }
//
//        let markerLocation = locationArray[animateIndex]
//        let speed = RCGlobals.convertSpeedInt(speed: Float(markerLocation.speed))//changes l to L
//        self.reportMapView?.showSpeedLabel.text = speed
//        self.pathMarker.position = markerLocation.coordinate
//        let time = markerLocation.timestamp
//        let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
//        reportMapView?.datecalenderLabel.text = timestring
//        let currentDistance = GMSGeometryLength(gmsPathSlider)
//        totalDistance = currentDistance
//        reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000)
//
//        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
//
//    }
//
//    func getPath(deviceId: Int, from: String, to: String){
//
//        RCLocalAPIManager.shared.getReportPath(with: deviceId, fromDate: from, toDate: to, success: { [weak self] hash in
//            guard self != nil else {
//                return
//            }
//            var coordinateArray:[CLLocationCoordinate2D] = []
//            var idleTime = "0"
//            var prevLocation: CLLocation? = nil
//            for path in hash.data! {
//                let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromStringWithFormat(path.fixtime ?? "", "yyyy-MM-dd HH:mm:ssZ"))
//
//                if prevLocation == nil {
//                    prevLocation = location
//               idleTime = path.fixtime!
//                    continue
//                }
//
//                if location.distance(from: prevLocation!) > 0 {
//                    let first =  RCGlobals.getDateFromString(idleTime)
//                    let second =  RCGlobals.getDateFromString(path.fixtime!)
//
//                    let dif =   RCGlobals.getDateDiff(start: first, end:second)
//                    print(dif)
//                    let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
//                    if dif > ( stopDuration * 60 ) {
//                        let intervalStart = RCGlobals.convertUTCToIST(idleTime, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")
//
//                        let intervalEnd = RCGlobals.convertUTCToIST(path.fixtime!, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")
//
//                        self!.idleIntervalArray.append("\(intervalStart) - \(intervalEnd)")
//                        // append time diff
//                        self!.idleTimeDifferenceArray.append(dif)
//                        // append location
//                        self!.StopsLocationArray.append(prevLocation!)
//                        // append coordinate
//                        self!.StopsCoordinateArray.append(prevLocation!.coordinate)
//
//                    }
//                    idleTime = path.fixtime!
//                }
//
//                self?.locationArray.append(location)
//                prevLocation = location
//                coordinateArray.append(location.coordinate)
//                self?.directionCounter += 1
//                if (self?.directionCounter ?? 0) % 20 == 0 {
//                self?.plotDirectionMarker(location:location)
//                }
//            }
//            if self!.StopsCoordinateArray.count > 0 {
//                Defaults().set(true, for: Key<Bool>("isShowStops"))
//            }else {
//                Defaults().set(false, for: Key<Bool>("isShowStops"))
//            }
//            self?.reportMapView?.timeSlider.minimumValue = 0
//            let sliderMaxValue = Float(coordinateArray.count)
//            self?.reportMapView?.timeSlider.maximumValue =  (sliderMaxValue > 0) ? Float(sliderMaxValue - 1) : 0
//            self?.plotPathOnMap(points:(self?.locationArray)!, coordinateArray:coordinateArray)
//            self?.plotImageMarkerOnMap()
//            self?.plotStopMarkersOnMap(coordinateArray: self!.StopsCoordinateArray, diffArray: (self?.idleTimeDifferenceArray)!)
//
//        }) { [weak self] message in
//            guard let weakSelf = self else {
//                return
//            }
//            weakSelf.prompt("please try again")
//            print(message)
//        }
//
//    }
//    func plotDirectionMarker(location:CLLocation){
//        let directionMarker = GMSMarker(position: location.coordinate)
//        directionMarker.rotation = location.course
//        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "direction-arrow")!, deg: 180)
//        directionMarker.icon = img.resizedImage(CGSize(width: 15, height: 20), interpolationQuality: .default)
//        directionMarker.map = reportMapView?.mapView
//        directionMarker.title = "Direction"
//        directionMarkerArray.append(directionMarker)
//    }
//    func plotStopMarkersOnMap(coordinateArray:[CLLocationCoordinate2D] , diffArray:[Int]) -> Void {
//        if coordinateArray.count > 0 {
//            for index in 1...coordinateArray.count {
//                let position = coordinateArray[index-1]
//                let diff = diffArray[index-1]
//                let stopMarker:GMSMarker = GMSMarker(position: position)
//                stopMarker.map = reportMapView?.mapView
//
//                let timeDiff = RCGlobals.secondsToHoursMinutesSeconds(diff)
//
//                let timeGapInHrs:Int = timeDiff.0
//                let timeGapInMins:Int = timeDiff.1
//
//                var hrString:String = ""
//                var minString:String = ""
//
//                if timeGapInHrs > 1 {
//                    hrString = "\(timeGapInHrs) Hr"
//                } else {
//                    hrString = "\(timeGapInHrs) Hrs"
//                }
//
//                if timeGapInMins > 1 {
//                    minString = "\(timeGapInMins) min"
//                } else {
//                    minString = "\(timeGapInMins) mins"
//                }
//
//                let idleTime = "\(hrString) \(minString)"
//
//                let markerImage = RCGlobals.textToImage(text: idleTime, inImage: UIImage(named:"ic_idle_marker")!, atPoint: CGPoint(x: 15, y: 15))
//                stopMarker.icon = markerImage.resizedImage(CGSize(width: 65, height: 51), interpolationQuality: .default)
//
//                stopMarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
//                stopMarker.tracksInfoWindowChanges = true
//                stopMarker.snippet = ""
//                let interval = idleIntervalArray[index-1]
//                stopMarker.userData = interval
//                stopMarkerArray.append(stopMarker)
//            }
//        }
//
//    }
//
//    func plotImageMarkerOnMap() {
//        for markerModel in markerImages {
//            let coordinates = CLLocationCoordinate2D(latitude: markerModel.deviceLat!, longitude: markerModel.deviceLng!)
//            let imageMarker = GMSMarker(position: coordinates)
//            imageMarker.map = reportMapView?.mapView
//            imageMarker.icon = #imageLiteral(resourceName: "ic_camera_icon").resizedImage(CGSize.init(width: 35, height: 48), interpolationQuality: .default)
//            imageMarker.title = "Image_Title"
//
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//
//            do {
//                let jsonData = try encoder.encode(markerModel)
//
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
//                    imageMarker.snippet = jsonString
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func plotMarkerOnMap(location: CLLocationCoordinate2D) -> Void {
//
//        //  reportMapView?.replayButton.isHidden = true
//
//        startmarker = GMSMarker(position: location)
//        startmarker.map = reportMapView?.mapView
//        startmarker.icon = GMSMarker.markerImage(with:.red)
//        startmarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
//        startmarker.snippet = stopsReportData.address ?? "No address"
//
//        coordinateArray.append(location)
//        fitMapToBounds(coordinates:coordinateArray)
//    }
//
//    func plotPathOnMap(points:[CLLocation],coordinateArray:[CLLocationCoordinate2D]) -> Void {
//        let _ = RCPolyLine().drawpolyLineFrom(points: coordinateArray,color: UIColor.blue,title: "", map: (reportMapView?.mapView)!)
//        if coordinateArray.count == 0 {
//            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
//            reportMapView?.speedsMeterView.alpha = 0.5
//            reportMapView?.upperView.isUserInteractionEnabled = false
//            reportMapView?.upperView.alpha = 0.5
//            self.view.makeToast("no data found", duration: 2.0, position: ToastPosition.bottom)
//            return
//        }
//        startmarker = GMSMarker(position:coordinateArray.first!)
//        startmarker.map = reportMapView?.mapView
//        startmarker.icon = GMSMarker.markerImage(with:.green)
//        startmarker.title = NSLocalizedString("Start Location", comment: "Start Location")
//
//        //        startmarker.snippet =   RCGlobals.getFormattedData(date:(pathData.first?.tstamp)!)
//
//        endMarker = GMSMarker(position:coordinateArray.last!)
//        endMarker.map = reportMapView?.mapView
//        endMarker.icon = GMSMarker.markerImage(with:.red)
//        endMarker.title = NSLocalizedString("End Location", comment: "End Location")
//
//
//        switch reportType {
//        case 1:
//            if let tripData = tripsReportData {
////                startmarker.title = "Start time: \(tripData.startTime ?? "") \n" + "Start Address: \(tripData.startAddress ?? "")"
////                endMarker.title = "End time: \(tripData.endTime ?? "") \n" + "End Address: \(tripData.endAddress ?? "")"
//                let startDate = RCGlobals.convertUTCToIST(tripData.startTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
//                let endDate = RCGlobals.convertUTCToIST(tripData.endTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
//                startmarker.title = "Start time: \(startDate) \n" + "Start Address: \(tripData.startAddress ?? "")"
//                endMarker.title = "End time: \(endDate) \n" + "End Address: \(tripData.endAddress ?? "")"
//            }
//
//        case 2:
//           if startmarker != nil && endMarker != nil{
////                startmarker.snippet = "Start time: \(summaryReportData.startTime ?? "") \n" + "Start Address: \(summaryReportData.startAddress ?? "")"
////                endMarker.snippet = "End time: \(summaryReportData.endTime ?? "") \n" + "End Address: \(summaryReportData.endAddress ?? "")"
//            let startDate = RCGlobals.convertUTCToIST(summaryReportData.startTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
//            let endDate = RCGlobals.convertUTCToIST(summaryReportData.endTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
//            startmarker.snippet = "Start time: \(startDate) \n" + "Start Address: \(summaryReportData.startAddress ?? "")"
//            endMarker.snippet = "End time: \(endDate) \n" + "End Address: \(summaryReportData.endAddress ?? "")"
//            }
//        default:
//            break
//        }
//        //        endMarker.snippet =   RCGlobals.getFormattedData(date:(pathData.last?.tstamp)!)
//        fitMapToBounds(coordinates:coordinateArray)
//    }
//
//    func fitMapToBounds(coordinates:[CLLocationCoordinate2D]) -> Void {
//        coordinateArray = coordinates
//        DispatchQueue.main.async(execute: {() -> Void in
//            var bounds = GMSCoordinateBounds(coordinate:coordinates.first!, coordinate:coordinates.last!)
//            for marker in coordinates {
//                bounds = bounds.includingCoordinate(marker)
//            }
//            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding:20)
//            self.reportMapView?.mapView.animate(with:cameraUpdate)
//        })
//    }
//
//
//
//    @objc func didTapFastForwardButton(sender:UIButton) {
//        replaySpeed = replaySpeed + 1
//        if replaySpeed > 4
//        {
//            replaySpeed = 1
//        }
//        let speed = String(format: "%.0f", (replaySpeed))
//        reportMapView?.replayspeed.text = speed + "x"
//    }
//    func animate(toNextCoordinate marker: GMSMarker) {
//        if animateIndex >= coordinateArray.count {
//            self.animateIndex = 0
//            self.reportMapView?.showSpeedLabel.text = "0"
//            self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
//            self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
//            self.reportMapView?.currentkmLabel.text = ""
//            self.reportMapView?.datecalenderLabel.text = ""
//            self.reportMapView?.timeSlider.value = 0
//            totalDistance = 0
//            return
//        }
//        let coordinates: CoordinatesCollection? = marker.userData as? CoordinatesCollection
//        let coord: CLLocationCoordinate2D? = coordinates?.next()
//        let previous: CLLocationCoordinate2D = marker.position
//        let heading: CLLocationDirection = GMSGeometryHeading(previous, coord!)
//        let distance: CLLocationDistance = GMSGeometryDistance(previous, coord!)
//        // Use CATransaction to set a custom duration for this animation. By default, changes to the
//        // position are already animated, but with a very short default duration. When the animation is
//        // complete, trigger another animation step.
//        CATransaction.begin()
//        let animationSpeed:Double = 3 * (replaySpeed * 100)
//        CATransaction.setAnimationDuration((distance / animationSpeed))
//        // custom duration, 5km/sec
//
//        if locationArray.count > 0 {
//            CATransaction.setCompletionBlock({() -> Void in
//                let gmsPathSlider = GMSMutablePath()
//                for cordinate in self.coordinateArray[0...self.animateIndex] {
//                    gmsPathSlider.add(cordinate)
//                }
//                // speed:-
//                let speed = RCGlobals.convertSpeedInt(speed: Float(self.locationArray[self.animateIndex].speed))
//                self.reportMapView?.showSpeedLabel.text = speed
//                //   :- time
//                let time = self.locationArray[self.animateIndex].timestamp
//                let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
//            //   let timestring = RCGlobals.convertUTCToIST(self.completePath[self.animateIndex].fixtime ?? "", "yyyy-MM-dd HH:mm:ss'+'SS", "hh:mm a")
//                self.reportMapView?.datecalenderLabel.text = timestring
//                // :- current distance
//                let currentDistance = GMSGeometryLength(gmsPathSlider)
//                self.reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000) + "Km"
//                //:-slider
//                self.reportMapView?.timeSlider.value = Float(self.animateIndex)
//
//                if self.coordinateArray.last?.latitude == coord?.latitude && self.coordinateArray.last?.longitude
//                    == coord?.longitude {
//                    //that means we have the last animation here
//                    //we have to stop the recursive calls here
//                    //change the button title if not changed
//                    marker.map = nil
//                    if (self.reportMapView?.playLeftButton.currentImage == #imageLiteral(resourceName: "pause")) {
//                        self.animateIndex = 0
//                        self.reportMapView?.showSpeedLabel.text = "0"
//                     //   self.reportMapView?.playRightButton.isHidden = true
//                        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
//                        self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
//                        self.pathMarker = nil
//                    }
//
//
//                }
//                else {
//
//                    if self.reportMapView?.playLeftButton.currentImage != #imageLiteral(resourceName: "singlePlayicon") {
//                        //add a recursive call here to animate the markers
//                        self.animateIndex += 1
//                        self.animate(toNextCoordinate: marker)
//                    }
//                }
//            })
//        }else{
//            self.prompt("Check your internet connection".toLocalize)
//        }
//
//
//        marker.position = coord!
//        CATransaction.commit()
//        // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
//        if marker.isFlat {
//            marker.rotation = heading
//        }
//    }
//
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//
//        if  marker.title == "Image_Title" {
//            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
//            view.backgroundColor = UIColor.black
//            view.layer.cornerRadius = 8
//            view.alpha = 0.6
//
//            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
//            lbl1.textColor = UIColor.white
//            lbl1.textAlignment = .center
//            lbl1.font = UIFont.systemFont(ofSize: 13, weight: .bold)
//            lbl1.adjustsFontForContentSizeCategory = true
//            lbl1.adjustsFontSizeToFitWidth = true
//
//            let lbl2 = UILabel(frame: CGRect.zero)
//            lbl2.textColor = UIColor.white
//            lbl2.textAlignment = .center
//            lbl2.font = UIFont.systemFont(ofSize: 13, weight: .bold)
//            lbl2.adjustsFontForContentSizeCategory = true
//            //            lbl2.adjustsFontSizeToFitWidth = true
//            lbl2.layer.cornerRadius = 4
//            lbl2.layer.masksToBounds = true
//            lbl2.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
//
//            if let jsonData = marker.snippet!.data(using: .utf8)
//            {
//                let decoder = JSONDecoder()
//
//                do {
//                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
//                    lbl1.text = markerModel.title
//                    lbl2.text = "\(markerModel.imagePathList?.count ?? 0) photos"
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//
//            view.addSubview(lbl1)
//            view.addSubview(lbl2)
//
//            lbl2.snp.makeConstraints{(make) in
//                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
//                make.centerX.equalToSuperview()
//                make.width.equalTo(0.2 * kscreenwidth)
//            }
//
//            return view
//        } else if marker.title == "Stop Location" {
//            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 120))
//            view.backgroundColor = UIColor.white
//            view.layer.cornerRadius = 2
//
//            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 35))
//            lbl1.textColor = UIColor.appGreen
//            lbl1.textAlignment = .center
//            lbl1.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//            lbl1.numberOfLines = 2
//
//            let lbl2 = UILabel(frame: CGRect.zero)
//            lbl2.textColor = UIColor.darkGray
//            lbl2.textAlignment = .center
//            lbl2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//            lbl2.numberOfLines = 4
//
//            let time = marker.userData ?? ""
//
//            lbl1.text = time as? String
//
//            var addressText: String = ""
//
//            let geocoder = GMSGeocoder()
//            geocoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
//                guard let address = response?.firstResult(), let lines = address.lines else { return }
//                addressText = lines.joined(separator: " ")
//                print(addressText)
//                lbl2.text = addressText
//            }
//
//            view.addSubview(lbl1)
//            view.addSubview(lbl2)
//
//            lbl2.snp.makeConstraints{(make) in
//                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
//                make.centerX.equalToSuperview()
//                make.width.equalToSuperview().multipliedBy(0.9)
//                make.height.equalToSuperview().multipliedBy(0.6)
//            }
//
//            return view
//
//
//        }  else {
//            return nil
//        }
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        if  marker.title == "Image_Title" {
//            if let jsonData = marker.snippet!.data(using: .utf8)
//            {
//                let decoder = JSONDecoder()
//
//                do {
//                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
//                    Defaults().set(markerModel, for: Key<MarkerFirebaseModel> ("particularMarkerInfo"))
//                    let markerphotoVC = MarkerPhotoViewController()
//                    let controller = UINavigationController(rootViewController: markerphotoVC)
//                    self.present(controller, animated: true, completion: nil)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//}
////
////
//
//
////
////
////  RcReportsMapViewController.swift
////  findMe
////
////  Created By Anshul Jain on 25-March-2019
////  Copyright © Roadcast Tech Solutions Private Limited
////
//
////import UIKit
////import GoogleMaps
////import DefaultsKit
////
////class CoordinatesCollection : NSObject {
////
////    var path:GMSPath!
////    var target:UInt
////
////    init(path: GMSPath) {
////        self.path = path
////        target = 0
////        super.init()
////    }
////
////    func next() -> CLLocationCoordinate2D {
////        target += 1
////        if target == path.count() {
////            target = 0
////        }
////        return path.coordinate(at:target)
////    }
////
////}
////
////class ReportMapsViewController: UIViewController, GMSMapViewDelegate {
////
////    var reportMapView:ReportMapView?
////    var markerType:Int = 0
////    var reportType:Int = 0
////    var summaryReportData: SummaryReportModelData!
////    var tripsReportData: TripsReportModelData!
////    var stopsReportData: StopsReportModelData!
////    var markerImages : [MarkerFirebaseModel] = []
////
////    var endMarker:GMSMarker!
////    var startmarker:GMSMarker!
////    var coordinateArray:[CLLocationCoordinate2D] = []
////    var locationArray:[CLLocation] = []
////    var replaySpeed:Double = 1
////
////
////    var StopsLocationArray: [CLLocation] = []
////    var StopsCoordinateArray:[CLLocationCoordinate2D] = []
////    var idleTimeDifferenceArray:[Int] = []
////    var idleIntervalArray:[String] = []
////    var stopMarkerArray:[GMSMarker] = []
////    var directionMarkerArray:[GMSMarker] = []
////    var directionCounter:Int = 0
////    var pathMarker: GMSMarker!
////    var animateIndex: Int = 0
////    var completePath:[ReportPathModelData] = []
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        addContainer()
////        addConstraints()
////        setUpMap()
////
////        if reportType == 0 {
////            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
////            reportMapView?.speedsMeterView.alpha = 0.5
////            reportMapView?.upperView.isUserInteractionEnabled = false
////            reportMapView?.upperView.alpha = 0.5
////        }
////    }
////
////    override func viewDidAppear(_ animated: Bool) {
////        updateMap()
////    }
////
////    override func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////    }
////
////    func addContainer() -> Void{
////        reportMapView = view.createAndAddSubView(view:"ReportMapView") as? ReportMapView
////    }
////
////    func addConstraints() -> Void {
////        reportMapView?.snp.makeConstraints({ (make) in
////            make.edges.equalTo(view)
////        })
////    }
////
////    func setUpMap() -> Void {
////        reportMapView?.mapView.clear()
////        reportMapView?.mapView.delegate = self
////
////       // reportMapView?.playRightButton.isHidden = true
////        reportMapView?.playLeftButton.addTarget(self, action:#selector(didTapReplayButton(sender:)), for:.touchUpInside)
////        reportMapView?.playRightButton.addTarget(self, action: #selector(didTapFastForwardButton(sender:)), for: .touchUpInside)
////        reportMapView?.timeSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
////
////        reportMapView?.optionButton.addTarget(self, action: #selector(optionBtnCall(sender:)), for: .touchUpInside)
////        reportMapView?.changeMapTypeBtn.addTarget(nil, action:#selector(changeMapTypeBtnAction(sender:)), for: .touchUpInside)
////        reportMapView?.directionBtn.addTarget(nil, action:#selector(directionCall(sender:)), for: .touchUpInside)
////        reportMapView?.stopsBtn.addTarget(nil, action:#selector(stopsCall(sender:)), for: .touchUpInside)
////    }
////    @objc func optionBtnCall(sender:UIButton){
////        let isStopsDrawn = Defaults().get(for: Key<Bool>("isShowStops")) ?? false
////        if sender.currentImage == #imageLiteral(resourceName: "Asset 148-1") {
////            reportMapView?.directionBtn.isHidden = true
////            reportMapView?.directionlbl.isHidden = true
////            reportMapView?.changeMapTypeBtn.isHidden = true
////            reportMapView?.changeMapTypelbl.isHidden = true
////            reportMapView?.stopsBtn.isHidden = true
////            reportMapView?.stopslbl.isHidden = true
////            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"),for: .normal)
////        }else {
////            reportMapView?.directionBtn.isHidden = false
////            reportMapView?.directionlbl.isHidden = false
////            if isStopsDrawn {
////                reportMapView?.stopsBtn.isHidden = false
////                reportMapView?.stopslbl.isHidden = false
////            }else {
////                reportMapView?.stopsBtn.isHidden = true
////                reportMapView?.stopslbl.isHidden = true
////            }
////            reportMapView?.changeMapTypeBtn.isHidden = false
////            reportMapView?.changeMapTypelbl.isHidden = false
////            reportMapView?.optionButton.setImage(#imageLiteral(resourceName: "Asset 148-1"),for: .normal)
////        }
////    }
////    @objc func changeMapTypeBtnAction(sender:UIButton){
////        if sender.currentImage == #imageLiteral(resourceName: "Asset 67") {
////            reportMapView?.mapView.mapType = .satellite
////            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 66"), for: .normal)
////            reportMapView?.changeMapTypelbl.text = "Normal Map".toLocalize
////        } else {
////            reportMapView?.mapView.mapType = .normal
////            reportMapView?.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
////            reportMapView?.changeMapTypelbl.text = "Satellite Map".toLocalize
////        }
////    }
////    @objc func directionCall(sender:UIButton){
////        if sender.currentImage == #imageLiteral(resourceName: "Asset 93") {
////            for item  in directionMarkerArray {
////                item.map = nil
////            }
////            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93 copy"), for: .normal)
////            reportMapView?.directionlbl.text = "Show Directions".toLocalize
////        } else {
////            for item  in directionMarkerArray {
////                item.map = reportMapView?.mapView
////            }
////            reportMapView?.directionBtn.setImage(#imageLiteral(resourceName: "Asset 93"), for: .normal)
////            reportMapView?.directionlbl.text = "Hide Directions".toLocalize
////        }
////    }
////    @objc func stopsCall(sender:UIButton){
////        if sender.currentImage == #imageLiteral(resourceName: "Asset 94") {
////            for item  in stopMarkerArray {
////                item.map = nil
////            }
////
////            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94 copy") ,for: .normal)
////            reportMapView?.stopslbl.text = "Show Stops".toLocalize
////        } else {
////            for item  in stopMarkerArray {
////                item.map = reportMapView?.mapView
////            }
////            reportMapView?.stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94"), for: .normal)
////            reportMapView?.stopslbl.text = "Hide Stops".toLocalize
////        }
////    }
////    func updateMap() -> Void {
////
////        switch reportType {
////        case 0:
////            plotMarkerOnMap(location: CLLocation(latitude: Double(stopsReportData.latitude!)!, longitude: Double(stopsReportData.longitude!)!).coordinate)
////            reportMapView?.playLeftButton.isHidden = true
////        case 1:
////            reportMapView?.vehiclenameLabel.text = tripsReportData.deviceName!
////            let startDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
////            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
////            reportMapView?.dateLabel.text = dateLabel
////            getPath(deviceId: Int(tripsReportData.deviceId!)!, from: tripsReportData.startTime!, to: tripsReportData.endTime!)
////        case 2:
////            reportMapView?.vehiclenameLabel.text = summaryReportData.deviceName!
////            let startDate = RCGlobals.getDateChinaToLocalFromString((summaryReportData.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
////            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
////            reportMapView?.dateLabel.text = dateLabel
////            getPath(deviceId: Int(summaryReportData.deviceId!)!, from: summaryReportData.startTime!, to: summaryReportData.endTime!)
////        default:
////            break;
////        }
////    }
////    @objc func didTapReplayButton(sender:UIButton){
////
////        let coordinates = GMSMutablePath()
////       // reportMapView?.playRightButton.isHidden = false
////
////        for coordinate in coordinateArray {
////            coordinates.add(coordinate)
////        }
////
////        if sender.currentImage == #imageLiteral(resourceName: "singlePlayicon") {
////            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
////            if pathMarker == nil{
////                addPathMarker()
////            }
////
////            coordinates.removeAllCoordinates()
////            for (index, coordinate) in coordinateArray.enumerated() {
////                if index >= animateIndex {
////                    coordinates.add(coordinate)
////                    print(coordinate.latitude)
////                }
////            }
////            pathMarker.userData = CoordinatesCollection(path:coordinates)
////
////            let gmsPathSlider = GMSMutablePath()
////            for cordinate in self.coordinateArray[0...animateIndex] {
////                gmsPathSlider.add(cordinate)
////            }
////
////            totalDistance = GMSGeometryLength(gmsPathSlider)
////
////            animate(toNextCoordinate: pathMarker)
////
////        }else{
////            sender.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
////            sender.imageView?.contentMode = .scaleAspectFit
////           // reportMapView?.playRightButton.isHidden = false
////            coordinates.removeAllCoordinates()
////            for (index, coordinate) in coordinateArray.enumerated() {
////                if index >= animateIndex {
////                    coordinates.add(coordinate)
////                }
////            }
////
////            totalDistance = GMSGeometryLength(coordinates)
////        }
////    }
////
////    func addPathMarker() {
////
////        let coordinates = GMSMutablePath()
////        // reportMapView?.playRightButton.isHidden = false
////
////         for coordinate in coordinateArray {
////             coordinates.add(coordinate)
////         }
////
////        pathMarker = GMSMarker(position:coordinates.coordinate(at:UInt(animateIndex)))
////        switch markerType {
////        case 0:
////            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
////                pathMarker.icon = image
////            } else {
////                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
////            }
////            break
////
////        case 1:
////            if let image = (RCDataManager.get(objectforKey: "ActiveTruck") as? UIImage)?.resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default) {
////                pathMarker.icon = image
////            } else {
////                pathMarker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default)
////            }
////            break
////
////        case 2:
////            if let image = (RCDataManager.get(objectforKey: "ActiveBike") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
////                pathMarker.icon = image
////            } else {
////                pathMarker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
////            }
////
////            break
////
////        case 3,6,7,5,8:
////            pathMarker.icon = #imageLiteral(resourceName: "car-icon-2")
////            pathMarker.rotation = 0
////            break
////
////        default:
////            if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
////                pathMarker.icon = image
////            } else {
////                pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
////            }
////            break
////        }
////        let keyValue = "Device_" + "\(selectedDeviceId)"
////        let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
////        //                var selectedvehiclename = selDevice?.name ?? ""
////
////
////        // pathMarker.title = selDevice?.name
////        pathMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
////        pathMarker.isFlat = true
////        pathMarker.map = reportMapView?.mapView
////        pathMarker.userData = CoordinatesCollection(path:coordinates)
////    }
////
////    @objc func sliderValueDidChange(_ sender:UISlider!) {
////
////        animateIndex = Int(sender.value)
////
////        if animateIndex == 0 {
////            totalDistance = 0
////        }
////
////        if pathMarker == nil{
////            addPathMarker()
////        }
////
////        let gmsPathSlider = GMSMutablePath()
////        for cordinate in self.coordinateArray[0...animateIndex] {
////            gmsPathSlider.add(cordinate)
////        }
////
////        let markerLocation = locationArray[animateIndex]
////        let speed = RCGlobals.convertSpeedInt(speed: Float(markerLocation.speed))//changes l to L
////        self.reportMapView?.showSpeedLabel.text = speed
////        self.pathMarker.position = markerLocation.coordinate
////        let time = markerLocation.timestamp
////        let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
////        reportMapView?.datecalenderLabel.text = timestring
////        let currentDistance = GMSGeometryLength(gmsPathSlider)
////        totalDistance = currentDistance
////        reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000)
////
////        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
////
////    }
////
////    func getPath(deviceId: Int, from: String, to: String){
////
////        RCLocalAPIManager.shared.getReportPath(with: deviceId, fromDate: from, toDate: to, success: { [weak self] hash in
////            guard self != nil else {
////                return
////            }
////            var coordinateArray:[CLLocationCoordinate2D] = []
////            var idleTime = "0"
////            var prevLocation: CLLocation? = nil
////            for path in hash.data! {
////                let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromStringWithFormat(path.fixtime ?? "", "yyyy-MM-dd HH:mm:ssZ"))
////
////                if prevLocation == nil {
////                    prevLocation = location
////               idleTime = path.fixtime!
////                    continue
////                }
////
////                if location.distance(from: prevLocation!) > 0 {
////                    let first =  RCGlobals.getDateFromString(idleTime)
////                    let second =  RCGlobals.getDateFromString(path.fixtime!)
////
////                    let dif =   RCGlobals.getDateDiff(start: first, end:second)
////                    print(dif)
////                    let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
////                    if dif > ( stopDuration * 60 ) {
////                        let intervalStart = RCGlobals.convertUTCToIST(idleTime, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")
////
////                        let intervalEnd = RCGlobals.convertUTCToIST(path.fixtime!, "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy '@' hh:mm a")
////
////                        self!.idleIntervalArray.append("\(intervalStart) - \(intervalEnd)")
////                        // append time diff
////                        self!.idleTimeDifferenceArray.append(dif)
////                        // append location
////                        self!.StopsLocationArray.append(prevLocation!)
////                        // append coordinate
////                        self!.StopsCoordinateArray.append(prevLocation!.coordinate)
////
////                    }
////                    idleTime = path.fixtime!
////                }
////
////                self?.locationArray.append(location)
////                prevLocation = location
////                coordinateArray.append(location.coordinate)
////                self?.directionCounter += 1
////                if (self?.directionCounter ?? 0) % 20 == 0 {
////                self?.plotDirectionMarker(location:location)
////                }
////            }
////            if self!.StopsCoordinateArray.count > 0 {
////                Defaults().set(true, for: Key<Bool>("isShowStops"))
////            }else {
////                Defaults().set(false, for: Key<Bool>("isShowStops"))
////            }
////            self?.reportMapView?.timeSlider.minimumValue = 0
////            let sliderMaxValue = Float(coordinateArray.count)
////            self?.reportMapView?.timeSlider.maximumValue =  (sliderMaxValue > 0) ? Float(sliderMaxValue - 1) : 0
////            self?.plotPathOnMap(points:(self?.locationArray)!, coordinateArray:coordinateArray)
////            self?.plotImageMarkerOnMap()
////            self?.plotStopMarkersOnMap(coordinateArray: self!.StopsCoordinateArray, diffArray: (self?.idleTimeDifferenceArray)!)
////
////        }) { [weak self] message in
////            guard let weakSelf = self else {
////                return
////            }
////            weakSelf.prompt("please try again")
////            print(message)
////        }
////
////    }
////    func plotDirectionMarker(location:CLLocation){
////        let directionMarker = GMSMarker(position: location.coordinate)
////        directionMarker.rotation = location.course
////        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "direction-arrow")!, deg: 180)
////        directionMarker.icon = img.resizedImage(CGSize(width: 15, height: 20), interpolationQuality: .default)
////        directionMarker.map = reportMapView?.mapView
////        directionMarker.title = "Direction"
////        directionMarkerArray.append(directionMarker)
////    }
////    func plotStopMarkersOnMap(coordinateArray:[CLLocationCoordinate2D] , diffArray:[Int]) -> Void {
////        if coordinateArray.count > 0 {
////            for index in 1...coordinateArray.count {
////                let position = coordinateArray[index-1]
////                let diff = diffArray[index-1]
////                let stopMarker:GMSMarker = GMSMarker(position: position)
////                stopMarker.map = reportMapView?.mapView
////
////                let timeDiff = RCGlobals.secondsToHoursMinutesSeconds(diff)
////
////                let timeGapInHrs:Int = timeDiff.0
////                let timeGapInMins:Int = timeDiff.1
////
////                var hrString:String = ""
////                var minString:String = ""
////
////                if timeGapInHrs > 1 {
////                    hrString = "\(timeGapInHrs) Hr"
////                } else {
////                    hrString = "\(timeGapInHrs) Hrs"
////                }
////
////                if timeGapInMins > 1 {
////                    minString = "\(timeGapInMins) min"
////                } else {
////                    minString = "\(timeGapInMins) mins"
////                }
////
////                let idleTime = "\(hrString) \(minString)"
////
////                let markerImage = RCGlobals.textToImage(text: idleTime, inImage: UIImage(named:"ic_idle_marker")!, atPoint: CGPoint(x: 15, y: 15))
////                stopMarker.icon = markerImage.resizedImage(CGSize(width: 65, height: 51), interpolationQuality: .default)
////
////                stopMarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
////                stopMarker.tracksInfoWindowChanges = true
////                stopMarker.snippet = ""
////                let interval = idleIntervalArray[index-1]
////                stopMarker.userData = interval
////                stopMarkerArray.append(stopMarker)
////            }
////        }
////
////    }
////
////    func plotImageMarkerOnMap() {
////        for markerModel in markerImages {
////            let coordinates = CLLocationCoordinate2D(latitude: markerModel.deviceLat!, longitude: markerModel.deviceLng!)
////            let imageMarker = GMSMarker(position: coordinates)
////            imageMarker.map = reportMapView?.mapView
////            imageMarker.icon = #imageLiteral(resourceName: "ic_camera_icon").resizedImage(CGSize.init(width: 35, height: 48), interpolationQuality: .default)
////            imageMarker.title = "Image_Title"
////
////            let encoder = JSONEncoder()
////            encoder.outputFormatting = .prettyPrinted
////
////            do {
////                let jsonData = try encoder.encode(markerModel)
////
////                if let jsonString = String(data: jsonData, encoding: .utf8) {
////                    print(jsonString)
////                    imageMarker.snippet = jsonString
////                }
////            } catch {
////                print(error.localizedDescription)
////            }
////        }
////    }
////
////    func plotMarkerOnMap(location: CLLocationCoordinate2D) -> Void {
////
////        //  reportMapView?.replayButton.isHidden = true
////
////        startmarker = GMSMarker(position: location)
////        startmarker.map = reportMapView?.mapView
////        startmarker.icon = GMSMarker.markerImage(with:.red)
////        startmarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
////        startmarker.snippet = stopsReportData.address ?? "No address"
////
////        coordinateArray.append(location)
////        fitMapToBounds(coordinates:coordinateArray)
////    }
////
////    func plotPathOnMap(points:[CLLocation],coordinateArray:[CLLocationCoordinate2D]) -> Void {
////        let _ = RCPolyLine().drawpolyLineFrom(points: coordinateArray,color: UIColor.blue,title: "", map: (reportMapView?.mapView)!)
////        if coordinateArray.count == 0 {
////            reportMapView?.speedsMeterView.isUserInteractionEnabled = false
////            reportMapView?.speedsMeterView.alpha = 0.5
////            reportMapView?.upperView.isUserInteractionEnabled = false
////            reportMapView?.upperView.alpha = 0.5
////            self.view.makeToast("no data found", duration: 2.0, position: ToastPosition.bottom)
////            return
////        }
////        startmarker = GMSMarker(position:coordinateArray.first!)
////        startmarker.map = reportMapView?.mapView
////        startmarker.icon = GMSMarker.markerImage(with:.green)
////        startmarker.title = NSLocalizedString("Start Location", comment: "Start Location")
////
////        //        startmarker.snippet =   RCGlobals.getFormattedData(date:(pathData.first?.tstamp)!)
////
////        endMarker = GMSMarker(position:coordinateArray.last!)
////        endMarker.map = reportMapView?.mapView
////        endMarker.icon = GMSMarker.markerImage(with:.red)
////        endMarker.title = NSLocalizedString("End Location", comment: "End Location")
////
////
////        switch reportType {
////        case 1:
////            if let tripData = tripsReportData {
//////                startmarker.title = "Start time: \(tripData.startTime ?? "") \n" + "Start Address: \(tripData.startAddress ?? "")"
//////                endMarker.title = "End time: \(tripData.endTime ?? "") \n" + "End Address: \(tripData.endAddress ?? "")"
////                let startDate = RCGlobals.convertUTCToIST(tripData.startTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
////                let endDate = RCGlobals.convertUTCToIST(tripData.endTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
////                startmarker.title = "Start time: \(startDate) \n" + "Start Address: \(tripData.startAddress ?? "")"
////                endMarker.title = "End time: \(endDate) \n" + "End Address: \(tripData.endAddress ?? "")"
////            }
////
////        case 2:
////           if startmarker != nil && endMarker != nil{
//////                startmarker.snippet = "Start time: \(summaryReportData.startTime ?? "") \n" + "Start Address: \(summaryReportData.startAddress ?? "")"
//////                endMarker.snippet = "End time: \(summaryReportData.endTime ?? "") \n" + "End Address: \(summaryReportData.endAddress ?? "")"
////            let startDate = RCGlobals.convertUTCToIST(summaryReportData.startTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
////            let endDate = RCGlobals.convertUTCToIST(summaryReportData.endTime ?? "", "yyyy-MM-dd HH:mm:ss", "MMM dd, yyyy'@'hh:mm a")
////            startmarker.snippet = "Start time: \(startDate) \n" + "Start Address: \(summaryReportData.startAddress ?? "")"
////            endMarker.snippet = "End time: \(endDate) \n" + "End Address: \(summaryReportData.endAddress ?? "")"
////            }
////        default:
////            break
////        }
////        //        endMarker.snippet =   RCGlobals.getFormattedData(date:(pathData.last?.tstamp)!)
////        fitMapToBounds(coordinates:coordinateArray)
////    }
////
////    func fitMapToBounds(coordinates:[CLLocationCoordinate2D]) -> Void {
////        coordinateArray = coordinates
////        DispatchQueue.main.async(execute: {() -> Void in
////            var bounds = GMSCoordinateBounds(coordinate:coordinates.first!, coordinate:coordinates.last!)
////            for marker in coordinates {
////                bounds = bounds.includingCoordinate(marker)
////            }
////            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding:20)
////            self.reportMapView?.mapView.animate(with:cameraUpdate)
////        })
////    }
////
////
////
////    @objc func didTapFastForwardButton(sender:UIButton) {
////        replaySpeed = replaySpeed + 1
////        if replaySpeed > 4
////        {
////            replaySpeed = 1
////        }
////        let speed = String(format: "%.0f", (replaySpeed))
////        reportMapView?.replayspeed.text = speed + "x"
////    }
////    func animate(toNextCoordinate marker: GMSMarker) {
////        if animateIndex >= coordinateArray.count {
////            self.animateIndex = 0
////            self.reportMapView?.showSpeedLabel.text = "0"
////            self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
////            self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
////            self.reportMapView?.currentkmLabel.text = ""
////            self.reportMapView?.datecalenderLabel.text = ""
////            self.reportMapView?.timeSlider.value = 0
////            totalDistance = 0
////            return
////        }
////        let coordinates: CoordinatesCollection? = marker.userData as? CoordinatesCollection
////        let coord: CLLocationCoordinate2D? = coordinates?.next()
////        let previous: CLLocationCoordinate2D = marker.position
////        let heading: CLLocationDirection = GMSGeometryHeading(previous, coord!)
////        let distance: CLLocationDistance = GMSGeometryDistance(previous, coord!)
////        // Use CATransaction to set a custom duration for this animation. By default, changes to the
////        // position are already animated, but with a very short default duration. When the animation is
////        // complete, trigger another animation step.
////        CATransaction.begin()
////        let animationSpeed:Double = 3 * (replaySpeed * 100)
////        CATransaction.setAnimationDuration((distance / animationSpeed))
////        // custom duration, 5km/sec
////
////        if locationArray.count > 0 {
////            CATransaction.setCompletionBlock({() -> Void in
////                let gmsPathSlider = GMSMutablePath()
////                for cordinate in self.coordinateArray[0...self.animateIndex] {
////                    gmsPathSlider.add(cordinate)
////                }
////                // speed:-
////                let speed = RCGlobals.convertSpeedInt(speed: Float(self.locationArray[self.animateIndex].speed))
////                self.reportMapView?.showSpeedLabel.text = speed
////                //   :- time
////                let time = self.locationArray[self.animateIndex].timestamp
////                let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
////            //   let timestring = RCGlobals.convertUTCToIST(self.completePath[self.animateIndex].fixtime ?? "", "yyyy-MM-dd HH:mm:ss'+'SS", "hh:mm a")
////                self.reportMapView?.datecalenderLabel.text = timestring
////                // :- current distance
////                let currentDistance = GMSGeometryLength(gmsPathSlider)
////                self.reportMapView?.currentkmLabel.text = String(format: "%.2f", currentDistance/1000) + "Km"
////                //:-slider
////                self.reportMapView?.timeSlider.value = Float(self.animateIndex)
////
////                if self.coordinateArray.last?.latitude == coord?.latitude && self.coordinateArray.last?.longitude
////                    == coord?.longitude {
////                    //that means we have the last animation here
////                    //we have to stop the recursive calls here
////                    //change the button title if not changed
////                    marker.map = nil
////                    if (self.reportMapView?.playLeftButton.currentImage == #imageLiteral(resourceName: "pause")) {
////                        self.animateIndex = 0
////                        self.reportMapView?.showSpeedLabel.text = "0"
////                     //   self.reportMapView?.playRightButton.isHidden = true
////                        self.reportMapView?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
////                        self.reportMapView?.playLeftButton.imageView?.contentMode = .scaleAspectFit
////                        self.pathMarker = nil
////                    }
////
////
////                }
////                else {
////
////                    if self.reportMapView?.playLeftButton.currentImage != #imageLiteral(resourceName: "singlePlayicon") {
////                        //add a recursive call here to animate the markers
////                        self.animateIndex += 1
////                        self.animate(toNextCoordinate: marker)
////                    }
////                }
////            })
////        }else{
////            self.prompt("Check your internet connection".toLocalize)
////        }
////
////
////        marker.position = coord!
////        CATransaction.commit()
////        // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
////        if marker.isFlat {
////            marker.rotation = heading
////        }
////    }
////
////    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
////
////        if  marker.title == "Image_Title" {
////            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
////            view.backgroundColor = UIColor.black
////            view.layer.cornerRadius = 8
////            view.alpha = 0.6
////
////            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
////            lbl1.textColor = UIColor.white
////            lbl1.textAlignment = .center
////            lbl1.font = UIFont.systemFont(ofSize: 13, weight: .bold)
////            lbl1.adjustsFontForContentSizeCategory = true
////            lbl1.adjustsFontSizeToFitWidth = true
////
////            let lbl2 = UILabel(frame: CGRect.zero)
////            lbl2.textColor = UIColor.white
////            lbl2.textAlignment = .center
////            lbl2.font = UIFont.systemFont(ofSize: 13, weight: .bold)
////            lbl2.adjustsFontForContentSizeCategory = true
////            //            lbl2.adjustsFontSizeToFitWidth = true
////            lbl2.layer.cornerRadius = 4
////            lbl2.layer.masksToBounds = true
////            lbl2.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
////
////            if let jsonData = marker.snippet!.data(using: .utf8)
////            {
////                let decoder = JSONDecoder()
////
////                do {
////                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
////                    lbl1.text = markerModel.title
////                    lbl2.text = "\(markerModel.imagePathList?.count ?? 0) photos"
////                } catch {
////                    print(error.localizedDescription)
////                }
////            }
////
////            view.addSubview(lbl1)
////            view.addSubview(lbl2)
////
////            lbl2.snp.makeConstraints{(make) in
////                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
////                make.centerX.equalToSuperview()
////                make.width.equalTo(0.2 * kscreenwidth)
////            }
////
////            return view
////        } else if marker.title == "Stop Location" {
////            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 120))
////            view.backgroundColor = UIColor.white
////            view.layer.cornerRadius = 2
////
////            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 35))
////            lbl1.textColor = UIColor.appGreen
////            lbl1.textAlignment = .center
////            lbl1.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
////            lbl1.numberOfLines = 2
////
////            let lbl2 = UILabel(frame: CGRect.zero)
////            lbl2.textColor = UIColor.darkGray
////            lbl2.textAlignment = .center
////            lbl2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
////            lbl2.numberOfLines = 4
////
////            let time = marker.userData ?? ""
////
////            lbl1.text = time as? String
////
////            var addressText: String = ""
////
////            let geocoder = GMSGeocoder()
////            geocoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
////                guard let address = response?.firstResult(), let lines = address.lines else { return }
////                addressText = lines.joined(separator: " ")
////                print(addressText)
////                lbl2.text = addressText
////            }
////
////            view.addSubview(lbl1)
////            view.addSubview(lbl2)
////
////            lbl2.snp.makeConstraints{(make) in
////                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
////                make.centerX.equalToSuperview()
////                make.width.equalToSuperview().multipliedBy(0.9)
////                make.height.equalToSuperview().multipliedBy(0.6)
////            }
////
////            return view
////
////
////        }  else {
////            return nil
////        }
////    }
////
////    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
////        if  marker.title == "Image_Title" {
////            if let jsonData = marker.snippet!.data(using: .utf8)
////            {
////                let decoder = JSONDecoder()
////
////                do {
////                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
////                    Defaults().set(markerModel, for: Key<MarkerFirebaseModel> ("particularMarkerInfo"))
////                    let markerphotoVC = MarkerPhotoViewController()
////                    let controller = UINavigationController(rootViewController: markerphotoVC)
////                    self.present(controller, animated: true, completion: nil)
////                } catch {
////                    print(error.localizedDescription)
////                }
////            }
////        }
////    }
////}
////
////
////
