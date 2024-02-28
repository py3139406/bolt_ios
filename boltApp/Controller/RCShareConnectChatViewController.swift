//
//  ViewController.swift
//  RCSwiftChat
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import Firebase
import DefaultsKit
import JSQMessagesViewController
import IQKeyboardManagerSwift

class RCShareConnectChatViewController: JSQMessagesViewController{

    private var usersReference : DatabaseReference!
    private var messagesReference : DatabaseReference!
    private var chatToken : String?
    private var followerToken : String?
    private var loginUser : LoginResponseModel!
    private var device : TrackerDevicesMapperModel!
    
    private var outgoingBubbleImageView : JSQMessagesBubbleImage!
    private var incomingBubbleImageView : JSQMessagesBubbleImage!
    private var messages : [JSQMessage] = []
    
    private var typing : Bool =  false
    // MARK :initializer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(reference:DatabaseReference!, senderID: String!, senderName: String!, token:String?) {
        self.init(nibName: nil, bundle: nil)

        senderId = senderID
        senderDisplayName = senderName
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = appDarkTheme
        view.frame = CGRect.zero
        
        followerToken = Defaults().get(for: Key<String>("ShareVehicleFollowerPin")) ?? ""
        
        if followerToken != "" {
            chatToken = followerToken
        }else {
            chatToken = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        }
        
        usersReference = Database.database().reference().child("bolt/rooms/\(chatToken ?? "")/users")
        messagesReference = Database.database().reference().child("bolt/rooms/\(chatToken ?? "")/messages")
        
        loginUser = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))
        device = Defaults().get(for: Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
        
        self.senderId = loginUser.data?.id
        self.senderDisplayName = loginUser.data?.name

        setUpAuthentication()
        setupData()
        if followerToken != "" {
//            addUser(type: "leader")
        } else {
            addUser(type: "leader")
        }
        observeMessages()
        observeTyping()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        typing = false
        showTypingIndicator = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        //do noting
    }
    
    
    func setUpAuthentication(){
        Auth.auth().signInAnonymously { (user, error) in
          
        }
    }

    private func setupData() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCollectionTap(_:)))
        tapRecognizer.delegate = self
        collectionView?.addGestureRecognizer(tapRecognizer)
        
        inputToolbar.contentView.leftBarButtonItem = nil;
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero;
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero;

        outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func observeMessages() -> Void {
        messagesReference.observe(.childAdded, with: { [weak self] (snapshot) in
            if let response = snapshot.value as AnyObject? {

                self?.addMessage(withID: response["senderID"] as! String, name: response["senderName"] as! String, text: response["text"] as! String, andDate: (self?.getDateFrom(response["messageTime"] as! String))!)
            }
            return
        })
    }
    
    private func addUser(type:String){
        if usersReference != nil {
            let userRoot : DatabaseReference = usersReference.child("\(loginUser.data?.id ?? "0")")
            
            let keyValuePos = "Position_" + "\(device.id ?? 0)"
            let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
            
            var user : [String: Any] = [:]
            user["name"] = loginUser.data?.name
            user["userId"] = loginUser.data?.id
            user["userType"] = type
            user["mobileNumber"] = device.phone
            user["isTyping"] = "\(false)"
            user["positionId"] = devPostition?.id ?? 0
            user["fixTime"] = devPostition?.fixTime ?? ""
            user["deviceId"] = device.id
            user["deviceName"] = device.name
            user["deviceType"] = device.category
            userRoot.setValue(user)
        }
    }
    
    private func observeTyping() -> Void {
//        usersReference.observe(.value, with: { [weak self] (snapshot) in
//            if snapshot.childrenCount > 0 && (self?.typing)! {
//                return
//            }
//            self?.showTypingIndicator = snapshot.childrenCount > 0
//            self?.scrollToBottom(animated: true)
//        })
        
        usersReference.observe(.value, with: {(snapshot) in
            var tempTyping: Bool = false
            if (snapshot.childrenCount > 0) {
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    guard let restDict = childSnapshot.value as? [String: Any] else { continue }
                    let userTyping = restDict["isTyping"] as? String
                    
                    if userTyping == "true" {
                        tempTyping = true
                        break
                    }else {
                        tempTyping = false
                    }
                }
            }
            self.showTypingIndicator = tempTyping
            self.scrollToBottom(animated: true)
            
        })
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.item].senderId == senderId {
            return outgoingBubbleImageView
        }
        return incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if messages[indexPath.item].senderId == senderId {
            return NSAttributedString(string: senderDisplayName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)])
        }
        return NSAttributedString(string: messages[indexPath.item].senderDisplayName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)])
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return NSAttributedString(string: timefy(date: messages[indexPath.item].date), attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)])
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 17
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    // MARK : UITextfield listener
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if !textView.text.isEmpty {
            typing = true
            send(typing: true)
            return
        }
        send(typing: false)
    }
    
    // MARK : Actions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
    //    RCClient.shared.send(message: text, token: chatToken)
        
        
        let itemReference = messagesReference.childByAutoId()
        itemReference.setValue(["senderID":senderId, "senderName":senderDisplayName, "text":text, "messageTime": getStringFrom(date)])

        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage(animated: true)
        
        send(typing: false)
        typing = false
    }
    
    @objc func handleCollectionTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if inputToolbar.contentView.textView.isFirstResponder {
                inputToolbar.contentView.textView.resignFirstResponder()
            }
        }
    }
    
    // MARK: Private methods
    
    private func addMessage(withID ID: String, name: String, text: String, andDate messageDate: Date) {
        messages.append(JSQMessage(senderId: ID, senderDisplayName: name, date: messageDate, text: text))
        finishReceivingMessage()
    }
    
    private func send(typing:Bool) -> Void {
        let userRoot : DatabaseReference = usersReference.child("\(loginUser.data?.id ?? "0")")
        
        if typing {
            userRoot.updateChildValues(["isTyping": "\(true)"])
        } else {
            userRoot.updateChildValues(["isTyping": "\(false)"])
        }
    }
    
    private func send(message:JSQMessage) -> Void {
        messagesReference.childByAutoId().setValue(messeagify(message: message))
    }
    
    // MARK: Helpers
    
    private func timefy(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: date)
    }
    
    private func messeagify(message:JSQMessage) -> [String : String] {
        return ["senderID":message.senderId, "senderName":message.senderDisplayName, "text":message.text, "messageTime": getStringFrom(message.date)]
    }
    
    private func getStringFrom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let formattedDate: String = dateFormatter.string(from: date)
        return formattedDate
    }
    
    private func getDateFrom(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        return formattedDate!
    }
    
    deinit {
        messagesReference.removeAllObservers()
        usersReference.removeAllObservers()
    }
}


extension RCShareConnectChatViewController: UIGestureRecognizerDelegate {
    // MARK : UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}




