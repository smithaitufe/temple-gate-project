import { inject } from 'aurelia-framework';
import { ValidationControllerFactory, ValidationRules, validateTrigger } from 'aurelia-validation';
import { BootstrapFormRenderer } from '../../../resources/renderers/bootstrap-form-renderer';

@inject(ValidationControllerFactory)
export class Password {
    entity = {};
    constructor(controllerFactory) {
        this.controller = controllerFactory.createForCurrentScope();
        this.controller.addRenderer(new BootstrapFormRenderer());
        this.controller.validateTrigger = validateTrigger.blur;

        ValidationRules
            .ensure(e => e.old_password).displayName("Old Password").required()
            .ensure(e => e.password).displayName("Password").required()
            .ensure(e => e.password_confirmation).displayName("Password confirmation").required().satisfies((src, obj) => { return src == obj.password })
            .on(this.entity)
    }
    changeClicked() {

    }
}
