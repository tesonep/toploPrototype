Class {
	#name : 'CSPServer',
	#superclass : 'CSPAbstractConnector',
	#instVars : [
		'whenMessageSendDo',
		'messagesSent'
	],
	#pools : [
		'ZMQConstants'
	],
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'operations' }
CSPServer >> doStep [

	zmqSocket send: 'test 1234'.
	messagesSent := messagesSent + 1.
	whenMessageSendDo value.
]

{ #category : 'initialization' }
CSPServer >> initialize [

	super initialize.
	whenMessageSendDo := [].
	messagesSent := 0.
]

{ #category : 'accessing' }
CSPServer >> messagesSent [

	^ messagesSent
]

{ #category : 'accessing' }
CSPServer >> messagesSent: anObject [

	messagesSent := anObject
]

{ #category : 'operations' }
CSPServer >> start [

	self isRunning ifTrue: [ ^ self ].
	
	zmqSocket := ZMQSocket bind: self url asString type: ZMQ_PUB.
	service := TKTParameterizableService new
		name: 'CSPServer';
		step: [self doStep];
		stepDelay: delay;
		priority: Processor lowIOPriority;
		start;
		yourself.

]

{ #category : 'enumerating' }
CSPServer >> whenMessageSendDo: aBlock [

	whenMessageSendDo := aBlock
	
]
