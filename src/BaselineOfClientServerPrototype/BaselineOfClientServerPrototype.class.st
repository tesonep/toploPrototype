Class {
	#name : 'BaselineOfClientServerPrototype',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfClientServerPrototype',
	#package : 'BaselineOfClientServerPrototype'
}

{ #category : 'baselines' }
BaselineOfClientServerPrototype >> baseline: spec [
	<baseline>

	spec
		for: #common
		do: [ 

			spec
				baseline: 'Alexandrie' with: [ spec repository: 'github://pharo-graphics/Alexandrie:dev/src' ];
				baseline: 'Bloc' with: [ spec repository: 'github://pharo-graphics/Bloc:dev/src' ];
				baseline: 'Album' with: [ spec repository: 'github://pharo-graphics/Album:dev/src'  ];
				baseline: 'Toplo' with: [ spec repository: 'github://pharo-graphics/Toplo:dev/src' ];
				baseline: 'PharoZeroMQ' with: [ spec repository: 'github://OpenSmock/PharoZeroMQ:main/src' ].
				
			spec
				package: 'ClientServerPrototype'
					with: [ spec requires: #('Alexandrie' 'Bloc' 'Album' 'Toplo' 'PharoZeroMQ') ]
		].
]
