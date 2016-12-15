import {
    ValidationRenderer,
    RenderInstruction,
    ValidationError
} from 'aurelia-validation';

export class BootstrapFormRenderer {
    render(instruction) {
        for (let {
                result,
                elements
            }
            of instruction.unrender) {
            for (let element of elements) {
                this.remove(element, result);
            }
        }
        for (let {
                result,
                elements
            }
            of instruction.render) {
            for (let element of elements) {
                this.add(element, result);
            }
        }
    }
    add(element, result) {
        if (!element) {
            return;
        }
        const formGroup = element.closest('.form-group');
        if (!formGroup) return;

        if (result.valid) {
            if (!formGroup.classList.contains('has-error')) formGroup.classList.add('has-success');
        } else {
            formGroup.classList.remove('has-success')
            formGroup.classList.add('has-error');
            const message = document.createElement('span');
            message.className = 'help-block validation-message';
            message.textContent = result.message;
            message.id = `validation-message-${result.id}`;
            element.parentNode.insertBefore(message, element.nextSibling);
        }
    }

    remove(element, result) {
        const formGroup = element.closest('.form-group');
        if (!formGroup) return;
        if (result.valid) {
            if (formGroup.classList.contains('has-success')) formGroup.classList.remove('has-success');
        } else {
            const message = formGroup.querySelector(`#validation-message-${result.id}`);
            if (message) {
                element.parentNode.removeChild(message);
                if (formGroup.querySelectorAll('.help-block.validation-message').length === 0) {
                    formGroup.classList.remove('has-error');
                }
            }
        }


    }
}