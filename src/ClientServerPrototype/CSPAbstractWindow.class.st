Class {
	#name : 'CSPAbstractWindow',
	#superclass : 'ToElement',
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'helpers' }
CSPAbstractWindow >> addButton: buttonId withLabel: buttonLabel [

	^ ToButton new
		id: buttonId;
		labelText: buttonLabel asRopedText;
		margin: (BlInsets all: 5);
		yourself
]

{ #category : 'helpers' }
CSPAbstractWindow >> addCheckbox: checkBoxId withLabel: label [

	^ ToCheckbox new
		id: checkBoxId;
		labelText: label asRopedText;
		margin: (BlInsets all: 5);
		yourself
]

{ #category : 'helpers' }
CSPAbstractWindow >> addLabel: labelId [

	^ ToElement new
		  layout: BlLinearLayout horizontal alignCenter;
		  hMatchParent;
		  vFitContent;
		  padding: (BlInsets all: 5);
		  addChild: (ToLabel new
					beMultiLine;
				   padding: (BlInsets all: 5);
				   hMatchParent)
		  as: labelId;
		  yourself
]

{ #category : 'helpers' }
CSPAbstractWindow >> addTextInput: textInputId withLabel: labelText [

	^ ToElement new
		  layout: BlLinearLayout horizontal alignCenter;
		  hMatchParent;
		  vFitContent;
		  padding: (BlInsets all: 5);
		  addChild: (ToLabel new
				   text: labelText asRopedText;
				   padding: (BlInsets all: 5);
				   width: 100);
		  addChild: (ToTextField new
					withSaveCapability;
				   padding: (BlInsets all: 5))
		  as: textInputId;
		  yourself
]

{ #category : 'operations' }
CSPAbstractWindow >> close [
	
	self ensureStopped.
	self space ifNotNil: [ :aSpace | aSpace close].
]

{ #category : 'initialization - elements' }
CSPAbstractWindow >> createButtons [
	
	^ ToElement new
			layout: BlLinearLayout horizontal alignCenterRight;
			hMatchParent;
			vFitContent;
			addChild: (self addButton: #startButton withLabel: 'Start');
			addChild: (self addButton: #stopButton withLabel: 'Stop');
			addChild: (self addButton: #resetButton withLabel: 'Reset');
			yourself
]

{ #category : 'operations' }
CSPAbstractWindow >> ensureStopped [
	
	self subclassResponsibility 
]

{ #category : 'accessing' }
CSPAbstractWindow >> errorLabelAddress [

	^ self childWithId: #errorLabelAddress
]

{ #category : 'accessing' }
CSPAbstractWindow >> errorLabelDelay [

	^ self childWithId: #errorLabelDelay
]

{ #category : 'accessing' }
CSPAbstractWindow >> initialExtent [.

	self subclassResponsibility 
]

{ #category : 'initialization' }
CSPAbstractWindow >> initialize [

	super initialize.

	self vMatchParent.
	self hMatchParent.
	
	self layout: BlLinearLayout vertical.
	
	self addEventHandlerOn: BlElementAddedToParentEvent do: [
		self space
			addEventHandlerOn: BlSpaceClosedEvent
			do: [ self ensureStopped ] ].


]

{ #category : 'accessing' }
CSPAbstractWindow >> numberOfMessages [

	^ self childWithId: #numberOfMessages
]

{ #category : 'instance creation' }
CSPAbstractWindow >> open [
	
	| space |
	
	space := self inSpace.
	space addEventHandlerOn: BlSpaceShownEvent do: [ space center ].
	space addEventHandlerOn: BlSpaceClosedEvent do: [ self ensureStopped ].
	space resizable: false.
	space extent: self initialExtent.
	space show.

]

{ #category : 'accessing' }
CSPAbstractWindow >> resetButton [

	^ self childWithId: #resetButton
]

{ #category : 'accessing' }
CSPAbstractWindow >> startButton [

	^ self childWithId: #startButton
]

{ #category : 'accessing' }
CSPAbstractWindow >> stopButton [

	^ self childWithId: #stopButton
]
