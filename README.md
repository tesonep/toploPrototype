# Client Server Prototype

This simple prototype uses ZMQ as communication, and it shows how to handle the update of the messages and how using CompositionLayers are needed when we have an spinner.

To install:

```smalltalk
Metacello new
        baseline: 'ClientServerPrototype';
        repository: 'github://tesonep/toploPrototype:main/src';
		  onConflictUseLoaded;
        load.
```

To Run:

```smalltalk
CSPServerWindow new open.
CSPClientWindow new open.
```

