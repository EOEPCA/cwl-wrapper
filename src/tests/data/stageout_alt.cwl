cwlVersion: v1.0
baseCommand: Stars
doc: "Run Stars for staging results"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: terradue/stars:2.4.0
  "cwltool:Secrets":
    secrets:
    - ADES_STAGEOUT_AWS_SERVICEURL
    - ADES_STAGEOUT_AWS_ACCESS_KEY_ID
    - ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY
id: stars
arguments:
  - copy
  - -v
  - -r
  - '4'
  - -o
  - $( inputs.ADES_STAGEOUT_OUTPUT + "/" + inputs.process )
  - valueFrom: |
            ${
                if( !Array.isArray(inputs.wf_outputs) )
                {
                    return inputs.wf_outputs.path + "/catalog.json";
                }
                var args=[];
                for (var i = 0; i < inputs.wf_outputs.length; i++)
                {
                    args.push(inputs.wf_outputs[i].path + "/catalog.json");
                }
                return args;
            }
inputs:
  ADES_STAGEOUT_AWS_SERVICEURL:
    type: string?
  ADES_STAGEOUT_AWS_ACCESS_KEY_ID:
    type: string?
  ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY:
    type: string?
  ADES_STAGEOUT_OUTPUT:
    type: string?
  ADES_STAGEOUT_AWS_REGION:
    type: string?
  process:
    type: string
outputs:
  s3_catalog_output:
    outputBinding:
      outputEval: ${ return inputs.ADES_STAGEOUT_OUTPUT + "/" + inputs.process + "/catalog.json"; }
    type: string
requirements:
  InlineJavascriptRequirement: {}
  EnvVarRequirement:
    envDef:
      PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      AWS__ServiceURL: $(inputs.ADES_STAGEOUT_AWS_SERVICEURL)
      AWS__Region: $(inputs.ADES_STAGEOUT_AWS_REGION)
      AWS__AuthenticationRegion: $(inputs.ADES_STAGEOUT_AWS_REGION)
      AWS_ACCESS_KEY_ID: $(inputs.ADES_STAGEOUT_AWS_ACCESS_KEY_ID)
      AWS_SECRET_ACCESS_KEY: $(inputs.ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY)
  ResourceRequirement: {}
