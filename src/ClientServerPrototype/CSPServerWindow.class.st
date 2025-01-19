Class {
	#name : 'CSPServerWindow',
	#superclass : 'CSPAbstractWindow',
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'initialization - elements' }
CSPServerWindow >> createServerInfo [
	
	^ ToElement new
			layout: BlLinearLayout vertical;
			hMatchParent;
			vFitContent;
			addChild: (self addTextInput: #serverUrl withLabel: 'Server URL');
			addChild: (self addLabel: #errorLabelAddress );
			addChild: (self addTextInput: #serverDelay withLabel: 'Server Delay');
			addChild: (self addLabel: #errorLabelDelay );
			addChild: (self addTextInput: #numberOfMessages withLabel: 'Messages Sent')
			yourself
]

{ #category : 'operations' }
CSPServerWindow >> doReset [
	
	CSPServer reset.
	self updateData.
]

{ #category : 'operations' }
CSPServerWindow >> doStart [
	
	self server start.
	self server whenMessageSendDo: [ self space ifNotNil:[ :space | space universe defer: [self updateData] ]].
	self updateData.
]

{ #category : 'operations' }
CSPServerWindow >> doStop [
	
	self server stop.
	self server whenMessageSendDo: [].
	self updateData.
]

{ #category : 'operations' }
CSPServerWindow >> ensureStopped [
	
	self server stop
]

{ #category : 'accessing' }
CSPServerWindow >> initialExtent [

	^ 800@190
]

{ #category : 'initialization' }
CSPServerWindow >> initialize [

	super initialize.

	self addChild: (self createServerInfo).
	self addChild: (self createButtons).
	
	self registerEvents.		
	self updateData.
]

{ #category : 'initialization - elements' }
CSPServerWindow >> registerEvents [

	self serverUrl whenSaveRequestedDo: [ :req | self updateServerUrl: req ].
	self serverDelay whenSaveRequestedDo: [ :req | self updateServerDelay: req ].

	self stopButton whenClickedDo: [ self doStop ].
	self startButton whenClickedDo: [ self doStart ].	
	self resetButton whenClickedDo: [ self doReset ]
]

{ #category : 'accessing' }
CSPServerWindow >> server [
	
	^ CSPServer uniqueInstance 
]

{ #category : 'accessing' }
CSPServerWindow >> serverDelay [

	^ self childWithId: #serverDelay
]

{ #category : 'accessing' }
CSPServerWindow >> serverUrl [

	^ self childWithId: #serverUrl
]

{ #category : 'private - updating' }
CSPServerWindow >> updateData [
	
	self serverUrl text: (self server url) printString asRopedText.
	self serverUrl disabled: (self server isRunning).

	((self serverDelay text asString ~= (self server delay) printString) and: [ self serverDelay edited not])
		ifTrue: [ self serverDelay text: (self server delay) printString asRopedText].	

	self numberOfMessages 
		text: (self server messagesSent) printString asRopedText;
		enabled: false.
		
	self startButton disabled: (self server isRunning).
	self stopButton disabled: (self server isRunning) not.	
]

{ #category : 'private - updating' }
CSPServerWindow >> updateServerDelay: request [

	[
		| delay |
		delay := self serverDelay text asString asDuration.
		self server delay: delay.
		request accepted: true.
		self errorLabelDelay text: '' asRopedText ] 
	onErrorDo: [ :e |
			self errorLabelDelay text: e messageText asRopedText ]
]

{ #category : 'private - updating' }
CSPServerWindow >> updateServerUrl: request [

	[
		| url |
		url := self serverUrl text asString asZnUrl.
		self server url: url.
		request accepted: true.
		self errorLabelAddress text: '' asRopedText ] 
	onErrorDo: [ :e |
			self errorLabelAddress text: e messageText asRopedText ]
]
