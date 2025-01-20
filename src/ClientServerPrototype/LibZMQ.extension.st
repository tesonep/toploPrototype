Extension { #name : 'LibZMQ' }

{ #category : '*ClientServerPrototype' }
LibZMQ >> macLibraryName [

	^ FFIMacLibraryFinder findLibrary: 'libzmq.dylib'
]
