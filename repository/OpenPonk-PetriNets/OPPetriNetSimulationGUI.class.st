"
I'm DCSimulationGUI for Petri nets
"
Class {
	#name : #OPPetriNetSimulationGUI,
	#superclass : #OPSimulationGUI,
	#category : 'OpenPonk-PetriNets-Simulation'
}

{ #category : #hooks }
OPPetriNetSimulationGUI class >> simulableControllerClasses [
	"collection of element controllers whose single simulators can be fired independently
	for example: in Petri nets, only transitions are simulable = one specific transition can be fired"

	^ OPPetriNetTransitionController asOrderedCollection
]

{ #category : #toolbar }
OPPetriNetSimulationGUI class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPPetriNetsPlugin>
	self toolbarMenuItemFor: aBuilder
]

{ #category : #'private - hooks' }
OPPetriNetSimulationGUI >> buttonItems [
	^ super buttonItems
		add:
			((self instantiate: ButtonModel)
				label: 'Pause';
				iconName: #testYellow;
				help: 'Pause stepping';
				action: [ self diagramSimulator stop ]);
		add:
			((self instantiate: ButtonModel)
				label: 'Play (random)';
				iconName: #smallPrintItIcon;
				help: 'Step random element every second';
				action: [ self diagramSimulator repeat ]);
		add:
			((self instantiate: ButtonModel)
				label: 'Step (random)';
				iconName: #forwardIcon;
				help: 'Step random element once';
				action: [ self diagramSimulator step ]);
		add:
			((self instantiate: ButtonModel)
				label: 'Step (all)';
				iconName: #glamorousThrough;
				help: 'Step all enabled elements once';
				action: [ self diagramSimulator
						setSteppingAll;
						step;
						setDefaultStepping ]);
		yourself
]

{ #category : #'private - hooks' }
OPPetriNetSimulationGUI >> loadSimulation [
	"prepares simulation - called with every reload"

	super loadSimulation.
	diagramSimulator
		simulableElementsDo: [ :element | 
			element
				when: OPSimulatorDidAction
				do: [ :event | 
					event index = 2
						ifTrue: [ 
							| controller prevColor |
							controller := self diagramController controllerForModel: event simulator model.
							prevColor := controller figure color.
							controller figure color: Color lightBlue.
							controller refreshFigure.
							[ 
							(Delay forMilliseconds: 200) wait.
							controller figure color = prevColor
								ifFalse: [ 
									controller figure color: Color transparent.
									controller refreshFigure ] ] fork ] ] ]
]

{ #category : #'private - hooks' }
OPPetriNetSimulationGUI >> simulatorClass [
	^ OPPetriNetSimulator
]
