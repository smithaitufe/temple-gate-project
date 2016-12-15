import { inject } from 'aurelia-framework';
import { ProgramService } from '../../../services';

@inject(ProgramService)
export class Programs {

    programs = [];

    constructor(programService) {
        this.programService = programService;
    }
    activate() {
        this.programService.getPrograms().then(response => { this.programs = response; })
    }
}