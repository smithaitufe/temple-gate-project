import { inject, Aurelia } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { ValidationControllerFactory, ValidationRules } from 'aurelia-validation';
import { BootstrapFormRenderer } from '../../resources/renderers/bootstrap-form-renderer';
import { SessionService } from '../../services';

@inject(Aurelia, Router, ValidationControllerFactory, SessionService)
export class Login {
    email;
    password;

    constructor(aurelia, router, controllerFactory, sessionService) {
        this.aurelia = aurelia;
        this.router = router;
        this.controller = controllerFactory.createForCurrentScope();
        this.controller.addRenderer(new BootstrapFormRenderer());
        this.sessionService = sessionService;


        ValidationRules
            .ensure("email").required().withMessage("Email is required")
            .ensure("password").required()
            .on(this);
    }

    loginClicked() {
        this.sessionService.login(this.email, this.password).then(response => {
            const { user, token } = response;
            this.sessionService.setToken(token);
            this.router.navigate("/", { replace: true, trigger: false });
            this.aurelia.setRoot("private-section/private-section").then(() => { this.router.refreshNavigation(); })
        })
    }
}
