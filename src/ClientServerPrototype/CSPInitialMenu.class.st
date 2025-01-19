Class {
	#name : 'CSPInitialMenu',
	#superclass : 'ToElement',
	#instVars : [
		'serverWindow',
		'clientWindow'
	],
	#category : 'ClientServerPrototype',
	#package : 'ClientServerPrototype'
}

{ #category : 'instance creation' }
CSPInitialMenu >> closeAll [
	
	serverWindow ifNotNil: [ serverWindow close ].
	clientWindow ifNotNil: [ serverWindow close ]	
]

{ #category : 'initialization' }
CSPInitialMenu >> createOpenClientButton [

	^ (ToButton new labelText:'Open Client')
			tooltipText: 'Opens the client';
			margin: (BlInsets all: 10);
			whenClickedDo: [ clientWindow := CSPClientWindow new open ]
]

{ #category : 'initialization' }
CSPInitialMenu >> createOpenServerButton [

	^ (ToButton new labelText:'Open Server')
			tooltipText: 'Opens the server config and runs it';
			margin: (BlInsets all: 10);
			whenClickedDo: [ serverWindow := CSPServerWindow new open ].
	
	
]

{ #category : 'initialization' }
CSPInitialMenu >> initialize [

	super initialize.

	self vMatchParent.
	self hMatchParent.

	self layout: BlFlowLayout horizontal alignCenter.
	
	self
		addChild: (ToLabel new
				text: 'Simple Client Server using Toplo/Bloc' asRopedText;
				hMatchParent;
				beMultiLine;
				margin: (BlInsets left: 5); 
				yourself).

	self addChild: (ToElement new
		hMatchParent;
		vFitContent; 
		layout: BlFlowLayout horizontal alignCenter;
		addChild: self createOpenServerButton as: #openServerButton;
		addChild: self createOpenClientButton as: #openClientButton;
		yourself).
		
]

{ #category : 'initialization' }
CSPInitialMenu >> open [

	| space |
	space := self inSpace.
	space addEventHandlerOn: BlSpaceClosedEvent do: [ self closeAll ].
	space extent: 250 @ 150.
	space position: 0@ 0.
	
	space show.
]
