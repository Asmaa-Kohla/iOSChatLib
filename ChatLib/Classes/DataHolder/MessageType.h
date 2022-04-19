//
//  MessageType.h
//  iOSChat
//
//  Created by Asmaa Kohla on 2/9/20.
//

typedef enum {
    kTextMessage,
    kLinkMessage,
    kImageMessage,
    kVoiceMessage,
    kVideoMessage,
    kDeletedMessage,
    kMissedAudioCallMessage,
    kCompleteAudioCallMessage
} MessageType;
