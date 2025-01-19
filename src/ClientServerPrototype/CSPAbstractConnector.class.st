Class {
	#name : 'CSPAbstractConnector',
	#superclass : 'Object',
	#instVars : [
		'zmqSocket',
		'url',
		'service',
		'delay'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'accessing' }
CSPAbstractConnector class >> new [

	^ self error: 'You should not use me'
]

{ #category : 'accessing' }
CSPAbstractConnector class >> reset [

	uniqueInstance ifNotNil: [ uniqueInstance stop ].
	uniqueInstance := nil.
]

{ #category : 'accessing' }
CSPAbstractConnector class >> uniqueInstance [ 

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize; yourself ]
]

{ #category : 'accessing' }
CSPAbstractConnector >> delay [
	^ delay
]

{ #category : 'operations' }
CSPAbstractConnector >> delay: aValue [

	delay := aValue.
	self isRunning ifTrue: [ service stepDelay: delay ]	
]

{ #category : 'initialization' }
CSPAbstractConnector >> initialize [

	super initialize.
	url := 'tcp://127.0.0.1:31001' asZnUrl.
	delay := 500 milliSeconds.
	
]

{ #category : 'accessing' }
CSPAbstractConnector >> isRunning [

	^ zmqSocket isNotNil and: [ zmqSocket isNull not ]
]

{ #category : 'operations' }
CSPAbstractConnector >> start [

	^ self subclassResponsibility 
]

{ #category : 'operations' }
CSPAbstractConnector >> stop [

	zmqSocket ifNotNil: [
		zmqSocket isNull ifFalse: [zmqSocket release].
		zmqSocket := nil		
	].

	service ifNotNil: [
		service stop.
		service := nil]
 
	

]

{ #category : 'accessing' }
CSPAbstractConnector >> url [

	^ url
]

{ #category : 'accessing' }
CSPAbstractConnector >> url: aValue [

	url := aValue
]
