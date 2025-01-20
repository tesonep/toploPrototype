Class {
	#name : 'CSPClientWindow',
	#superclass : 'CSPAbstractWindow',
	#instVars : [
		'useCompositionLayer',
		'hasSpinner'
	],
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'accessing' }
CSPClientWindow >> client [
	
	^ CSPClient uniqueInstance
]

{ #category : 'accessing' }
CSPClientWindow >> clientDelay [

	^ self childWithId: #clientDelay
]

{ #category : 'accessing' }
CSPClientWindow >> clientUrl [

	^ self childWithId: #clientUrl
]

{ #category : 'testing' }
CSPClientWindow >> closed [
	
	
]

{ #category : 'accessing' }
CSPClientWindow >> container [

	^ self childWithId: #container
]

{ #category : 'accessing' }
CSPClientWindow >> content [

	^ self childWithId: #content
]

{ #category : 'initialization - elements' }
CSPClientWindow >> createChildElement [

	| element |
	element := BlElement new
		  background: Color random;
		  height: 50;
		  width: 50;
		  yourself.

	element layout: (BlGridLayout new columnCount: 10).
	element layout cellSpacing: 0.
	
	element addChildren: ((1 to: 100) collect: [ :i | 
			BlElement new
					  background: Color random;
					  height: 5;
					  width: 5;
					  yourself ]).
		
	^ element
	
]

{ #category : 'initialization - elements' }
CSPClientWindow >> createClientInfo [
	
	^ ToElement new
			layout: BlLinearLayout vertical;
			hMatchParent;
			vFitContent;
			addChild: (self addTextInput: #clientUrl withLabel: 'Client URL');
			addChild: (self addLabel: #errorLabelAddress );
			addChild: (self addTextInput: #clientDelay withLabel: 'Client Delay');
			addChild: (self addLabel: #errorLabelDelay );
			addChild: (self addTextInput: #numberOfMessages withLabel: 'Messages')
			yourself
]

{ #category : 'initialization - elements' }
CSPClientWindow >> createComplexElement [

	| content container |

	container := BlElement new.
	container constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	content := BlElement new.
	content layout: (BlGridLayout new columnCount: 16).
	content layout cellSpacing: 3.
	content constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	300 timesRepeat: [
		content addChild: (self createChildElement) ].

	container addChild: content as: #content.
	^ container	

]

{ #category : 'initialization - elements' }
CSPClientWindow >> createControls [
	
	^ ToElement new
		layout: BlLinearLayout vertical;
		vFitContent;
		hMatchParent;
		addChild: (self addTextInput: #fpsText withLabel: 'FPS:');
		addChild: (self addCheckbox: #hasSpinnerCheckbox withLabel: 'Has Spinner Layover?');
		addChild: (self addCheckbox: #useCompositionLaterCheckbox withLabel: 'Use Composition Layers?');
		
		yourself
]

{ #category : 'operations' }
CSPClientWindow >> doAddOrRemoveSpinner [

	hasSpinner 
		ifTrue: [ self doAddSpinner ]
		ifFalse: [ self doRemoveSpinner ]

]

{ #category : 'operations' }
CSPClientWindow >> doAddSpinner [

	| transparent spinner |
	
	self layoverSpinner ifNotNil: [ ^ self ].
	
	spinner := BlElement new.
	spinner constraintsDo: [ :c | 
		c frame vertical alignCenter.
		c frame horizontal alignCenter ].
	spinner height: 50.
	spinner width: 50.
	spinner background: Color blue.
	
	spinner addAnimation: ((BlTransformAnimation rotate: 180)
		              duration: 0.5 seconds;
		              easing: BlLinearInterpolator new;
		              target: spinner;
						  beInfinite;
		              yourself ).
		
	
	transparent := BlElement new.
	transparent layout: BlFrameLayout new.
	transparent background: (Color gray alpha: 0.5).
	transparent constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	
	transparent addChild: spinner.
	
	useCompositionLayer ifTrue: [ 
		transparent beInSingleCompositionLayer].
	
	self container addChild: transparent as: #layoverSpinner.

]

{ #category : 'operations' }
CSPClientWindow >> doChangeUseCompositionLayer [

	self container children do: [ :aChild |
		useCompositionLayer
			ifTrue: [ aChild beInSingleCompositionLayer ]
			ifFalse: [ aChild beWithoutCompositionLayer ] ]
]

{ #category : 'operations' }
CSPClientWindow >> doRemoveSpinner [

	self layoverSpinner 
		ifNotNil: [ :layover | self container removeChild: layover ]

]

{ #category : 'operations' }
CSPClientWindow >> doReset [
	
	CSPClient reset.
	self updateData.
]

{ #category : 'operations' }
CSPClientWindow >> doStart [

	self client start.
	self client whenMessageReceivedDo: [
		self space ifNotNil: [ :space |
			space universe defer: [ self updateData ] ] ].
	self updateData
]

{ #category : 'operations' }
CSPClientWindow >> doStop [
	
	self client stop.
	self client whenMessageReceivedDo: [].
	self updateData.
]

{ #category : 'operations' }
CSPClientWindow >> ensureStopped [
	
	self client stop
]

{ #category : 'accessing' }
CSPClientWindow >> fpsText [

	^ self childWithId: #fpsText
]

{ #category : 'accessing' }
CSPClientWindow >> hasSpinnerCheckbox [

	^ self childWithId: #hasSpinnerCheckbox
]

{ #category : 'accessing' }
CSPClientWindow >> initialExtent [.

	^ 800@800
]

{ #category : 'initialization' }
CSPClientWindow >> initialize [

	super initialize.
	
	useCompositionLayer := false.
	hasSpinner := false.

	self addChild: (self createClientInfo).
	self addChild: (self createButtons).
	self addChild: (self createControls).
	self addChild: (self createComplexElement) as: #container.
	
	self fpsText disabled: true.
	self registerEvents.

	self doAddOrRemoveSpinner.
	self doChangeUseCompositionLayer.
	
	self updateData.
]

{ #category : 'accessing' }
CSPClientWindow >> layoverSpinner [

	^ self childWithId: #layoverSpinner ifNone: [ nil ]
]

{ #category : 'instance creation' }
CSPClientWindow >> open [ 

	super open.

	self space enableStatistics.
	self space spaceStatistics registerListener: self.
]

{ #category : 'operations' }
CSPClientWindow >> refresh [

	self fpsText text: self space spaceStatistics fps printString asRopedText.
]

{ #category : 'initialization - elements' }
CSPClientWindow >> registerEvents [

	self hasSpinnerCheckbox whenClickedDo: [ :event |
		hasSpinner := event currentTarget isChecked.
		self doAddOrRemoveSpinner ].
	
	self useCompositionLaterCheckbox whenClickedDo: [ :event |
		useCompositionLayer := event currentTarget isChecked.
		self doChangeUseCompositionLayer].
	
	self clientUrl whenSaveRequestedDo: [ :req | self updateClientUrl: req ].
	self clientDelay whenSaveRequestedDo: [ :req | self updateClientDelay: req ].

	self stopButton whenClickedDo: [ self doStop ].
	self startButton whenClickedDo: [ self doStart ].	
	self resetButton whenClickedDo: [ self doReset ]
]

{ #category : 'private - updating' }
CSPClientWindow >> updateClientDelay: request [

	[
		| delay |
		delay := self clientDelay text asString asDuration.
		self client delay: delay.
		request accepted: true.
		self errorLabelDelay text: '' asRopedText ] 
	onErrorDo: [ :e |
			self errorLabelDelay text: e messageText asRopedText ]
]

{ #category : 'private - updating' }
CSPClientWindow >> updateClientUrl: request [

	[
		| url |
		url := self clientUrl text asString asZnUrl.
		self client url: url.
		request accepted: true.
		self errorLabelAddress text: '' asRopedText ] 
	onErrorDo: [ :e |
			self errorLabelAddress text: e messageText asRopedText ]
]

{ #category : 'private - updating' }
CSPClientWindow >> updateData [
	
	self clientUrl text: (self client url) printString asRopedText.
	self clientUrl disabled: (self client isRunning).

	((self clientUrl text asString ~= (self client delay) printString) and: [ self clientDelay edited not])
		ifTrue: [ self clientDelay text: (self client delay) printString asRopedText].	

	self numberOfMessages 
		text: (self client messagesReceived) printString asRopedText;
		enabled: false.
		
	self startButton disabled: (self client isRunning).
	self stopButton disabled: (self client isRunning) not.	
]

{ #category : 'accessing' }
CSPClientWindow >> useCompositionLaterCheckbox [

	^ self childWithId: #useCompositionLaterCheckbox
]
