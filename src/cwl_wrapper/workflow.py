from .utils import looking_for
from .cwl.t2cwl import Workflow as CWLWorkflow
from .rulez import Rulez


class Directory:
    is_array = False
    id: str = None

    def __init__(self, id: str, is_array, raw=None):
        self.id = id
        self.is_array = is_array
        self.raw = raw

    def __str__(self):
        return str({'id': self.id, 'is_array': self.is_array})


def parse_cwl_param_directory(vals: dict):
    res = []
    for it in vals:
        cwl_param = vals[it]
        if cwl_param.type == "Directory":
            res.append(Directory(cwl_param.id, False, cwl_param))

        elif cwl_param.type == "array":
            for it in cwl_param.items:
                if type(it) == str and it == 'Directory':
                    res.append(Directory(cwl_param.id, True, cwl_param))
                    break

    return res


class Workflow:
    wf = None
    driver = None

    def __init__(self, args, rulez: Rulez):
        # print(args)
        if rulez.get('/parser/driver') == 'cwl':
            self.wf = CWLWorkflow(args['cwl'])
            self.driver = 'cwl'
        else:
            raise ValueError('Rules driver not found or unknown')

    def get_raw_all_inputs(self):
        return self.wf.raw_all_inputs

    def get_raw_all_outputs(self):
        return self.wf.raw_all_outputs

    def get_raw_inputs(self):
        return self.wf.get_inputs()

    def get_raw_outputs(self):
        return self.wf.get_outputs()

    def get_inputs_directory(self):
        if self.driver == 'cwl':
            return parse_cwl_param_directory(self.get_raw_inputs())

    def get_outputs_directory(self):
        if self.driver == 'cwl':
            return parse_cwl_param_directory(self.get_raw_outputs())

    def get_raw_workflow(self):
        return self.wf.get_raw_workflow()

    def get_id(self):
        if self.driver == 'cwl':
            return self.wf.id

        return ''

    def __str__(self):
        return 'workflow'  # "#self.wf['id']


class CWL:
    pass
