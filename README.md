# CWL-WRAPPER

- [Requirements](#requirements)
- [requirements](#requirements.txt)
- [Run](#run) 
- [Configuration file](#configuration-file)
- [Package configuration file](#configuration-file-help)
- [Configuration file details](#configuration-file-details)
- [Templates](#templates)


## Requirements

- Python
- console 

## Python requirements

- jinja2
- pyyaml
- click


## Run 


## Configuration file


### Configuration file help

```yaml
rulez:
  version: 1

parser:
  driver: cwl

onstage:
  driver: cwl

  stage_in:
    connection_node: node_stage_in
    if_scatter:
      scatterMethod: dotproduct

  on_stage:
    connection_node: on_stage

  stage_out:
    connection_node: node_stage_out


output:
  driver: cwl
  name: '-'
  type: $graph


cwl:
  Directory:
    type: Directory
    inputBinding:
      position: 1

  Directory[]:
    type: Directory[]
    inputBinding:
      position: 1

  outputBindingResult:
    command:
      outputBinding:
        glob: .
      type: Directory
    stepOut:
      type:
        items: Directory
        type: array
```

#### Configuration file details

```yaml
rulez:
  version: 1
```

`rulez -> version` defines the Rules version. Currently only version 1 is managed  

---

```yaml
parser:
  driver: cwl
```

`parser -> driver` defines the type of objects to be parsed

---

```yaml
onstage:
  driver: cwl

  stage_in:
    connection_node: node_stage_in
    if_scatter:
      scatterMethod: dotproduct

  on_stage:
    connection_node: on_stage

  stage_out:
    connection_node: node_stage_out
```

The `onstage` configuration is applied to `maincwl.yaml` file 

`onstage -> driver` defines the driver to use during the translation: The result must be a `CWL` format

`onstage -> stage_in` 

`onstage -> stage_in -> connection_node` defines the anchor node name for `stage-in` start. If the node does not exist, the parser creates it.

`onstage -> stage_in -> if_scatter` defines the conditions for `scatter` methods

`onstage -> stage_in -> if_scatter -> scatterMethod` is the method to use for scatter feature

`onstage -> on_stage`

`onstage -> on_stage -> connection_node`  defines the anchor node name for `user's node`. If the node does not exist, the parser creates it.

`onstage -> stage_out -> connection_node` defines the anchor node name for `stage-out` start. If the node does not exist, the parser creates it.

The `stage_in`, `stage_out` and `on-stage` nodes can be customized by user. 

The Parser uses the node name as an anchor to start the phase.  

Base template

```yaml
class: Workflow
doc: Main stage manager
id: stage-manager
label: theStage
inputs: []
outputs: {}

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
```

Custom template

```yaml
class: Workflow
doc: Main stage manager
id: stage-manager
label: theStage
inputs:
  - id: test
    type: string
outputs: {}

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

steps:
  node_stage_in:
    in:
      test: test
    out: []
    run: ''
##
#  on_stage:
#    in: {}
#    out: []
#    run: ''
#
#  node_stage_out:
#    in: []
#    out: []
#    run: ''
```

Custom template output:

```yaml
$graph:
- class: Workflow
  doc: Main stage manager
  id: stage-manager
  inputs:
  
  # template var
  - id: test
    type: string
 
  # USER's CWL input
  - doc: EO product for vegetation index  
    id: input_reference
    label: EO product for vegetation index
    stac:catalog:
      stac:collection: input_reference
    type: Directory[]
 ....
 ....
 ....
 ....

  label: theStage
  outputs:

 ....
 ....
 ....

  requirements:
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
  steps:
    node_stage_in:
      in:
        
        # USER's CWL input
        input_reference: input_reference
        
        # template var
        test: test
      out:
      - input_reference_out
```

---

```yaml
output:
  driver: cwl
  name: '-'
  type: $graph
```

`output -> driver` defines the output driver, currently is defined only 'CWL' driver

`output -> name` this parameter is deprecated

`output -> type` defines the type of output

* `$graph` if driver is `CWL` the output will be in one file using 
[`$graph` entry point](https://www.commonwl.org/v1.1/SchemaSalad.html#Document_graph)

---




```yaml
cwl:
  Directory:
    type: Directory
    inputBinding:
      position: 1

  Directory[]:
    type: Directory[]
    inputBinding:
      position: 1

  outputBindingResult:
    command:
      outputBinding:
        glob: .
      type: Directory
    
    stepOut:
      type:
        items: Directory
        type: array
```

template

`cwl -> Directory`

`cwl -> Directory[]`

`cwl -> outputBindingResult`

`cwl -> outputBindingResult -> command`

`cwl -> outputBindingResult -> stepOut`


## Templates

### stage in

File: `stagein.yaml` 

```yaml
class: CommandLineTool
baseCommand: echo
label:
doc: docs
inputs: {}
outputs: {}
```

### main

File: `maincwl.yaml`

```yaml
class: Workflow
doc: Main stage manager
id: stage-manager
label: theStage
inputs: []
outputs: {}

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

#steps:
#  node_stage_in:
#    in: {}
#    out: []
#    run: ''
##
#  on_stage:
#    in: {}
#    out: []
#    run: ''
#
#  node_stage_out:
#    in: []
#    out: []
#    run: ''
```

### stage out

File: `stageout.yaml`

```yaml
class: CommandLineTool
baseCommand: echo
label:
doc: docs
inputs: {}
outputs: {}
```


