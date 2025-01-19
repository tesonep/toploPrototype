Class {
	#name : 'CSPClient',
	#superclass : 'CSPAbstractConnector',
	#instVars : [
		'whenMessageReceivedDo',
		'messagesReceived'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'api - running' }
CSPClient >> doStep [

	"Receive up to a thousand messages"
	| currentReceived msg |
	currentReceived := 0.
	
	[
		msg := (zmqSocket receiveMsgDontWait) first.
		currentReceived := currentReceived + 1.
		currentReceived = 1000 or: [msg isEmpty]] whileFalse.

	messagesReceived := messagesReceived + currentReceived - 1.
	whenMessageReceivedDo value.
]

{ #category : 'initialization' }
CSPClient >> initialize [

	super initialize.
	whenMessageReceivedDo := [].
	messagesReceived := 0.
]

{ #category : 'accessing' }
CSPClient >> messagesReceived [

	^ messagesReceived
]

{ #category : 'accessing' }
CSPClient >> messagesReceived: anObject [

	messagesReceived := anObject
]

{ #category : 'initialization' }
CSPClient >> start [

	| urlString |
	self isRunning ifTrue: [ ^ self ].

	urlString := self url asString.
	urlString last = $/ ifTrue: [ urlString := urlString allButLast ].
	
	zmqSocket := ZMQSocket new: ZMQ_SUB.
	zmqSocket connect: urlString.
	zmqSocket optionKey: 6 "ZMQ_SUBSCRIBE" optValue: 'test'.

	service := TKTParameterizableService new
		name: 'CSPClient';
		step: [self doStep];
		stepDelay: delay;
		priority: Processor lowIOPriority;
		start;
		yourself.

]

{ #category : 'accessing' }
CSPClient >> whenMessageReceivedDo [

	^ whenMessageReceivedDo
]

{ #category : 'accessing' }
CSPClient >> whenMessageReceivedDo: anObject [

	whenMessageReceivedDo := anObject
]
